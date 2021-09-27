defmodule Goose.Repo.Migrations.AddAuthorIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :author_id, references(:authors, on_delete: :delete_all), null: false
    end

    create index(:posts, [:author_id])
  end
end
