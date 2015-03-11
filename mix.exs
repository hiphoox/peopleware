defmodule Peopleware.Mixfile do
  use Mix.Project

  def project do
    [app: :peopleware,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Peopleware, []},
     applications: [:phoenix, :cowboy, :logger, :postgrex, :phoenix_ecto]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, github: "phoenixframework/phoenix", override: true},
     {:cowboy, "~> 1.0"},
     {:phoenix_ecto, "~> 0.1"},
     {:postgrex, "~> 0.8"},
     {:exrm, "~>0.15.0"}]
  end
end
