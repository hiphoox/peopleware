defmodule Peopleware.Profile  do
  use Peopleware.Web, :model

  schema "profiles" do
    belongs_to  :user,            Peopleware.User
    has_one     :cv_file,         Peopleware.File
    field       :name,            :string
    field       :last_name,       :string
    field       :second_surname,  :string
    field       :last_salary,     :integer
    field       :position,        :string
    field       :resume,          :string
    field       :keywords,        :string
    field       :email,           :string
    field       :cel,             :string
    field       :tel,             :string
    field       :state,           :string   # Lista de estados
    field       :contract_schema, :string   #nómina, mixto, honorarios, facturación, asimilables a salarios, no estoy seguro
    field       :cv_file_name,    :string
    field       :residence,       :string
    field       :travel,          :string
    field       :english_level,   :string
    timestamps
  end

 @required_fields ~w(user_id name last_name last_salary position keywords email contract_schema residence travel english_level)
 @optional_fields ~w(tel cel state resume second_surname)

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields, @optional_fields)
    # |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/, message: "Formato Inválido")
    |> validate_length(:email, max: 50, message: "Debe ser máximo de 50 caracteres")
    |> validate_inclusion(:last_salary, 0..200_000, message: "Cantidad inválida")
    |> validate_length(:position, max: 50, message: "Debe ser máximo de 50 caracteres")
    |> validate_length(:resume, max: 12000, message: "Debe ser máximo de 12000 caracteres")
    |> validate_length(:keywords, max: 500, message: "Debe ser máximo de 500 caracteres")
    |> validate_length(:state, max: 20, message: "Debe ser máximo de 20 caracteres")
    |> validate_length(:contract_schema, max: 30, message: "Debe ser máximo de 30 caracteres")
    |> validate_length(:tel, max: 15, message: "Debe ser máximo de 15 caracteres")
    |> validate_length(:cel, max: 15, message: "Debe ser máximo de 15 caracteres")
    # |> validate_format(:tel, ~r/^\(\d{2}\) ?\d{6}( |-)?\d{4}|^\d{3}( |-)?\d{3}( |-)?\d{4}/, message: "Formato Inválido")
    # |> validate_format(:cel, ~r/^\(\d{2}\) ?\d{6}( |-)?\d{4}|^\d{3}( |-)?\d{3}( |-)?\d{4}/, message: "Formato Inválido")
  end

  def get_by_user_type(user) do
    if user.is_staff do
      query = Peopleware.Profile
    else
      query = from profile in Peopleware.Profile,
             where: profile.user_id == ^user.id
    end
    Peopleware.Repo.all(query)
  end

  def get_by_id(id) do
    Peopleware.Repo.get from(p in Peopleware.Profile, preload: [:cv_file]), id
  end

  def get_file_by_id(id) do
    query = from file in Peopleware.File,
            where: file.profile_id == ^id

    Peopleware.Repo.one(query)
  end

  def contractings do
     ["nómina", "mixto", "honorarios", "facturación", "asimilables a asalariados", "no estoy seguro"]
  end

  def idiom_levels do
    ["No", "Basico", "intermedio", "avanzado"]
  end

  def option_levels do
    ["No", "Si", "Tal vez"]
  end

  def states do
    ["Distrito Federal",
    "Aguascalientes",
    "Baja California",
    "Campeche",
    "Coahuila",
    "Colima",
    "Chiapas",
    "Chihuahua",
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

end
