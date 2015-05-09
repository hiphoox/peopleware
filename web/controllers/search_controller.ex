defmodule Peopleware.SearchController do
  use Peopleware.Web, :controller
  # require IEx
  alias Peopleware.Profile
  alias Peopleware.User

  plug :scrub_params, "profile" when action in [:create, :update]
  plug :action

  @doc """
  It just returns the list of all curriculums
  """
  def index(conn, _params) do
    changeset = Profile.changeset(%Profile{})
    render conn, "search.html", changeset: changeset
  end

  def search(conn, %{"profile" => profile_params}) do
     profiles = Profile.get_by_criteria(profile_params)
     render conn, "results.html", profiles: profiles
  end

end