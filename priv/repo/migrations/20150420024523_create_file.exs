defmodule Peopleware.Repo.Migrations.CreateFile do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :file_name,     :string,  size: 100
      add :file_size,     :integer
      add :content_type,  :string,  size: 50
      add :content,       :binary
      add :profile_id,    references(:profiles)

      timestamps
    end
  end
end
