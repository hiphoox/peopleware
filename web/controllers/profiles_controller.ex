defmodule Peopleware.ProfileController do
  use Phoenix.Controller
  require IEx
   
  import Peopleware.Router.Helpers
  alias Peopleware.Profile

  plug :action
  
  @doc """
  It just returns the list of all curriculums
  """
  def index(conn, _params) do
    # IEx.pry
    conn
    |> assign(:profiles, Peopleware.Repo.all(Profile))
    |> render("index.html")
  end

  @doc """
  It shows the seleted curriculum
  """
  def show(conn, %{"id" => id}) do
    profile = profile_from_id(id)
    conn
      |> assign(:profile, profile)
      |> render("show.html")
  end
  
  @doc """
  Setups everything we need to create a new profile 
  """
  def new(conn, _params) do
      conn
      |> assign_params(%Profile{})
      |> render "new.html"
  end

  @doc """
  It just returns the list of curriculums
  """
  def edit(conn, %{"id" => id}) do
    profile = profile_from_id(id)
    conn
      |> assign_params(profile)
      |> render("edit.html")
  end

  @doc """
  Invoked when the user selects the save button when in the new.html
  """
  def create(conn, %{"profile" => new_profile_values}) do
    changeset = Profile.changeset %Profile{}, new_profile_values

    if changeset.valid? do
      Peopleware.Repo.insert(changeset)
      redirect conn, to: profile_path(conn, :index)
    else
      return_same_page conn, new_profile_values, "new.html"
    end
  end

  @doc """
  Invoked when the user selects the save button when in the edit.html
  """
  def update(conn, %{"id" => id, "profile" => new_profile_values}) do
    changeset = Profile.changeset profile_from_id(id), new_profile_values

    if changeset.valid? do
      Peopleware.Repo.update(changeset)
      redirect conn, to: profile_path(conn, :index)
    else
      return_same_page conn, new_profile_values, "edit.html"
    end
  end

  @doc """
  Invoked when the user selects the delete button when in the index.html
  """
  def delete(conn, %{"id" => id}) do
    {id, _} = Integer.parse(id)
    q = Peopleware.Repo.get(Peopleware.Profile, id)
    Peopleware.Repo.delete(q)
    redirect conn, to: profile_path(conn, :index)
  end


  ####################
  # Private functions
  ####################

  defp assign_params(conn, profile) do
    conn
      |> assign(:profile, profile)
      |> assign(:states, Profile.states)
      |> assign(:errors, [])
      |> assign(:contractings, Profile.contractings)    
  end

  defp profile_from_values(profile_values) do
    %Profile{
                  name: profile_values["name"],  
             last_name: profile_values["last_name"],
        second_surname: profile_values["second_surname"],
           last_salary: profile_values["last_salary"],
              position: profile_values["position"],
                resume: profile_values["resume"],
              keywords: profile_values["keywords"],
                 email: profile_values["email"],
                   cel: profile_values["cel"],
                   tel: profile_values["tel"],
                 state: profile_values["state"],
    contracting_schema: profile_values["contracting_schema"],
    }
  end

  defp profile_from_id(id) do
    {id, _} = Integer.parse(id)
    Peopleware.Repo.get(Peopleware.Profile, id)
  end

  defp return_same_page(conn, new_profile_values, page) do
    new_profile = profile_from_values(new_profile_values)
    conn
    |> assign_params(new_profile)
    |> render(page)
  end

end