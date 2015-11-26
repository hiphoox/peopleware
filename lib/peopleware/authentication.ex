defmodule Peopleware.Authentication  do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2]
  alias Peopleware.User

  def authenticated?(conn) do
    user_id = get_session(conn, :user_id)
    if user_id, do: true, else: false
  end

  def validate_credentials(email, password) do
    if user = User.get_by_email(email) do
      (checkpw(password, user.password) && user.is_active && user.confirmed) && user || nil
    else
      nil
    end
  end

end
