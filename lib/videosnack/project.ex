defmodule Videosnack.Project do
  use Ecto.Schema
  import Ecto.Changeset

  alias Videosnack.Slug
  alias Videosnack.Distribution

  schema "projects" do
    field :description, :string
    field :distribution, :string
    field :first_published_at, :utc_datetime
    field :first_purchased_at, :utc_datetime
    field :name, :string
    field :price_cents, :integer
    field :published_at, :utc_datetime
    field :slug, :string
    belongs_to :account, Videosnack.Account

    timestamps()
  end

  @doc false
  def changeset(project, attrs \\ %{}) do
    project
    |> cast(attrs, ~w(name slug description distribution price_cents)a)
    |> validate_required(~w(name slug distribution account_id)a)
    |> validate_inclusion(:distribution, Distribution.kinds)
    |> validate_exclusion(:slug, Slug.reserved)
    |> unique_constraint(:slug, name: :projects_slug_account_id_index)
  end
end
