defmodule Peopleware.Repo do
  use Ecto.Repo, otp_app: :peopleware
  use Scrivener, page_size: 10
end
