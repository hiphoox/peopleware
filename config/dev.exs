use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :peopleware, Peopleware.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  cache_static_lookup: false,
  watchers: [{Path.expand("node_modules/brunch/bin/brunch"), ["watch"]}],
  code_reloader: true # Enables code reloading for development

# Watch static and templates for browser reloading.
# *Note*: Be careful with wildcards. Larger projects
# will use higher CPU in dev as the number of files
# grow. Adjust as necessary.
config :peopleware, Peopleware.Endpoint,
  code_reloader: true,
  live_reload: [
    # url is optional
    # url: "ws://localhost:4000",
    # `:patterns` replace `:paths` and are required for live reload
    patterns: [~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
               ~r{web/views/.*(ex)$},
               ~r{web/templates/.*(eex)$}]]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :peopleware, Peopleware.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "hiphoox",
  password: "",
  database: "peopleware"
