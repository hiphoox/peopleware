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

    if password_is_valid?(user_params) do
      if changeset.valid?  do
        changeset = Ecto.Changeset.put_change(changeset, :reset_token, generate_token)
        user = Repo.insert(changeset)

        Peopleware.Mailer.send_welcome_email(user)
        redirect(conn, to: login_path(conn, :index))
      else
        render conn, "signup.html", changeset: changeset
      end
    else
      changeset = Ecto.Changeset.add_error(changeset, :password, "no es igual")
      render conn, "signup.html", changeset: changeset
    end
  end

  def login(conn, %{"user" => user_params}) do
    alias Peopleware.Authentication, as: Auth
    %{"email" => email, "password" => password} = user_params

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

  def reset(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case User.get_by_email(user_params["email"]) do
      nil ->
        changeset = Ecto.Changeset.add_error(changeset, :email, "Correo invalido")
        render conn, "forget.html", changeset: changeset
      user ->
        user = %{user | password: generate_password}
        Repo.update(user)
        Peopleware.Mailer.send_password_reset_email(user)
        html conn, "Contraseña reiniciada, pronto le llegará un correo con su nueva clave, con ella podra entrar a: <a href=\"/admin/profiles\">capturar su cv</a>"
    end
  end

  def confirm(conn, %{"token" => token}) do
    case User.get_by_token(token) do
      nil ->
        text conn, "La cuenta ya no es valida"
      user ->
        user = %{user | confirmed: true, is_active: true, reset_token: ""}
        Repo.update(user)
        html conn, "Cuenta activada: <a href=\"/signin\">empieza a capturar tu cv</a>"
    end
  end


################################
# Private API

  defp password_is_valid?(user_params) do
    %{"password" => password, "password_conf" => password_conf} = user_params
    IO.inspect password_conf
    IO.inspect password
    password_conf != nil && password == password_conf
  end

  defp page_path_for_user(conn, user) do
    alias Peopleware.Profile

    if user.is_staff do
      user_path(conn, :index)
    else
      case Profile.get_users_by_type(user) do
        [] ->
          profile_path(conn, :new)
        [profile] ->
          profile_path(conn, :edit, profile)
      end
    end
  end

  def get_userid(conn) do
    get_session(conn, :user_id)
  end

  defp generate_token do
    _token = SecureRandom.urlsafe_base64(64)
    # {token, Comeonin.Bcrypt.hashpwsalt(token)}
  end

  defp generate_password do
    _token = SecureRandom.urlsafe_base64(8)
    # {token, Comeonin.Bcrypt.hashpwsalt(token)}
  end
end
