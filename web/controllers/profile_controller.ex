defmodule Peopleware.ProfileController do
  use Peopleware.Web, :controller
  alias Peopleware.Profile
  alias Peopleware.User

  plug :scrub_params, "profile" when action in [:create, :update]

  @doc """
  It just returns the list of all curriculums
  """
  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)
    profiles = Profile.get_users_by_type(user)
    render conn, "index.html", profiles: profiles
  end

  @doc """
  Setups everything we need to create a new profile
  """
  def new(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)
    profile = %Profile{
                name: user.name,
                last_name: user.last_name,
                second_surname: user.second_surname,
                email: user.email,
                user: user,
                role: "Desarrollador"}

    changeset = Profile.changeset(profile)
    render conn, "new.html", changeset: changeset
  end

  @doc """
  Invoked when the user selects the save button when in the new.html
  """
  def create(conn, %{"profile" => profile_params}) do

    # Get the last salary in string and converted to integer
    last_salary = change_salary_to_integer(profile_params)
    # Put the last salary into profile params
    profile_params = Map.put(profile_params, "last_salary", last_salary)

    user_id = get_session(conn, :user_id)
    changeset = Profile.changeset(%Profile{user_id: user_id}, profile_params)

    if changeset.valid? do
      upload_file_and_save(changeset, nil, get_file_to_upload(profile_params))
      conn = put_session(conn, :user_id, nil)

      # Get the path from the tmp file
      path = get_path_file(profile_params)

      # Send a email to recluit to advice that a new user has been created
      Peopleware.Mailer.send_register_email_to_recluit(profile_params, path)
      render conn, "welcome.html"
    else
      render conn, "new.html", changeset: changeset
    end
  end

  @doc """
  It shows the seleted curriculum
  """
  def show(conn, %{"id" => id}) do
    profile = Repo.get(Profile, id)
    render conn, "show.html", profile: profile
  end

  @doc """
  It just returns the list of curriculums
  """
  def edit(conn, %{"id" => id}) do
    profile = Repo.get(Profile, id)
    changeset = Profile.changeset(profile)
    render conn, "edit.html",
      profile: profile,
      changeset: changeset
  end

  @doc """
  Invoked when the user selects the save button inside the edit.html
  """
  def update(conn, %{"id" => id, "profile" => profile_params}) do
    profile = Profile.get_by_id(id)

    # Get the last salary in string and converted to integer
    last_salary = change_salary_to_integer(profile_params)
    # Put the last salary into profile params
    profile_params = Map.put(profile_params, "last_salary", last_salary)

    changeset = Profile.changeset(profile, profile_params)

    if changeset.valid? do

      upload_file_and_save(changeset, profile,
                           get_file_to_upload(profile_params))
      conn = put_session(conn, :user_id, nil)

      render conn, "thanks.html"
    else
      render(conn, "edit.html", profile: profile, changeset: changeset)
    end

  end

  @doc """
  Invoked when the user selects the delete button inside the index.html
  """
  def delete(conn, %{"id" => id}) do
    profile = Repo.get(Profile, id)
    Profile.delete_profile(profile)
    conn
    |> put_flash(:info, "CV borrado exitosamente.")
    |> redirect(to: profile_path(conn, :index))
  end

  def getCV(conn, %{"id" => id}) do
    document = Profile.get_file_by_id(id)

    conn
    |> put_resp_content_type(document.content_type)
    |> put_resp_header("content-disposition", "filename=" <> document.file_name)
    |> resp(200, document.content)
  end

######################################################
### Private API

  # Da de alta un cv pero sin archivo
  defp upload_file_and_save(changeset, nil, nil) do
    Repo.insert(changeset)
  end

  # Da de alta un CV nuevo con archivo
  defp upload_file_and_save(changeset, nil, file) do
    changeset = Ecto.Changeset.put_change(
                  changeset,
                  :cv_file_name,
                  file.file_name)

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
    changeset = Ecto.Changeset.put_change(
                  changeset,
                  :cv_file_name,
                  file.file_name)

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
    %Plug.Upload{
      path: path,
      content_type: content_type,
      filename: file_name} = file

    {:ok, %File.Stat{size: file_size}} = File.stat(path)
    {:ok, content} = File.read(path)

    %Peopleware.File{
      file_name: file_name,
      file_size: file_size,
      content_type: content_type,
      content: content}
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
