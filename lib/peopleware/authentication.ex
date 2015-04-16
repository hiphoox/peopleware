defmodule Peopleware.Authentication  do
  import Plug.Conn
  alias Peopleware.User

  def authenticated?(conn) do
    user_id = get_session(conn, :user_id)
    if user_id, do: true, else: false
  end

  def validate_credentials(email, password) do
    if user = User.get_by_email(email) do
      user.password == password && user || nil
    else
      nil
    end
  end

end
