# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :evolution,
  ecto_repos: [Evolution.Repo]

# Configures the endpoint
config :evolution, EvolutionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ejs2OMVkc1LALAbYvaIAKaqJcyIFFtWWCqXK1UJm2lVciWOByd3OvyZiaCyS5KnF",
  render_errors: [view: EvolutionWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Evolution.PubSub,
  live_view: [signing_salt: "xqS6dLF8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
