defmodule Peopleware.Repo.Migrations.UpdateLastSalary do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE public.profiles ALTER COLUMN last_salary TYPE varchar(12);"
  end
end
