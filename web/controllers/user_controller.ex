defmodule Peopleware.UserController do
  use Peopleware.Web, :controller
  alias Peopleware.Profile
  alias Peopleware.User

  plug :scrub_params, "profile" when action in [:create, :update]

  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)

    if user.is_staff do
      users = Repo.all(User)
      render conn, "index.html", users: users
    else
      redirect(conn, to: profile_path(conn, :index))
    end

  end

  def new(conn, _params) do

    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)

    if user.is_staff do

      email = get_session(conn, :email_profile)
      changeset = Profile.changeset(%Profile{email: email})


      render conn, "new.html",
        changeset: changeset
    else
      redirect(conn, to: profile_path(conn, :index))
    end

  end

  def create(conn, %{"profile" => profile_params}) do

    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)

    last_salary = change_salary_to_integer(profile_params)
    profile_params = Map.put(profile_params, "last_salary", last_salary)
    profile_params =  Map.put(profile_params, "created_by", user.email)

    changeset = Profile.changeset(%Profile{user_id: nil}, profile_params)

    if profile_params["cv_file"] != nil do
      %Plug.Upload{path: _, content_type: _, filename: file_name} = profile_params["cv_file"]

      if String.length(file_name) > 150 do
          changeset = Ecto.Changeset.add_error(
                        changeset,
                        :cv_file_name,
                        "es demasiado largo")
      end
    end

    if user.is_staff do
      if changeset.valid? do
        upload_file_and_save(changeset, nil, get_file_to_upload(profile_params))

        conn
        |> put_session(:email, nil)
        |> put_flash(:created, "Usuario creado satisfactoriamente.")
        |> redirect(to: user_path(conn, :index))
      else
        render conn, "new.html", changeset: changeset, user: user
      end
    else
      redirect(conn, to: profile_path(conn, :index))
    end

  end

  def show(conn, %{"id" => id}) do
    redirect(conn, to: user_path(conn, :index))
  end

  def edit(conn, %{"id" => id}) do

    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)

    if user.is_staff do
      profile = Repo.get(Profile, id)
      changeset = Profile.changeset(profile)
      render conn, "edit.html", profile: profile, changeset: changeset
    else
      redirect(conn, to: profile_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "profile" => profile_params}) do
    profile = Profile.get_by_id(id)

    last_salary = change_salary_to_integer(profile_params)
    profile_params = Map.put(profile_params, "last_salary", last_salary)

    changeset = Profile.changeset(profile, profile_params)

    if profile_params["cv_file"] != nil do
      %Plug.Upload{path: _, content_type: _, filename: file_name} = profile_params["cv_file"]

      if String.length(file_name) > 150 do
          changeset = Ecto.Changeset.add_error(
                        changeset,
                        :cv_file_name,
                        "es demasiado largo")
      end
    end

    if changeset.valid? do

      upload_file_and_save(changeset, profile,
                           get_file_to_upload(profile_params))

      conn
      |> put_flash(:updated, "Usuario actualizado satisfactoriamente.")
      |> redirect(to: search_path(conn, :search))
    else
      render conn, "edit.html", profile: profile, changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    User.delete_user_with_id(id)

    conn
    |> put_flash(:info, "User deleted succesfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def getCV(conn, %{"id" => id}) do

    document = Profile.get_file_by_id(id)

    conn
    |> put_resp_content_type(document.content_type)
    |> put_resp_header("content-disposition", "filename=" <> document.file_name)
    |> resp(200, document.content)
  end

  def search(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)

    if user.is_staff do
      token = get_csrf_token
      profile = get_session(conn, :profile)

      render conn, "search.html",
        token: token,
        profile: profile
    else
      redirect(conn, to: profile_path(conn, :index))
    end
  end

  def reclu_data(conn, %{"date1" => date1, "date2" => date2}) do
    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)

    if user.is_staff do
      token = get_csrf_token

      if date1 == nil or date1 == "" do
        date1 = "2014-01-01"
      end

      if date2 == nil or date2 == "" do
        date2 = "2020-12-31"
      end

      data =  Peopleware.Profile.get_by_reclu(date1 <> " 00:00:01", date2 <> " 23:59:59")

      users = Peopleware.User.get_staff

      render conn, "reclu-data.html",
        data: data,
        token: token,
        date1: date1,
        date2: date2,
        users: users
    else
      redirect(conn, to: profile_path(conn, :index))
    end
  end

  def reclu_data(conn, _) do
    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)

    if user.is_staff do
      token = get_csrf_token
      render conn, "reclu-data.html",
      data: [],
      token: token,
      date1: nil,
      date2: nil,
      users: nil
    else
      redirect(conn, to: profile_path(conn, :index))
    end
  end

  def search_applicant(conn, %{"email" => email}) do

    if email == nil or email == "" do
      conn
      |> put_flash(:no_email, "Debe introducir un email")
      |> redirect(to: user_path(conn, :search))
    end

    # Validate email
    case Regex.run(~r/^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/, email) do
      nil ->
        conn
        |> put_flash(:no_email, "Formato inválido")
        |> redirect(to: user_path(conn, :search))
      _ ->
        email = email
    end

    profile = Profile.get_by_email(email)

    if profile == nil do
      conn
      |> put_session(:email_profile, email)
      |> redirect(to: user_path(conn, :new))
    else
      conn
      |> put_session(:profile, profile.id)
      |> put_flash(:updated, "Ya existe un candidato con el email " <> profile.email)
      |> redirect(to: user_path(conn, :search))
    end
  end

  ######################################################
