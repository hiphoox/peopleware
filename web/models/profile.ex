defmodule Peopleware.Profile  do
  use Ecto.Model

  schema "profiles" do
    field :name,               :string
    field :last_name,          :string
    field :second_surname,     :string
    field :last_salary,        :string
    field :position,           :string
    field :resume,             :string
    field :keywords,           :string
    field :email,              :string
    field :cel,                :string
    field :tel,                :string
    field :state,              :string   # Lista de estados
    field :contracting_schema, :string   #nómina, mixto, honorarios, facturación, asimilables a salarios, no estoy seguro
    timestamps
  end


  def changeset(profile, params \\ nil) do
    params
    |> cast(profile, ~w(name last_name second_surname last_salary position email contracting_schema), ~w(tel cel state resume keywords))
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> validate_unique(:email, on: Peopleware.Repo)
    |> validate_format(:tel, ~r/^(?:[0-9]\x20?){7,9}[0-9]$/)
    |> validate_format(:cel, ~r/^(?:[0-9]\x20?){7,9}[0-9]$/)
  end

  def states do
    ["Aguascalientes",
    "Baja California",
    "Campeche",
    "Coahuila",
    "Colima",
    "Chiapas",
    "Chihuahua",
    "Distrito Federal",
    "Durango",
    "Guanajuato",
    "Guerrero",
    "Hidalgo",
    "Jalisco",
    "México",
    "Michoacán",
    "Morelos",
    "Nayarit",
    "Nuevo León",
    "Oaxaca",
    "Puebla",
    "Querétaro",
    "Quintana Roo",
    "San Luis Potosí",
    "Sinaloa",
    "Sonora",
    "Tabasco",
    "Tamaulipas",
    "Tlaxcala",
    "Veracruz",
    "Yucatán",
    "Zacatecas"]
  end

  def contractings do
     ["nómina", "mixto", "honorarios", "facturación", "asimilables a asalariados", "no estoy seguro"] 
  end
  
end