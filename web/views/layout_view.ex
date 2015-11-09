defmodule Peopleware.LayoutView do
  use Peopleware.Web, :view

  def get_path(conn) do
    %{request_path: path} = conn
    path
  end

end


