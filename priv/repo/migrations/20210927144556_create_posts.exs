defmodule Goose.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :string
      add :views, :integer, default: 0

      timestamps()
    end

  end
end
