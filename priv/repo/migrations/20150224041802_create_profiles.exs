defmodule Peopleware.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def up do
    create table(:profiles) do
      add :name,               :string, size: 40  
      add :last_name,          :string, size: 40
      add :second_surname,     :string, size: 40
      add :last_salary,        :string, size: 20
      add :position,           :string, size: 40
      add :resume,             :string, size: 100
      add :keywords,           :string, size: 50
      add :type_medium,        :string, size: 40   # Celular, casa, correo electrónico
      add :info_medium,        :string, size: 40
      add :state,              :string, size: 40   # Lista de estados
      add :contracting_schema, :string, size: 40   #nómina, mixto, honorarios, facturación, asimilables a salarios, no estoy seguro

      timestamps
    end

  end

  def down do
    drop table(:profiles)
  end
end
