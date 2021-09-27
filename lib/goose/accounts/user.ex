defmodule Goose.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Goose.Accounts.Credential

  schema "users" do
    field :bio, :string
    field :name, :string
    field :username, :string
    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :bio])
    |> validate_required([:name, :username, :bio])
    |> unique_constraint(:username)
    |> validate_length(:name, min: 2, max: 25)
    |> validate_length(:username, min: 2, max: 25)
    |> validate_length(:bio, min: 2, max: 150)
  end
end
