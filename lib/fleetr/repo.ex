defmodule Fleetr.Repo do
  use Ecto.Repo,
    otp_app: :fleetr,
    adapter: Ecto.Adapters.Postgres
end
