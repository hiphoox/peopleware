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
  mailgun_domain: "sandbox859abcbc300b41bcbec5af10244cb0fe.mailgun.org",
  mailgun_key: "key-f15925d915ebe1ce03b081e6fffe1c10",
  confirm_url: "http://localhost:4000/confirm/",
  # mode: :test,
  test_file_path: "/tmp/mailgun.json",
  email_sender: "norberto.ortigoza@gmail.com",
  welcome_email_subject: "Hola ",
  welcome_email_body: "/Users/hiphoox/Development/Elixir/recluIT/peopleware/priv/static/welcome_email_body.eex"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
