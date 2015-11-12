defmodule Peopleware.SearchController do
  use Peopleware.Web, :controller
  # require IEx
  alias Peopleware.Profile
  alias Peopleware.User

  @page 1
  @count 10

  plug :scrub_params, "profile" when action in [:create, :update]

  @doc """
  It just returns the list of all curriculums
  """
  def index(conn, _params) do

    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)

    if user.is_staff do
      changeset = Profile.changeset(%Profile{})
      render conn, "search.html", changeset: changeset
    else
      redirect(conn, to: profile_path(conn, :index))
    end

  end

  def search(conn, %{"profile" => profile_params}) do

    user_id = get_session(conn, :user_id)
    user = Repo.get(User, user_id)

    if user.is_staff do

      last_salary = change_salary_to_integer(profile_params)
      profile_params = Map.put(profile_params, "last_salary", last_salary)

      token = get_csrf_token

      profiles = Profile.search(@page, @count, profile_params)

      if profile_params["is_first"] == "true" do
        english_fields = get_english_fields(profiles.entries)
        conn = put_session(conn, :english_fields, english_fields)
      else
        english_fields = get_session(conn, :english_fields)
      end


      render conn, "results.html",
        profiles: profiles.entries,
        page: profiles,
        profile_params: profile_params,
        token: token,
        english_fields: english_fields
    else
      redirect(conn, to: profile_path(conn, :index))
    end

  end

  defp change_salary_to_integer(%{"last_salary" => last_salary}) do
    if last_salary != "" do
      last_salary
      |> String.replace(",", "")
      |> String.to_integer
    else
      ""
    end
  end

  defp get_english_fields(profile_entries) do

    fields = Enum.reduce(profile_entries, %{}, fn (x, acc) ->

       %Peopleware.Profile{english_level: english_level} = x
       Map.put(acc, english_level , english_level)
    end)

    fields
  end


end
