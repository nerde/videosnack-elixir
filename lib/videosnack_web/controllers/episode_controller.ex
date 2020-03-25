defmodule VideosnackWeb.EpisodeController do
  use VideosnackWeb, :controller

  alias Videosnack.{Account, Episode, Repo, Upload}

  plug VideosnackWeb.Plugs.RequireUser

  def new(conn, _params) do
    changeset = Episode.changeset(%Episode{})
    render(conn, :new, changeset: changeset)
  end

  def create(%{assigns: %{current_account: account}} = conn, %{"episode" => %{"file" => file_params} = params}) do
    unique_filename = "public/account-#{account.id}/videos/#{UUID.uuid4(:hex)}-#{file_params.filename}"

    %{size: bytes} = File.stat!(file_params.path)
    {:ok, data} = File.read(file_params.path)

    bucket_name = System.get_env("BUCKET_NAME")
    object = ExAws.S3.put_object(bucket_name, unique_filename, data, acl: :public_read) |> ExAws.request!
    ExAws.S3.presigned_url(
      ExAws.Config.new(:s3),
      :put,
      bucket_name,
      unique_filename,
      query_params: [{"ContentType", "mp4"}, {"ContentLength", 0}, {"ACL", "public-read"}])

    url = "https://#{bucket_name}.s3.amazonaws.com/#{bucket_name}/#{unique_filename}"

    upload_params = Map.merge(file_params, %{
      original_name: file_params.filename,
      account_id: account.id,
      url: url,
      size_bytes: bytes
    })

    IO.inspect(upload_params)
    changeset = Upload.changeset(%Upload{}, upload_params)
    case Repo.insert(changeset) do
      {:ok, upload} ->
        # conn
        # |> put_flash(:info, "Image uploaded successfully!")
        # |> redirect(to: upload_path(conn, :new))
        render(conn, :new, changeset: Episode.changeset(%Episode{}))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def upload(%{assigns: %{current_account: account}} = conn, params) do
    %{"filename" => filename, "size_bytes" => size, "content_type" => type} = params

    unique_filename = "public/account-#{account.id}/videos/#{UUID.uuid4(:hex)}-#{filename}"
    bucket_name = System.get_env("BUCKET_NAME")
    url = "https://#{bucket_name}.s3.amazonaws.com/#{bucket_name}/#{unique_filename}"

    presigned_url = ExAws.S3.presigned_url(
      ExAws.Config.new(:s3),
      :put,
      bucket_name,
      unique_filename,
      query_params: [{"ContentType", type}, {"ContentLength", size}, {"ACL", "public-read"}])

    upload_params = %{
      original_name: filename,
      account_id: account.id,
      url: url,
      size_bytes: size
    }

    changeset = Upload.changeset(%Upload{}, upload_params)
    case Repo.insert(changeset) do
      {:ok, upload} ->
        render(conn, "upload.json", presigned_url: presigned_url)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
    end
  end
end
