defmodule Videosnack.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plans" do
    has_many :accounts, Videosnack.Account
    field :allows_domain, :boolean, default: false
    field :fee_percent, :float
    field :max_members, :integer
    field :name, :string
    field :price_cents, :integer
    field :slug, :string
    field :storage_megabytes, :integer
    field :transfer_megabytes, :integer

    timestamps()
  end

  def describe(plan) do
    cents = plan.price_cents
    "#{plan.name} (#{if cents == 0, do: 'Free!', else: Number.Currency.number_to_currency(cents / 100) <> "/mo"})"
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [
      :slug,
      :name,
      :storage_megabytes,
      :transfer_megabytes,
      :allows_domain,
      :max_members,
      :fee_percent,
      :price_cents
    ])
    |> validate_required([:slug, :name, :allows_domain, :fee_percent, :price_cents])
  end
end
