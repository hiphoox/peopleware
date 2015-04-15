defmodule Peopleware.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name,           :string, size: 40
      add :last_name,      :string, size: 40
      add :second_surname, :string, size: 40
      add :reset_token,    :string
      add :password,       :string
      add :email,          :string
      add :confirmed,      :boolean, default: false
      add :is_staff,       :boolean, default: false
      add :is_active,      :boolean, default: false
      add :is_superuser,   :boolean, default: false

      timestamps
    end
  end

end
