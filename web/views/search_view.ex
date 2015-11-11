defmodule Peopleware.SearchView do
  use Peopleware.Web, :view
  import Scrivener.HTML

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

  @doc """
  Convert the number into readable human format, example:
  123456 => 123,456
  """
  def convert_number_to_human(num) do
    num
    |> Integer.to_char_list
    |> Enum.reverse
    |> Enum.chunk(3, 3, [])
    |> Enum.join(",")
    |> String.reverse
  end

  @doc """
  Check if the checkbox field is checked or not
  """
  def is_checked?(%{"english_level" => english_level}, value, key) do
    # Check if is a map, because when the form sends a empty value
    # is just a string with ""
    if is_map(english_level) do
      # Extract the value from the key
      val = Map.get(english_level, key)

      if val == value do
        true
      else
        false
      end
    end
  end

end
