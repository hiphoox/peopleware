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
    {id, _} = Integer.parse(id)
    conn
    |> assign(:profile, Peopleware.Repo.get(Profile, id))
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
    {id, _} = Integer.parse(id)
    conn
    |> assign_params(Peopleware.Repo.get(Profile, id))
    |> render("edit.html")
  end

  @doc """
  Invoked when the user selects the save button when in the new.html
  """
  def create(conn, %{"profile" => profile}) do
    changeset = Profile.changeset %Profile{}, profile

    if changeset.valid? do
      Peopleware.Repo.insert(changeset)
      redirect conn, to: profile_path(conn, :index)
    else
      p = %Peopleware.Profile{name: profile["name"],  
                       last_name: profile["last_name"],
                  second_surname: profile["second_surname"],
                     last_salary: profile["last_salary"],
                        position: profile["position"],
                          resume: profile["resume"],
                        keywords: profile["keywords"],
                           email: profile["email"],
                             cel: profile["cel"],
                             tel: profile["tel"],
                           state: profile["state"],
              contracting_schema: profile["contracting_schema"],
                           }
      conn
      |> assign(:profile, p)
      |> assign(:states, Profile.states)
      |> assign(:contractings, ["nómina", "mixto", "honorarios", "facturación", "asimilables a asalariados", "no estoy seguro"])
      |> assign(:errors, changeset.errors)
      |> render("new.html")
    end
  end

  @doc """
  Invoked when the user selects the save button when in the edit.html
  """
  def update(conn, %{"id" => id, "profile" => profile}) do

    {id, _} = Integer.parse(id)
    p = Peopleware.Repo.get(Peopleware.Profile, id)
    changeset = Profile.changeset p, profile

    if changeset.valid? do
      Peopleware.Repo.update(changeset)
      redirect conn, to: profile_path(conn, :show, p.id)
    else
      p = %Peopleware.Profile{name: profile["name"],  
                       last_name: profile["last_name"],
                  second_surname: profile["second_surname"],
                     last_salary: profile["last_salary"],
                        position: profile["position"],
                          resume: profile["resume"],
                        keywords: profile["keywords"],
                           email: profile["email"],
                             cel: profile["cel"],
                             tel: profile["tel"],
                           state: profile["state"],
              contracting_schema: profile["contracting_schema"],
                           }
      conn
      |> assign(:profile, p)
      |> assign(:states, Profile.states)
      |> assign(:errors, changeset.errors)
      |> assign(:contractings, ["nómina", "mixto", "honorarios", "facturación", "asimilables a asalariados", "no estoy seguro"])
      |> render("edit.html")
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

  defp assign_params(conn, profile) do
    conn
      |> assign(:profile, profile)
      |> assign(:states, Profile.states)
      |> assign(:errors, [])
      |> assign(:contractings, ["nómina", "mixto", "honorarios", "facturación", "asimilables a asalariados", "no estoy seguro"])    
  end
end