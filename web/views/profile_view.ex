defmodule Peopleware.ProfileView do
  use Peopleware.Web, :view

  def translate(message) do
    case message do
      {m,_d} -> m
      "can't be blank" -> "no puede estar vacio"
          m -> m
    end
  end

end