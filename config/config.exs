# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :peopleware, Peopleware.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "g/z3ICJVkXVPdNyUf0wFe52NMF49WHJrNG4VyrBdmasFgd/5JYIyV1Pcq9uoxhwO",
  debug_errors: false,
  root: Path.expand("..", __DIR__),
  pubsub: [name: Peopleware.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :peopleware,
  mailgun_domain: "https://api.mailgun.net/v3/giovannicortes.com",
  mailgun_key: "key-301ca355e1329d5741ff908f27e6c96f",
  confirm_url: "http://localhost:4000/confirm/",
  reset_pass_url: "http://localhost:4000/confirm_reset/",
  # mode: :test,
  test_file_path: "/tmp/mailgun.json",
  email_sender: "postmaster@giovannicortes.com",
  welcome_email_subject: "Hola ",
  welcome_email_body: "/Users/Giovanni/Programming/Work/peopleware/priv/static/welcome_email_body.html.eex",
  change_pass_email_body: "/Users/hiphoox/Programming/Work/peopleware/priv/static/change_pass_email_body.html.eex"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
