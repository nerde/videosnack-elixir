defmodule Videosnack.User do
  alias __MODULE__

  use Ecto.Schema
  import Ecto.Changeset

  alias Videosnack.Repo
  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :name, :string
    field :encrypted_password, :string
    field :provider, :string
    field :token, :string
    field :root, :boolean, default: false

    timestamps()
  end

  def authenticate(%{"email" => email, "encrypted_password" => password} = attrs) do
    cs = changeset(%User{}, attrs)
    case apply_action(cs, :insert) do
      {:ok, _} ->
        case Repo.get_by(User, email: email) do
          nil -> Repo.insert(cs)
          user ->
            case Comeonin.Bcrypt.check_pass(user, password) do
              {:ok, user} -> {:ok, user}
              {:error, _} -> {:error, Map.put(add_error(cs, :encrypted_password, "Invalid password"), :action, :insert)}
            end
        end
      {:error, cs} -> {:error, cs}
    end
  end

  def authenticate_oauth("github" = provider, %{info: info, credentials: %{token: token}}) do
    authenticate_oauth(%{name: info.name, email: info.email, avatar_url: info.image, provider: provider, token: token,
                         encrypted_password: generate_password()})
  end

  def authenticate_oauth(attrs) do
    cs = changeset(%User{}, attrs)

    case Repo.get_by(User, email: cs.changes.email) do
      nil -> Repo.insert(cs)
      user -> {:ok, user}
    end
  end

  defp generate_password do
    length = 16
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, ~w(name email encrypted_password)a)
    |> validate_required(~w(email encrypted_password)a)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:encrypted_password, min: 8)
    |> unique_constraint(:email)
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end
end
