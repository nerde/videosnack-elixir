defmodule Videosnack.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :role, :string, null: false
      add :account_id, references(:accounts, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:members, [:user_id, :account_id])
  end
end
