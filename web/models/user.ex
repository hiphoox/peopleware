defmodule Peopleware.User do
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  use Peopleware.Web, :model
  alias Peopleware.Repo
  alias Peopleware.Profile
  alias Peopleware.User


  schema "users" do
    has_many  :profiles,       Profile
    field     :name,           :string
    field     :last_name,      :string
    field     :second_surname, :string
    field     :email,          :string
    field     :reset_token,    :string
    field     :password,       :string
    field     :password_conf,  :string,  virtual: true
    field     :confirmed,      :boolean, default: false
    field     :is_staff,       :boolean, default: false
    field     :is_active,      :boolean, default: false
    field     :is_superuser,   :boolean, default: false
    timestamps
  end

  @required_fields ~w(name last_name email password )
  @optional_fields ~w(reset_token second_surname password_conf confirmed is_staff is_active is_superuser)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> hash_password
    |> validate_format(:email, ~r/^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/, message: "Formato Inválido")
    |> validate_length(:email, max: 50, message: "Debe ser máximo de 50 caracteres")
    |> validate_format(:name, ~r/(?!^\d+$)^.+$/, message: "El nombre no debe contener solo números")
    |> validate_format(:last_name, ~r/(?!^\d+$)^.+$/, message: "El apellido no debe contener solo números")
    |> validate_format(:second_surname, ~r/(?!^\d+$)^.+$/, message: "El segundo apellido no debe contener solo números")
    |> unique_constraint(:email, message: "Cuenta de correo ya registrada")
    |> validate_length(:name, max: 40, message: "Debe ser máximo de 40 caracteres")
    |> validate_length(:last_name, max: 40, message: "Debe ser máximo de 40 caracteres")
    |> validate_length(:second_surname, max: 40, message: "Debe ser máximo de 40 caracteres")
  end

  def get_by_email(email) do
    query = from user in User,
            where: user.email == ^email
    query |> Peopleware.Repo.one
  end

  def get_by_token(token) do
    query = from user in User,
            where: user.reset_token == ^token
    query |> Peopleware.Repo.one
  end

  def delete_user_with_id(id) do
    user = Repo.get from(user in User, preload: [:profiles]), id
    Repo.transaction(fn ->
      Enum.each(user.profiles, fn profile -> Profile.delete_profile(profile) end)
      Repo.delete(user)
    end)
  end

  def get_staff do
    query = from p in Peopleware.User,
    where: p.is_staff == true

    Repo.all(query)
  end

  # Created a password hashed to store in database
  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password, hashpwsalt(password))
    else
      changeset
    end
  end

end
