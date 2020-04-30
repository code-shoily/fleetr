# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fleetr, Fleetr.Cache,
  gc_interval: 86_400 # 24 hrs


config :fleetr,
  ecto_repos: [Fleetr.Repo]

# Configures the endpoint
config :fleetr, FleetrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tenV1DFYJ3Q4ipUaTDVURXpFdZVhwZ5nzZwri8mtVO8t2CXcO02axjIqf1asO7lq",
  render_errors: [view: FleetrWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Fleetr.PubSub,
  live_view: [signing_salt: "usHL3HKc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :paper_trail,
  strict: true,
  repo: Fleetr.Repo,
  item_type: Ecto.UUID,
  originator_type: Ecto.UUID

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
