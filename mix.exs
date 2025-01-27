defmodule Foodbank.MixProject do
  use Mix.Project

  def project do
    [
      app: :foodbank,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Foodbank.Application, []},
      extra_applications: [:logger, :eventstore]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:commanded, "~> 1.4.0"},
      {:commanded_ecto_projections, "~> 1.4.0"},
      {:commanded_eventstore_adapter, "~> 1.4.0", runtime: Mix.env() != :test},
      {:eventstore, "~> 1.4.0", runtime: Mix.env() != :test},
      {:jason, "~> 1.4.0"},
      {:typed_struct, "~> 0.3.0"},
      {:typed_ecto_schema, "~> 0.4.0"}
    ]
  end

  defp aliases do
    [
      setup: ["reset_es", "ecto.reset", "ecto.migrate"],
      setup_es: ["event_store.create", "event_store.init"],
      reset_es: ["event_store.drop", "event_store.create", "event_store.init"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
