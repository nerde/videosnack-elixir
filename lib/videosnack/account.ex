defmodule Videosnack.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Videosnack.Slug

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
    |> cast(attrs, ~w(slug name domain plan_id)a)
    |> validate_required(~w(slug name plan_id)a)
    |> unique_constraint(:slug)
    |> validate_exclusion(:slug, Slug.reserved)
    |> unique_constraint(:slug)
  end
end
