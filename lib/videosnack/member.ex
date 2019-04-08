defmodule Videosnack.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    field :role, :string
    field :account_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:role, :account_id, :user_id])
    |> validate_required([:role, :account_id, :user_id])
  end
end
