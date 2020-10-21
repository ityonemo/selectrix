defmodule Selectrix.MixProject do
  use Mix.Project

  def project do
    [
      app: :selectrix,
      version: "0.0.1",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/_support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:mavis, "~> 0.0.1"},
      {:mavis_inference, git: "https://github.com/ityonemo/mavis_inference", branch: "main"}
    ]
  end
end
