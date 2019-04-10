defmodule Videosnack.Episode do
  use Ecto.Schema
  import Ecto.Changeset

  schema "episodes" do
    field :content, :string
    field :description, :string
    field :distribution, :string
    field :duration_seconds, :integer
    field :first_published_at, :utc_datetime
    field :first_purchased_at, :utc_datetime
    field :license, :string
    field :name, :string
    field :price_cents, :integer
    field :published_at, :utc_datetime
    field :account_id, :id
    field :project_id, :id

    timestamps()
  end

  @doc false
  def changeset(episode, attrs) do
    episode
    |> cast(attrs, [:name, :description, :content, :license, :duration_seconds, :distribution, :published_at, :first_published_at, :first_purchased_at, :price_cents])
    |> validate_required([:name, :license, :distribution])
    |> validate_inclusion(:distribution, ~w(free subscription purchase))
  end
end
