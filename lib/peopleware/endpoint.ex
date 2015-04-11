defmodule Peopleware.Endpoint do
  use Phoenix.Endpoint, otp_app: :peopleware

  # Serve at "/" the given assets from "priv/static" directory
  plug Plug.Static,
    at: "/", from: :peopleware,
    only: ~w(css images js favicon.ico robots.txt)

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  if code_reloading? do
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_peopleware_key",
    signing_salt: "I/uU/6Yf",
    encryption_salt: "jvh4RkmU"

  plug :router, Peopleware.Router
end
