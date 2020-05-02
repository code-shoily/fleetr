defmodule Fleetr.Repo do
  use Ecto.Repo,
    otp_app: :fleetr,
    adapter: Ecto.Adapters.Postgres

  Postgrex.Types.define(Fleetr.PostgresTypes,
    [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
    json: Poison)
end
