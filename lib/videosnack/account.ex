defmodule Videosnack.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :domain, :string
    field :name, :string
    belongs_to :plan, Videosnack.Plan
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs \\ %{}) do
    account
    |> cast(attrs, [:slug, :name, :domain, :plan_id])
    |> validate_required([:slug, :name, :plan_id])
    |> unique_constraint(:slug)
  end
end
