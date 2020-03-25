defmodule Videosnack.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :original_name, :string, null: false
      add :content_type, :string, null: false
      add :url, :string, null: false
      add :size_bytes, :bigint, null: false
      add :uploaded, :boolean, default: false, null: false
      add :account_id, references(:accounts, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:uploads, [:account_id])
  end
end
