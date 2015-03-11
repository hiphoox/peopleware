defmodule Peopleware.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
  end

  # pipeline :auth do
  #   plug Peopleware.Plug.Authentication
  # end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", Peopleware do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/profiles", ProfileController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Peopleware do
  #   pipe_through :api
  # end
end
