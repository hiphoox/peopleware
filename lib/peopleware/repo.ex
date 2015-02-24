defmodule Peopleware.Repo do
	use Ecto.Repo, 
		otp_app: :peopleware, 
		adapter: Ecto.Adapters.Postgres

	def priv do
		Application.app_dir(:peopleware, "priv/repo")
	end
	
end