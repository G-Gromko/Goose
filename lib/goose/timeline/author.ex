defmodule Goose.Timeline.Author do
  use Ecto.Schema
  import Ecto.Changeset

  alias Goose.Timeline.Post

  schema "authors" do
    has_many :posts, Post
    belongs_to :user, Goose.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint(:user_id)
  end
end
