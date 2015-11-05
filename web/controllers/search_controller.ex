defmodule Peopleware.SearchController do
  use Peopleware.Web, :controller
  # require IEx
  alias Peopleware.Profile

  @page 1
  @count 5

  plug :scrub_params, "profile" when action in [:create, :update]

  @doc """
  It just returns the list of all curriculums
  """
  def index(conn, _params) do
    changeset = Profile.changeset(%Profile{})
    render conn, "search.html", changeset: changeset
  end

  def search(conn, %{"profile" => profile_params}) do
    changeset = Profile.changeset(%Profile{})

    profiles = Profile.search(@page, @count, profile_params)
    render conn, "results.html", profiles: profiles.entries, changeset: changeset
  end

end
