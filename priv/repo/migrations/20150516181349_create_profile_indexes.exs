defmodule Peopleware.Repo.Migrations.CreateProfileIndexes do
  use Ecto.Migration

  def up do
    execute "CREATE INDEX profiles_keywords_index ON profiles USING gin(to_tsvector('spanish', keywords));"
    execute "CREATE INDEX profiles_resume_index ON profiles USING gin(to_tsvector('spanish', resume));"
  end

  def down do
    execute "DROP INDEX profiles_keywords_index;"
    execute "DROP INDEX profiles_resume_index;"
  end
end
