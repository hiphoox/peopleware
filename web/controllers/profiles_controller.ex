defmodule Peopleware.ProfileController do
  use Peopleware.Web, :controller
  # require IEx
  alias Peopleware.Profile
  alias Peopleware.User

  plug :authenticate, :admin when action in [:create, :update]
  plug :scrub_params, "profile" when action in [:create, :update]
  plug :action

  @doc """
  It just returns the list of all curriculums
  """
  def index(conn, _params) do
    # IEx.pry
    profiles = Repo.all(Profile)
    # put_resp_header("Authorization: Token", "token=12345")
    render conn, "index.html", profiles: profiles
  end

  @doc """
  Setups everything we need to create a new profile
  """
  def new(conn, _params) do
    user = Repo.get(User, 1)
    profile = %Profile{name: user.name,
                       last_name: user.last_name,
                       second_surname: user.second_surname,
                       user: user}
    changeset = Profile.changeset(profile)
    render conn, "new.html", changeset: changeset
  end

  @doc """
  Invoked when the user selects the save button when in the new.html
  """
  def create(conn, %{"profile" => profile_params}) do
    changeset = Profile.changeset(%Profile{user_id: 1}, profile_params)
    if changeset.valid? do
      Repo.insert(changeset)
      # |> put_flash(:info, "CV creado exitosamente.")
      redirect(conn, to: profile_path(conn, :index))
    else
      IO.inspect changeset.errors
      render conn, "new.html", changeset: changeset
    end
  end

  @doc """
  It shows the seleted curriculum
  """
  def show(conn, %{"id" => id}) do
    profile = Repo.get(Profile, id)
    render conn, "show.html", profile: profile
  end

  @doc """
  It just returns the list of curriculums
  """
  def edit(conn, %{"id" => id}) do
    profile = Repo.get(Profile, id)
    changeset = Profile.changeset(profile)
    render conn, "edit.html", profile: profile, changeset: changeset
  end

  @doc """
  Invoked when the user selects the save button inside the edit.html
  """
  def update(conn, %{"id" => id, "profile" => profile_params}) do
    profile = Repo.get(Profile, id)
    changeset = Profile.changeset(profile, profile_params)

    if changeset.valid? do
      Repo.update(changeset)
      redirect(conn, to: profile_path(conn, :index))
    else
      render conn, "edit.html", profile: profile, changeset: changeset
    end
  end

  @doc """
  Invoked when the user selects the delete button inside the index.html
  """
  def delete(conn, %{"id" => id}) do
    profile = Repo.get(Profile, id)
    Repo.delete(profile)
    conn
    |> put_flash(:info, "CV borrado exitosamente.")
    |> redirect(to: profile_path(conn, :index))
  end


  ####################
  # Private functions
  ####################

  defp authenticate(conn, :admin) do
    if Peopleware.Authentication.authenticated?(conn) do
      conn
    else
      conn
      |> redirect(to: profile_path(conn, :index))
      |> halt
    end
  end

end