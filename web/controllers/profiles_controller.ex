defmodule Peopleware.ProfileController do
  use Phoenix.Controller
  require IEx
   
  # alias Peopleware.Router
  import Peopleware.Router.Helpers
  alias Peopleware.Profile

  plug :action

  def homepage(conn, _params) do
    conn
    |> assign(:profile, Peopleware.Profile.Queries.random)
    |> render("show.html")
  end
  
  def index(conn, _params) do
    # IEx.pry
    conn
    |> assign(:profiles, Peopleware.Repo.all(Peopleware.Profile))
    |> render("index.html")
  end
  
  def new(conn, _params) do
      conn
      |> assign(:profile, %Profile{})
      |> assign(:medios, ["cel", "mail", "tel"])
      |> render "new.html"
  end

  def create(conn, %{"profile" => profile}) do
    changeset = Profile.changeset %Profile{}, profile

    if changeset.valid? do
      user = Peopleware.Repo.insert(changeset)
      redirect conn, to: profile_path(conn, :index)
    else
      p = %Peopleware.Profile{name: profile["name"],  
                       last_name: profile["last_name"],
                  second_surname: profile["second_surname"],
                     last_salary: profile["last_salary"],
                        position: profile["position"],
                          resume: profile["resume"],
                        keywords: profile["keywords"],
                     type_medium: profile["type_medium"],
                     info_medium: profile["infor_medium"],
                           state: profile["state"],
              contracting_schema: profile["contracting_schema"],
                           }
      conn
      |> assign(:profile, p)
      |> assign(:medios, ["cel", "mail", "tel"])
      |> render("new.html")
    end

    # Peopleware.Repo.insert(q)

  end

  def show(conn, %{"id" => id}) do
    {id, _} = Integer.parse(id)
    conn
    |> assign(:profile, Peopleware.Repo.get(Peopleware.Profile, id))
    |> render("show.html")
  end

  def edit(conn, %{"id" => id}) do
    {id, _} = Integer.parse(id)
    conn
    |> assign(:profile, Peopleware.Repo.get(Peopleware.Profile, id))
    |> assign(:medios, ["cel", "mail", "tel"])
    |> render("edit.html")
  end

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
                     type_medium: profile["type_medium"],
                     info_medium: profile["infor_medium"],
                           state: profile["state"],
              contracting_schema: profile["contracting_schema"],
                           }
      conn
      |> assign(:profile, p)
      |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    {id, _} = Integer.parse(id)
    q = Peopleware.Repo.get(Peopleware.Profile, id)
    Peopleware.Repo.delete(q)
    redirect conn, to: profile_path(conn, :index)
  end

end