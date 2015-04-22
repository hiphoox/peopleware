defmodule Peopleware.LoginController do
  use Peopleware.Web, :controller
  alias Peopleware.User

  plug :scrub_params, "user" when action in [:create]
  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end

  def signin(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "signin.html", changeset: changeset
  end

  def signup(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "signup.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    password_conf = user_params["password_conf"]
    password = user_params["password"]

    if password_conf == nil || password != password_conf do
      changeset = Ecto.Changeset.add_error(changeset, :password, "no es igual")
      render conn, "signup.html", changeset: changeset
    else
      if changeset.valid?  do
        changeset = Ecto.Changeset.put_change(changeset, :reset_token, generate_token)
        user = Repo.insert(changeset)

        Peopleware.Mailer.send_welcome_email(user)
        conn
        |> put_flash(:info, "User created succesfully.")
        |> redirect(to: login_path(conn, :index))
      else
        render conn, "signup.html", changeset: changeset
      end
    end
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

  def forget(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "forget.html", changeset: changeset
  end

  def reset(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "forget.html", changeset: changeset
  end

  def confirm(conn, %{"token" => token}) do
    case User.get_by_token(token) do
      nil ->
        text conn, "La cuenta ya no es valida"
      user ->
        user = %{user | is_confirmed: true, is_active: true, reset_token: ""}
        Repo.update(user)
        text conn, "Cuenta activada"
    end
  end


################################
# Private API

  defp page_path_for_user(conn, user) do
    if user.is_staff do
      user_path(conn, :index)
    else
      profile_path(conn, :index)
    end
  end

  def get_userid(conn) do
    get_session(conn, :user_id)
  end

  defp generate_token do
    token = SecureRandom.urlsafe_base64(64)
    # {token, Comeonin.Bcrypt.hashpwsalt(token)}
  end
end
