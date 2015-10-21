defmodule Peopleware.Repo.Migrations.UpdateLastSalary do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE profiles ALTER COLUMN 'last_salary' TYPE varchar"
  end
end
