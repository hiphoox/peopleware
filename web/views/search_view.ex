defmodule Peopleware.SearchView do
  use Peopleware.Web, :view

  def translate_error({:keywords, message}) do
    "* Las palabras de búsqueda " <> translate_plural(message)
  end

  def translate_error(message) do
    "* Error desconocido: " <> (IO.inspect message)
  end

  def translate_plural(message) do
    case message do
      {m,_d} -> m
      "can't be blank" -> "no pueden estar vacias"
          m -> m
    end
  end

end