defmodule Videosnack.Repo.Migrations.CreatePurchases do
  use Ecto.Migration

  def change do
    create table(:purchases) do
      add :kind, :string, null: false
      add :expires_at, :utc_datetime
      add :renew_period_days, :integer
      add :price_cents, :integer, null: false
      add :project_id, references(:projects, on_delete: :nothing)
      add :episode_id, references(:episodes, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:purchases, [:project_id])
    create index(:purchases, [:episode_id])
    create index(:purchases, [:user_id])
  end
end
