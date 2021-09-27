defmodule Goose.Repo do
  use Ecto.Repo,
    otp_app: :goose,
    adapter: Ecto.Adapters.Postgres
end
