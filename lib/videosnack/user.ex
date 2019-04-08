defmodule Videosnack.User do
  alias __MODULE__

  use Ecto.Schema
  import Ecto.Changeset

  alias Videosnack.Repo

  schema "users" do
    field :email, :string
    field :name, :string
    field :provider, :string
    field :token, :string
    field :root, :boolean, default: false

    timestamps()
  end

  def authenticate_oauth("github" = provider, %{info: info, credentials: %{token: token}}) do
    authenticate_oauth(%{name: info.name, email: info.email, avatar_url: info.image, provider: provider, token: token})
  end

  def authenticate_oauth(attrs) do
    cs = changeset(%User{}, attrs)

    case Repo.get_by(User, email: cs.changes.email) do
      nil -> Repo.insert(cs)
      user -> {:ok, user}
    end
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :email, :provider, :token, :root])
    |> validate_required([:email])
  end
end
