defmodule Videosnack.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :slug, :string, null: false
      add :name, :string, null: false
      add :domain, :string
      add :plan_id, references(:plans), null: false

      timestamps()
    end
  end
end
