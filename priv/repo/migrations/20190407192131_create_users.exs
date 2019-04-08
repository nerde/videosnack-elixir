defmodule Videosnack.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string, null: false
      add :provider, :string
      add :token, :string
      add :root, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
