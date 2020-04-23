# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bank_api, BankApi.Accounts.Auth.Guardian,
  issuer: "bank_api",
  secret_key: System.get_env("GUARDIAN_SECRET")

config :bank_api,
  ecto_repos: [BankApi.Repo]

# Configures the endpoint
config :bank_api, BankApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WlnU796s6TyRVVx5WGpE8ql4yc9wsu2cAVGptlXh5HZS0oxG6jV12HjLhdHmQmyu",
  render_errors: [view: BankApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BankApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
