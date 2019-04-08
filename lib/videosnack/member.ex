defmodule Videosnack.Member do
  alias __MODULE__

  alias Videosnack.Repo

  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    field :role, :string
    field :account_id, :id
    field :user_id, :id

    timestamps()
  end

  def sign_up!(user, account) do
    Repo.insert!(changeset(%Member{}, %{user_id: user.id, account_id: account.id, role: "owner"}))
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:role, :account_id, :user_id])
    |> validate_required([:role, :account_id, :user_id])
    |> validate_inclusion(:role, ["owner", "admin"])
  end
end
