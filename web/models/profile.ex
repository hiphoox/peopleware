defmodule Peopleware.Profile  do
  use Peopleware.Web, :model

  schema "profiles" do
    field :name,               :string
    field :last_name,          :string
    field :second_surname,     :string
    field :last_salary,        :integer
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

 @required_fields ~w(name last_name last_salary position keywords email contracting_schema)
 @optional_fields ~w(second_surname tel cel state resume)

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields, @optional_fields)
    # |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/, message: "Formato Inválido")
    |> validate_unique(:email, on: Peopleware.Repo, message: "Cuenta de correo ya registrada")
    |> validate_length(:name, max: 40, message: "Debe ser máximo de 40 caracteres")
    |> validate_length(:last_name, max: 40, message: "Debe ser máximo de 40 caracteres")
    |> validate_length(:second_surname, max: 40, message: "Debe ser máximo de 40 caracteres")
    |> validate_inclusion(:last_salary, 0..200_000, message: "Cantidad inválida")
    |> validate_length(:position, max: 50, message: "Debe ser máximo de 50 caracteres")
    |> validate_length(:resume, max: 12000, message: "Debe ser máximo de 12000 caracteres")
    |> validate_length(:keywords, max: 500, message: "Debe ser máximo de 500 caracteres")
    |> validate_length(:email, max: 50, message: "Debe ser máximo de 50 caracteres")
    |> validate_length(:tel, max: 15, message: "Debe ser máximo de 15 caracteres")
    |> validate_length(:cel, max: 15, message: "Debe ser máximo de 15 caracteres")
    |> validate_length(:state, max: 20, message: "Debe ser máximo de 20 caracteres")
    |> validate_length(:contracting_schema, max: 30, message: "Debe ser máximo de 30 caracteres")
    |> validate_format(:tel, ~r/^\(\d{2}\) ?\d{6}( |-)?\d{4}|^\d{3}( |-)?\d{3}( |-)?\d{4}/, message: "Formato Inválido")
    |> validate_format(:cel, ~r/^\(\d{2}\) ?\d{6}( |-)?\d{4}|^\d{3}( |-)?\d{3}( |-)?\d{4}/, message: "Formato Inválido")
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
    "Estado de México",
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
    "Zacatecas",
    "Extranjero"]
  end

  def contractings do
     ["nómina", "mixto", "honorarios", "facturación", "asimilables a asalariados", "no estoy seguro"]
  end

end
