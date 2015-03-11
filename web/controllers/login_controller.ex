defmodule Peopleware.LoginController do
  use Peopleware.Web, :controller
  alias Peopleware.User

  plug :action

  def index(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "index.html", changeset: changeset, action: "/login"
  end
  
  def login(conn, params) do

    user = User.get_by_email(params["email"])
    if isValid(user, params["password"]) do
      page_path = page_path_for_user(conn, user)
      redirect(conn, to: page_path)      
    else
      changeset = User.changeset(%User{})
      changeset = Ecto.Changeset.add_error(changeset, :login, :failed)
      render conn, "index.html", changeset: changeset, action: "/login"
    end
  end

  def isValid(user, password) do
    case user do
      nil ->
        false
      user ->
        user.password == password
    end
  end

  def page_path_for_user(conn, user) do
    if user.is_staff do
      profile_path(conn, :index)
    else
      user_path(conn, :index)
    end
  end
  
    
end
