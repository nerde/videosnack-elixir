defmodule Videosnack.Episode do
  use Ecto.Schema
  import Ecto.Changeset

  alias Videosnack.Distribution

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
  def changeset(episode, attrs \\ %{}) do
    episode
    |> cast(attrs, ~w(name description content license distribution price_cents)a)
    |> validate_required(~w(name license distribution)a)
    |> validate_inclusion(:distribution, Distribution.kinds)
  end
end
