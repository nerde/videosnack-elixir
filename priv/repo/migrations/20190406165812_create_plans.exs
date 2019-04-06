defmodule Videosnack.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :slug, :string, null: false
      add :name, :string, null: false
      add :storage_megabytes, :integer
      add :transfer_megabytes, :integer
      add :allows_domain, :boolean, default: false, null: false
      add :max_members, :integer
      add :fee_percent, :float, null: false
      add :price_cents, :integer, null: false

      timestamps()
    end
  end
end
