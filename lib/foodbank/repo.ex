defmodule Foodbank.Repo do
  use Ecto.Repo,
    otp_app: :foodbank,
    adapter: Ecto.Adapters.Postgres
end
