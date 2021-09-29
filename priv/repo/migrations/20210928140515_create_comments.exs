defmodule Goose.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text

      timestamps()
    end

  end
end
