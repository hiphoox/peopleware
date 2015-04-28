defmodule Peopleware.Profile  do
  use Peopleware.Web, :model
  alias Peopleware.Repo

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
    field       :role,            :string
    timestamps
  end

 @required_fields ~w(user_id name last_name last_salary position keywords email contract_schema residence travel english_level role)
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
  end

  def get_users_by_type(user) do
    if user.is_staff do
      query = Peopleware.Profile
    else
      query = from profile in Peopleware.Profile,
             where: profile.user_id == ^user.id
    end
    Repo.all(query)
  end

  def get_by_user_type(user) do
    if user.is_staff do
      query = Peopleware.Profile
    else
      query = from profile in Peopleware.Profile,
             where: profile.user_id == ^user.id
    end
    Repo.one(query)
  end

  def get_by_id(id) do
    Repo.get from(p in Peopleware.Profile, preload: [:cv_file]), id
  end

  def get_file_by_id(id) do
    query = from file in Peopleware.File,
            where: file.profile_id == ^id

    Repo.one(query)
  end

  def delete_profile(profile) do
    file = Repo.one assoc(profile, :cv_file)
    Repo.transaction(fn ->
      unless file == nil, do: Repo.delete(file)
      Repo.delete(profile)
    end)
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

  def roles do
    ["Otro",
    "Desarrollador",
    "Analista de negocio",
    "Analista de procesos",
    "Analista programador",
    "Arquitecto de aplicaciones",
    "Arquitecto de soluciones",
    "Business Intelligence",
    "Comunicaciones",
    "Director",
    "DBA",
    "EBS Funcional",
    "EBS developer",
    "Gerente",
    "Ingeniero de seguridad",
    "Líder de proyecto",
    "Operador",
    "Project manager",
    "Quality assurance",
    "SAP developer",
    "SAP funcional",
    "Soporte a infraestructura",
    "Soporte técnico",
    "Tester",
    "Ventas"]
  end

end
