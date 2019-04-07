# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :videosnack,
  ecto_repos: [Videosnack.Repo]

# Configures the endpoint
config :videosnack, VideosnackWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QsJ0oNrtIZFIeUpLIGyWebbTtddLhaI7HNw8dELVyGwFOI4tXukLl52zUozjRgJB",
  render_errors: [view: VideosnackWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Videosnack.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user"]}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
