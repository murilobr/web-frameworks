defmodule MyPhoenix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :my_phoenix,
      version: "0.0.1",
      elixir: "~> 1.7.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {MyPhoenix, []}, applications: [:phoenix, :cowboy, :logger, :gettext]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.1"},
      {:gettext, "~> 0.15.0"},
      {:cowboy, "~> 2.6.1"},
      {:distillery, "~> 2.0.0-rc.6"}
    ]
  end
end
