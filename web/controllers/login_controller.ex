defmodule Peopleware.LoginController do
  use Peopleware.Web, :controller
  alias Peopleware.User

  plug :action

  def index(conn, _params) do
    user_id = get_userid(conn)
    render conn, "index.html"
  end

  def signin(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "signin.html", changeset: changeset
  end

  def login(conn, %{"user" => user_params}) do
    alias Peopleware.Authentication, as: Auth
    email = user_params["email"]
    password = user_params["password"]

    if user = Auth.validate_credentials(email, password) do
      page_path = page_path_for_user(conn, user)
      conn = put_session(conn, :user_id, user.id)
      redirect(conn, to: page_path)
    else
      changeset = User.changeset(%User{}, user_params)
      render conn, "signin.html", changeset: changeset
    end
  end

  def logout(conn, _params) do
    conn = put_session(conn, :user_id, nil)
    redirect(conn, to: login_path(conn, :index))
  end

  def page_path_for_user(conn, user) do
    if user.is_staff do
      user_path(conn, :index)
    else
      profile_path(conn, :index)
    end
  end

  def get_userid(conn) do
    get_session(conn, :user_id)
  end

end
