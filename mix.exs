defmodule Peopleware.Mixfile do
  use Mix.Project

  def project do
    [app: :peopleware,
     version: "0.0.1",
     elixir: "~> 1.0",
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
     applications: [:phoenix, :cowboy, :logger, :phoenix_ecto, :postgrex,
                    :mailgun, :secure_random, :comeonin, :inets, :ssl]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix,       "~> 0.13"},
     {:phoenix_ecto,  "~> 0.4"},
     {:phoenix_html,  "~> 1.0"},
     {:postgrex,      "~> 0.8"},
     {:phoenix_live_reload, "~> 0.3", only: [:dev]},
     {:cowboy,        "~> 1.0"},
     {:excoveralls,   "~> 0.3", only: [:dev, :test]},
     {:mailgun,       "~> 0.0.2"},
     {:secure_random, "~> 0.1"},
     {:comeonin,      "~> 0.8"},
     {:scrivener,     "~> 0.6.0"},
     {:shouldi, only: :test},
     {:exrm,          "~>0.15.3"}]
  end
end
