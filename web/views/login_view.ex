defmodule Peopleware.LoginView do
  use Peopleware.Web, :view

  def translate_error({:name, message}) do
    "* El nombre " <> translate(message)
  end

  def translate_error({:last_name, message}) do
    "* El apellido paterno " <> translate(message)
  end

  def translate_error({:email, message}) do
    "* El correo " <> translate(message)
  end

  def translate(message) do
    case message do
      {m,_d} -> m
      "can't be blank" -> "no puede estar vacio"
          m -> m
    end
  end

  def translate_plural(message) do
    case message do
      {m,_d} -> m
      "can't be blank" -> "no pueden estar vacias"
          m -> m
    end
  end
end
