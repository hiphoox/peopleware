defmodule Peopleware.Profile  do
  use Peopleware.Web, :model

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

  def changeset(model, params \\ nil) do
    model
      |> cast(params, ~w(name last_name last_salary position keywords email contracting_schema), ~w(second_surname tel cel state resume))
      # |> update_change(:email, &String.downcase/1)
      |> validate_format(:email, ~r/@/)
      |> validate_unique(:email, on: Peopleware.Repo)
      |> validate_length(:name, max: 40)
      |> validate_length(:last_name, max: 40)
      |> validate_length(:second_surname, max: 40)
      |> validate_length(:last_salary, max: 20)
      |> validate_length(:position, max: 50)
      |> validate_length(:resume, max: 5000)
      |> validate_length(:keywords, max: 500)
      |> validate_length(:email, max: 50)
      |> validate_length(:tel, max: 15)
      |> validate_length(:cel, max: 15)
      |> validate_length(:state, max: 20)
      |> validate_length(:contracting_schema, max: 30)
      |> validate_format(:tel, ~r/^(?:[0-9]\x20?){7,9}[0-9]$/)
      |> validate_format(:cel, ~r/^(?:[0-9]\x20?){7,9}[0-9]$/)
  end

  def profile_from_values(profile_values, id) do
    %Peopleware.Profile{
                        id: id,
                      name: profile_values["name"],  
                 last_name: profile_values["last_name"],
            second_surname: profile_values["second_surname"],
               last_salary: profile_values["last_salary"],
                  position: profile_values["position"],
                    resume: profile_values["resume"],
                  keywords: profile_values["keywords"],
                     email: profile_values["email"],
                       cel: profile_values["cel"],
                       tel: profile_values["tel"],
                     state: profile_values["state"],
        contracting_schema: profile_values["contracting_schema"],
    }
  end

  def get_message(:required) do
    "Campo Obligatorio" 
  end

  def get_message(:unique) do
    "Cuenta de correo ya registrada"
  end

  def get_message(:format) do
    "Formato incorrecto"
  end

  def get_message(:length) do
    "Longitud incorrecta"
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