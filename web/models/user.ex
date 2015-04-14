defmodule Peopleware.User do
  use Peopleware.Web, :model

  schema "users" do
    field :username, :string
    field :name, :string
    field :last_name, :string
    field :password, :string
    field :password_confirmation, :string, virtual: true
    field :email, :string
    field :is_staff, :boolean, default: false
    field :is_active, :boolean, default: false
    field :is_superuser, :boolean, default: false

    timestamps
  end

  @required_fields ~w(username name last_name password password_confirmation email )
  @optional_fields ~w(is_staff is_active is_superuser)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ nil) do
    cast(model, params, @required_fields, @optional_fields)
  end

  def get_by_email(email) do
    query = from user in Peopleware.User,
            where: user.email == ^email
    query |> Peopleware.Repo.one
  end

end