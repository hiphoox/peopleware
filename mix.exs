defmodule Peopleware.Mixfile do
  use Mix.Project

  def project do
    [app: :peopleware,
     version: "0.0.1",
     elixir: "~> 1.0.5",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     test_coverage: [tool: ExCoveralls]]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Peopleware, []},
     applications: [:phoenix, :cowboy, :logger, :phoenix_ecto, :phoenix_html, :postgrex, :mailgun, :secure_random, :comeonin, :inets, :ssl]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix,       "~> 1.0"},
     {:phoenix_ecto,  "~> 1.1"},
     {:phoenix_html,  "~> 2.2.0"},
     {:postgrex,      "~> 0.9.1"},
     {:phoenix_live_reload, "~> 1.0", only: [:dev]},
     {:cowboy,        "~> 1.0"},
     {:excoveralls,   "~> 0.3", only: [:dev, :test]},
     {:mailgun,       "~> 0.1.1"},
     {:secure_random, "~> 0.1"},
     {:comeonin,      "~> 1.1"},
     {:scrivener,     "~> 1.0"},
     {:scrivener_html, "~> 1.0"},
     {:shouldi, only: :test},
     {:exrm,          "~>0.18.1"}]
  end
end