### Private API

  # Da de alta un cv pero sin archivo
  defp upload_file_and_save(changeset, nil, nil) do
    Repo.insert(changeset)
  end

  # Da de alta un CV nuevo con archivo
  defp upload_file_and_save(changeset, nil, file) do
    changeset = Ecto.Changeset.put_change(changeset, :cv_file_name, file.file_name)
    {:ok, profile} = Repo.insert(changeset)
    file = %{file | profile_id: profile.id}
    Repo.insert(file)
    profile
  end

  # Actualiza un CV sin archivo
  defp upload_file_and_save(changeset, _, nil) do
    Repo.update(changeset)
  end

  # Actualiza un CV con archivo
  defp upload_file_and_save(changeset, profile, file) do
    changeset = Ecto.Changeset.put_change(changeset, :cv_file_name, file.file_name)

    if profile.cv_file do #El profile ya tiene un archivo asociado
      cv_file = %{profile.cv_file |
                          file_name:    file.file_name,
                          file_size:    file.file_size,
                          content_type: file.content_type,
                          content:      file.content}
      {:ok, profile} = Repo.transaction(fn ->
        Repo.update(cv_file)
        Repo.update(changeset)
      end)
      profile
    else  # El profile todavía no tiene un archivo asociado
      file = %{file | profile_id: profile.id}
      {:ok, profile} = Repo.transaction(fn ->
        Repo.insert(file)
        Repo.update(changeset)
      end)
      profile
    end
  end

  defp get_file_to_upload(%{"cv_file" => file}) do
    %Plug.Upload{path: path, content_type: content_type, filename: file_name} = file
    {:ok, %File.Stat{size: file_size}} = File.stat(path)
    {:ok, content} = File.read(path)
    %Peopleware.File{file_name: file_name, file_size: file_size, content_type: content_type, content: content}
  end

  defp get_file_to_upload(_param) do
    nil
  end

  defp get_path_file(%{"cv_file" => file}) do
    %{path: path, content_type: _, filename: _} = file
    file_path = path
    file_path
  end

  defp get_path_file(_param) do
    nil
  end

  defp change_salary_to_integer(%{"last_salary" => last_salary}) do
    if last_salary != nil do
      last_salary
      |> String.replace(",", "")
      |> String.to_integer
    else
      ""
    end
  end



end
