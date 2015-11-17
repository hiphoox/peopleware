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

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    # |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/, message: "Formato Inválido")
    |> validate_format(:name, ~r/(?!^\d+$)^.+$/, message: "El nombre no debe contener solo números")
    |> validate_format(:last_name, ~r/(?!^\d+$)^.+$/, message: "El apellido no debe contener solo números")
    |> validate_format(:second_surname, ~r/(?!^\d+$)^.+$/, message: "El segundo apellido no debe contener solo números")
    |> validate_format(:position, ~r/(?!^\d+$)^.+$/, message: " de trabajo no debe contener solo números")
    |> validate_length(:email, max: 50, message: "Debe ser máximo de 50 caracteres")
    |> validate_length(:position, max: 50, message: "Debe ser máximo de 50 caracteres")
    |> validate_length(:resume, max: 12000, message: "Debe ser máximo de 12000 caracteres")
    |> validate_length(:keywords, max: 500, message: "Debe ser máximo de 500 caracteres")
    |> validate_length(:state, max: 20, message: "Debe ser máximo de 20 caracteres")
    |> validate_length(:contract_schema, max: 30, message: "Debe ser máximo de 30 caracteres")
    |> validate_length(:tel, max: 15, message: "Debe ser máximo de 15 caracteres")
    |> validate_length(:cel, max: 15, message: "Debe ser máximo de 15 caracteres")
    |> validate_inclusion(:last_salary, 0..200_000, message: "Cantidad inválida")
  end

  #####################
  # Queries
  #####################

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


  ###########################################
  # Search
  ###########################################

  def search(page, count, search_criteria) do
    Peopleware.Profile
    |> has_keywords(search_criteria)
    |> has_role(search_criteria)
    |> has_state(search_criteria)
    |> has_contract_schema(search_criteria)
    |> has_residence(search_criteria)
    |> can_travel(search_criteria)
    |> has_english_level(search_criteria)
    |> has_salary(search_criteria)
    |> Repo.paginate(page: page, page_size: count)
  end

  def has_keywords(query, %{"keywords" => keywords}) do
    if keywords != "" do
      keyword_criteria = build_criteria(keywords, " | ") # We use OR inside the keyword field
      resume_criteria  = build_criteria(keywords)        # We use AND inside the resume field
      from p in query,
      where: fragment("to_tsvector('spanish', keywords) @@ to_tsquery('spanish', ?)", ^keyword_criteria) or
             fragment("to_tsvector('spanish', resume) @@ to_tsquery('spanish', ?)", ^resume_criteria)
    else
      query
    end
  end

  def build_criteria(keywords, operator \\ " & ") do
    keywords
    |> String.strip(?,)   # Removing any , at the begining or at the end of the text.
    |> String.split(",")  # Getting a list of keywords
    |> Enum.map( &prepare_item &1)  # Setting the format that Postgres's ts_query requires
    |> Enum.join(operator) # Using the *operator* to concatenate the keywords
  end

  def prepare_item(item) do
    new =
      item
      |> String.strip   # Remove any space at the begining or at the end of the keyword
      |> String.replace(" ", "\\ ")  # Escaping the blanks between a keyword that has multiple words

    "(" <> new <> ")"   # Putting the keyword inside () in order to combine it with other keywords
  end

  def has_role(query, %{"role" => role}) do
    if role != "" do

      # We need to check if the data is a map or just string
      if is_map(role) do
        # If is a map, then we need to get the values from keys and
        # create a list
        {_, role} = Enum.unzip(role)

        # Query from list
        from p in query,
        where: p.role in ^role
      else
        # If is a value then is a simple equal query
        from p in query,
        where: p.role == ^role
      end

    else
      query
    end
  end

  def has_state(query, %{"state" => state}) do
    if state != "" do
      # We need to check if the data is a map or just string
      if is_map(state) do
        # If is a map, then we need to get the values from keys and
        # create a list
        {_, state} = Enum.unzip(state)

        # Query from list
        from p in query,
        where: p.state in ^state
      else
        # If is a value then is a simple equal query
        from p in query,
        where: p.state == ^state
      end
    else
      query
    end
  end

  def has_contract_schema(query, %{"contract_schema" => contract_schema}) do
    if contract_schema != "" do
      # We need to check if the data is a map or just string
      if is_map(contract_schema) do
        # If is a map, then we need to get the values from keys and
        # create a list
        {_, contract_schema} = Enum.unzip(contract_schema)

        # Query from list
        from p in query,
        where: p.contract_schema in ^contract_schema
      else
        # If is a value then is a simple equal query
        from p in query,
        where: p.contract_schema == ^contract_schema
      end
    else
      query
    end
  end

  def has_residence(query, %{"residence" => residence}) do
    if residence != "" do
      from p in query,
      where: p.residence == ^residence
    else
      query
    end
  end

  def can_travel(query, %{"travel" => travel}) do
    if travel != "" do
      from p in query,
      where: p.travel == ^travel
    else
      query
    end
  end

  def has_english_level(query, %{"english_level" => english_level}) do
    if english_level != "" do

      # We need to check if the data is a map or just string
      if is_map(english_level) do
        # If is a map, then we need to get the values from keys and
        # create a list
        {_, english_level} = Enum.unzip(english_level)

        # Query from list
        from p in query,
        where: p.english_level in ^english_level
      else
        # If is a value then is a simple equal query
        from p in query,
        where: p.english_level == ^english_level
      end
    else
      query
    end
  end

  def has_salary(query, %{"last_salary" => last_salary}) do
    if last_salary != "" do
      from p in query,
      where: p.last_salary <= ^last_salary
    else
      query
    end
  end

  #####################
  # Catalogs
  #####################
  def contractings do
    ["nómina", "mixto", "honorarios", "facturación", "asimilables a asalariados", "no estoy seguro"]
  end

  def idiom_levels do
    ["No", "Basico", "Intermedio", "Avanzado"]
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
