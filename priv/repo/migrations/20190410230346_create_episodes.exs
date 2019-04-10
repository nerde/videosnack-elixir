defmodule Videosnack.Repo.Migrations.CreateEpisodes do
  use Ecto.Migration

  def change do
    create table(:episodes) do
      add :name, :string, null: false
      add :description, :text
      add :content, :text
      add :license, :string, null: false
      add :duration_seconds, :integer
      add :distribution, :string, null: false
      add :published_at, :utc_datetime
      add :first_published_at, :utc_datetime
      add :first_purchased_at, :utc_datetime
      add :price_cents, :integer
      add :account_id, references(:accounts, on_delete: :nothing), null: false
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps()
    end

    create index(:episodes, [:account_id])
    create index(:episodes, [:project_id])
  end
end
