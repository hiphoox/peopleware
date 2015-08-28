defmodule Peopleware.Search do
  #use Ecto.Model

 # defp search(query, search, order?) do
  #  name_search = like_escape(search, ~r"(%|_)")
   # if String.length(search) >= 3 do
    #  name_search = "%" <> name_search <> "%"
   # end

    #desc_search = String.replace(search, ~r"\s+", " & ")

    #query =
     # from var in query,
    #where: ilike(var.name, ^name_search) or
     #      fragment("to_tsvector('english', (?->'description')::text) @@ to_tsquery('english', ?)",#
  #                  var.meta, ^desc_search)
   # if order? do
    #  query = from(var in query, order_by: ilike(var.name, ^name_search))
    #end

    #query
  #end
end
