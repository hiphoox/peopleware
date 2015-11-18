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
      changeset = Profile.changeset(%Profile{})
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

    if user.is_staff do
      if changeset.valid? do
        upload_file_and_save(changeset, nil, get_file_to_upload(profile_params))

        conn
        |> put_flash(:info, "User created succesfully.")
        |> redirect(to: user_path(conn, :index))
      else
        render conn, "new.html", changeset: changeset, user: user
      end
    else
      redirect(conn, to: profile_path(conn, :index))
    end

  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render conn, "show.html", user: user
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user)
    render conn, "edit.html", user: user, changeset: changeset
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, user_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "User updated succesfully.")
      |> redirect(to: user_path(conn, :index))
    else
      render conn, "edit.html", user: user, changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    User.delete_user_with_id(id)

    conn
    |> put_flash(:info, "User deleted succesfully.")
    |> redirect(to: user_path(conn, :index))
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
    %{path: path, content_type: content_type, filename: file_name} = file
    file_path = path
    file_path
  end

  defp get_path_file(_param) do
    nil
  end

  defp change_salary_to_integer(%{"last_salary" => last_salary}) do
    if last_salary != "" do
      last_salary
      |> String.replace(",", "")
      |> String.to_integer
    else
      ""
    end
  end



end
