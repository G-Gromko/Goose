defmodule Goose.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string
      add :bio, :string

      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
