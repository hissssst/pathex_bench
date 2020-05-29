defmodule PathexBench.MixProject do
  use Mix.Project

  def project do
    [
      app: :pathex_bench,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application, do: []

  defp deps do
    [
      {:focus, "~> 0.3.5"},
      {:benchee, github: "bencheeorg/benchee"},
      {:pathex, "~> 0.2.0"}
    ]
  end
end
