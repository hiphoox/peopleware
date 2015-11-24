defmodule Peopleware.LoginController do
  use Peopleware.Web, :controller
  alias Peopleware.User

  plug :scrub_params, "user" when action in [:create, :update_password]

  @password_error_message "La contraseña y su confirmación no son iguales, considera que son sensibles a mayúsculas y minúsculas"

  @email_error_message "El correo ya se encuentra registrado, favor de registrarse con uno diferente"

  @doc """
  Check if the user is logged, if true send to profile, if false, send to
  sigin, the index template is not used
  """
  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    if user_id do
      redirect(conn, to: profile_path(conn, :index))
    else
      redirect(conn, to: login_path(conn, :signin))
    end
  end

  def signin(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "signin.html", changeset: changeset
  end

  def signup(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "signup.html", changeset: changeset
  end

  def thanks(conn, _params) do
    render conn, "thanks.html"
  end

  @doc """
  Create an user and generate a reset token for one use
  """
  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    if password_is_valid?(user_params) do
      if changeset.valid?  do
        changeset = Ecto.Changeset.put_change(
                      changeset,
                      :reset_token,
                      generate_token)

        {result, user} = Repo.insert(changeset)

        # If the insert to repo is an error, then send to the signup page
        # to use another email
        if result == :error do
          changeset = Ecto.Changeset.add_error(
                        changeset,
                        :email,
                        @email_error_message)
          render conn, "signup.html", changeset: changeset
        end

        # If the result is ok, then send an email to the user and sent to
        # thanks page
        Peopleware.Mailer.send_welcome_email(user)
        redirect(conn, to: login_path(conn, :thanks))

      else
        render conn, "signup.html", changeset: changeset
      end
    else
      changeset = Ecto.Changeset.add_error(
                    changeset,
                    :password,
                    @password_error_message)

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

  @doc """
  When the user is logout from the site, is redirected to recluit main page
  """
  def logout(conn, _params) do
    conn = put_session(conn, :user_id, nil)
    redirect(conn, external: "http://www.recluit.com")
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
        user = %{user | reset_token: generate_token}
        Repo.update(user)
        Peopleware.Mailer.send_password_reset_email(user)
        render conn, "reset.html"
    end
  end

  def confirm_reset(conn, %{"token" => token}) do
    case User.get_by_token(token) do
      nil ->
        text conn, "La cuenta ya no es valida"
      user ->
        changeset = User.changeset(user)
        render conn, "change_password.html", changeset: changeset
    end
  end

  def update_password(conn, %{"user" => user_params}) do
    case User.get_by_token(user_params["reset_token"]) do
      nil ->
        text conn, "La cuenta ya no es valida"
      user ->
        changeset = User.changeset(user, user_params)
        if password_is_valid?(user_params) do
          if changeset.valid? do
            changeset = Ecto.Changeset.change(changeset, %{reset_token: ""})
            Repo.update(changeset)
            changeset = User.changeset(%User{})
            render conn, "signin.html", changeset: changeset
          else
            render conn, "change_password.html", changeset: changeset
          end
        else
          changeset = Ecto.Changeset.add_error(changeset, :password, @password_error_message)
          render conn, "change_password.html", changeset: changeset
        end
    end
  end

  def confirm(conn, %{"token" => token}) do
    case User.get_by_token(token) do
      nil ->
        render conn, "not_valid.html"
      user ->
        user = %{user | confirmed: true, is_active: true, reset_token: ""}
        Repo.update(user)
        render conn, "confirm.html"
    end
  end

  # Static pages
  def aviso_privacidad(conn, _params) do
    render conn, "privacity.html"
  end


################################
# Private API

  defp password_is_valid?(user_params) do
    %{"password" => password, "password_conf" => password_conf} = user_params
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
  end

end
