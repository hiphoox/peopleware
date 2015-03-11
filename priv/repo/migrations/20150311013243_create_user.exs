defmodule Peopleware.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :first_name, :string
      add :last_name, :string
      add :password, :string
      add :email, :string
      add :is_staff, :boolean, default: false
      add :is_active, :boolean, default: false
      add :is_superuser, :boolean, default: false

      timestamps
    end
  end
end
