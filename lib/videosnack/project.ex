defmodule Videosnack.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :description, :string
    field :distribution, :string
    field :first_published_at, :utc_datetime
    field :first_purchased_at, :utc_datetime
    field :name, :string
    field :price_cents, :integer
    field :published_at, :utc_datetime
    belongs_to :account, Videosnack.Account

    timestamps()
  end

  @doc false
  def changeset(project, attrs \\ %{}) do
    project
    |> cast(attrs, [:name, :published_at, :first_published_at, :first_purchased_at, :description, :distribution, :price_cents])
    |> validate_required([:name, :distribution])
    |> validate_inclusion(:distribution, ~w(free subscription purchase))
  end
end
