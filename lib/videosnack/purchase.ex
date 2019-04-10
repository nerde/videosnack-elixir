defmodule Videosnack.Purchase do
  use Ecto.Schema
  import Ecto.Changeset

  schema "purchases" do
    field :expires_at, :utc_datetime
    field :kind, :string
    field :price_cents, :integer
    field :renew_period_days, :integer
    belongs_to :project, Videosnack.Project
    belongs_to :episode, Videosnack.Episode
    belongs_to :user, Videosnack.User

    timestamps()
  end

  @doc false
  def changeset(purchase, attrs) do
    purchase
    |> cast(attrs, [:kind, :expires_at, :renew_period_days, :price_cents])
    |> validate_required([:kind, :price_cents])
    |> validate_inclusion(:kind, ~w(subscription unique))
  end
end
