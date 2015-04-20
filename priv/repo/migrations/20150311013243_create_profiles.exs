defmodule Peopleware.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name,            :string, size: 40
      add :last_name,       :string, size: 40
      add :second_surname,  :string, size: 40
      add :last_salary,     :integer
      add :position,        :string, size: 50
      add :resume,          :string, size: 12000
      add :keywords,        :string, size: 500
      add :email,           :string, size: 50
      add :tel,             :string, size: 15
      add :cel,             :string, size: 15
      add :state,           :string, size: 20   # Lista de estados
      add :contract_schema, :string, size: 30   #nómina, mixto, honorarios, facturación, asimilables a salarios, no estoy seguro
      add :cv_file_name,    :string
      add :user_id,         references(:users)

      timestamps
    end
  end

end
