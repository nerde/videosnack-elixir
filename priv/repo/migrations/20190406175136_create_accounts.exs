defmodule Videosnack.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :slug, :string, null: false
      add :name, :string, null: false
      add :domain, :string
      add :plan_id, references(:plans, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:accounts, [:plan_id])
    create unique_index(:accounts, [:slug])
    create unique_index(:accounts, [:name])
    create unique_index(:accounts, [:domain])
  end
end
