defmodule Goose.Repo.Migrations.AddAuthorIdToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :author_id, references(:authors, on_delete: :delete_all), null: false
    end

    create index(:comments, [:author_id])
  end
end
