defmodule Videosnack.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  schema "uploads" do
    field :content_type, :string
    field :original_name, :string
    field :size_bytes, :integer
    field :url, :string
    field :uploaded, :boolean
    belongs_to :account, Videosnack.Account

    timestamps()
  end

  def presign(account, params) do
    %{"name" => name, "size" => size, "type" => type} = params

    unique_filename = generate_unique_filename(account, name)

    presigned_url = ExAws.S3.presigned_url(ExAws.Config.new(:s3), :put, bucket_name, unique_filename,
      query_params: [{"ContentType", type}, {"ContentLength", size}, {"ACL", "public-read"}])

    upload_params = %{
      original_name: name,
      account_id: account.id,
      url: public_url_for(unique_filename),
      size_bytes: size,
      content_type: type
    }

    {changeset(%Videosnack.Upload{}, upload_params), presigned_url}
  end

  def public_url_for(name) do
    "https://#{bucket_name}.s3.amazonaws.com/#{bucket_name}/#{name}"
  end

  def bucket_name do
    System.get_env("BUCKET_NAME")
  end

  def generate_unique_filename(account, original_name) do
    "public/account-#{account.id}/videos/#{UUID.uuid4(:hex)}-#{original_name}"
  end

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, ~w(original_name content_type url size_bytes account_id)a)
    |> validate_required(~w(original_name content_type url size_bytes account_id)a)
    |> validate_number(:size_bytes, less_than: 100 * 1024 * 1024)
  end
end
