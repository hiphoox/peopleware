use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :peopleware, Peopleware.Endpoint,
  secret_key_base: "vz1ZmGLvNkurxEjFugID71Ejs0DPFyRfV3azXsPBSoDUsgbqF+/MTEgQCjwP1/yG"

# Configure your database
config :peopleware, Peopleware.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "hiphoox",
  password: "norber0",
  database: "peopleware"