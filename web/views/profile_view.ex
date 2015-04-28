defmodule Peopleware.ProfileView do
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

  def translate_error({:cel, message}) do
    "* El celular " <> translate(message)
  end

  def translate_error({:tel, message}) do
    "* El teléfono " <> translate(message)
  end

  def translate_error({:position, message}) do
    "* El puesto " <> translate(message)
  end

  def translate_error({:last_salary, message}) do
    "* El salario " <> translate(message)
  end

  def translate_error({:resume, message}) do
    "* El resumen " <> translate(message)
  end

  def translate_error({:keywords, message}) do
    "* Las palabras claves " <> translate_plural(message)
  end

  def translate_error({:cv_file, message}) do
    "* El Archivo " <> translate_plural(message)
  end

  def translate_error(message) do
    "* Error desconocido: " <> (IO.inspect message)
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