defmodule Goose.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Goose.Timeline.Author

  schema "posts" do
    field :body, :string
    field :views, :integer
    belongs_to :author, Author

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> validate_length(:body, min: 2, max: 280)
  end
end
