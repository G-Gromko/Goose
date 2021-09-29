defmodule Goose.Timeline.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Goose.Timeline.{Author, Post}

  schema "comments" do
    field :body, :string
    belongs_to :author, Author
    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> validate_length(:body, min: 2, max: 280)
  end
end
