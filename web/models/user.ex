defmodule Peopleware.User do
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
  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/, message: "Formato Inválido")
    |> validate_length(:email, max: 50, message: "Debe ser máximo de 50 caracteres")
    |> validate_unique(:email, on: Peopleware.Repo, message: "Cuenta de correo ya registrada")
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

end