defmodule VideosnackWeb.UploadController do
  use VideosnackWeb, :controller

  alias Videosnack.{Repo, Upload}

  plug VideosnackWeb.Plugs.RequireUser

  def presign(%{assigns: %{current_account: account}} = conn, params) do
    {changeset, presigned_url} = Upload.presign(account, params)

    case Repo.insert(changeset) do
      {:ok, upload} ->
        json(conn, %{presigned_url: presigned_url})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(errors: changeset.errors)
    end
  end
end
