defmodule Peopleware.ProfileController do
  use Peopleware.Web, :controller
  # require IEx
  alias Peopleware.Profile

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
    changeset = Profile.changeset(%Profile{})
    conn
    |> assign_params(changeset, [])
    |> render "new.html"
  end

  @doc """
  Invoked when the user selects the save button when in the new.html
  """
  def create(conn, %{"profile" => profile_params}) do
    changeset = Profile.changeset(%Profile{}, profile_params)

    if changeset.valid? do
      Repo.insert(changeset)
      # |> put_flash(:info, "CV creado exitosamente.")
      redirect(conn, to: profile_path(conn, :index))
    else
      error_messages = get_error_messages(changeset.errors)
      return_same_page conn, profile_params, error_messages, "new.html"
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
    conn
      |> assign_params(changeset, [])
      |> render "edit.html", profile: profile
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
      error_messages = get_error_messages(changeset.errors)
      return_same_page conn, profile_params, error_messages, "edit.html", id
    end
  end

  @doc """
  Invoked when the user selects the delete button inside the index.html
  """
  def delete(conn, %{"id" => id}) do
    profile = Repo.get(Peopleware.Profile, id)
    Repo.delete(profile)
    conn
    # |> put_flash(:info, "CV borrado exitosamente.")
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

  defp assign_params(conn, changeset, errors) do
    conn
    |> assign(:changeset, changeset)
    |> assign(:states, Profile.states)
    |> assign(:errors, errors)
    |> assign(:contractings, Profile.contractings)
  end

  defp return_same_page(conn, new_profile_values, errors, page, id \\ 0) do
    new_profile = Profile.profile_from_values(new_profile_values, id)
    conn
    |> assign_params(new_profile, errors)
    |> render(page)
  end

  defp get_error_messages(errors) do
    Enum.map(errors, fn {k, v} -> {k, Profile.get_message(v)} end)
  end

end