defmodule Peopleware.Repo.Migrations.ProfileAddNewField do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
        add :created_by, :string
    end
  end
end
