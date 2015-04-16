defmodule Peopleware.Router do
  use Phoenix.Router

  # Use the default browser stack
  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :auth do
  #   plug Peopleware.Plug.Authentication
    plug :authenticate
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", Peopleware do
    pipe_through :browser

    get "/", LoginController, :index
    get "/signin", LoginController, :signin
    post "/login", LoginController, :login
    get "/logout", LoginController, :logout
    get "/signup", LoginController, :signup
    post "/create", LoginController, :create
  end

  scope "/admin", Peopleware do
    pipe_through :browser
    pipe_through :auth

    resources "/profiles", ProfileController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Peopleware do
  #   pipe_through :api
  # end

  ####################
  # Private functions
  ####################

  defp authenticate(conn, _params) do
    if Peopleware.Authentication.authenticated?(conn) do
      conn
    else
      conn
      |> redirect(to: "/signin")
      |> halt
    end
  end
end
