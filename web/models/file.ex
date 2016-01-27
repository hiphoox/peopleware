defmodule Peopleware.File do
  use Peopleware.Web, :model

  schema "files" do
    belongs_to  :profile,      Peopleware.Profile
    field       :file_name,    :string
    field       :file_size,    :integer
    field       :content_type, :string
    field       :content,      :binary

    timestamps
  end

  @required_fields ~w(profile_id file_name file_size content_type content)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:file_name, max: 100, message: "Debe ser máximo de 100 caracteres")
  end
end
