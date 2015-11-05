defmodule Peopleware.SearchController do
  use Peopleware.Web, :controller
  # require IEx
  alias Peopleware.Profile
  alias Peopleware.User

  @page 1
  @count 10

  plug :scrub_params, "profile" when action in [:create, :update]

  @doc """
  It just returns the list of all curriculums
  """
  def index(conn, _params) do

    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)

    if user.is_staff do
      changeset = Profile.changeset(%Profile{})
      render conn, "search.html", changeset: changeset
    else
      redirect(conn, to: profile_path(conn, :index))
    end

  end

  def search(conn, %{"profile" => profile_params}) do

    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)

    if user.is_staff do
      changeset = Profile.changeset(%Profile{})

      profiles = Profile.search(@page, @count, profile_params)
      render conn, "results.html", profiles: profiles.entries, changeset: changeset, page: profiles, profile_params: profile_params
    else
      redirect(conn, to: profile_path(conn, :index))
    end

  end

end
