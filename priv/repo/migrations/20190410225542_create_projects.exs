defmodule Videosnack.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :published_at, :utc_datetime
      add :first_published_at, :utc_datetime
      add :first_purchased_at, :utc_datetime
      add :description, :text
      add :distribution, :string
      add :price_cents, :integer
      add :account_id, references(:accounts, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:projects, [:account_id, :slug])
  end
end
