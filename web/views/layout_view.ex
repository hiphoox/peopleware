defmodule Peopleware.LayoutView do
  use Peopleware.Web, :view

  @doc """
  Get a path from the @conn struct
  """
  def get_path(conn) do
    %{request_path: path} = conn
    path
  end

end


