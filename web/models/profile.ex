defmodule Peopleware.Profile  do
  use Ecto.Model

  schema "profiles" do
    field :name,               :string
    field :last_name,          :string
    field :second_surname,     :string
    field :last_salary,        :string
    field :position,           :string
    field :resume,             :string
    field :keywords,           :string
    field :type_medium,        :string   # Celular, casa, correo electrónico
    field :info_medium,        :string
    field :state,              :string   # Lista de estados
    field :contracting_schema, :string   #nómina, mixto, honorarios, facturación, asimilables a salarios, no estoy seguro
    timestamps
  end


  def changeset(profile, params \\ nil) do
    params
    |> cast(profile, ~w(name last_name last_salary position type_medium info_medium contracting_schema), ~w(state second_surname resume keywords))
    #|> validate_format(:name, ~r/@/)
    # |> validate_number(:age, more_than: 18)
    # |> validate_unique(:email, Repo)
  end
end