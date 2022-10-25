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
      {:benchee, "~> 1.0"},
      {:focus, "~> 0.3.5"},
      {:lens, "~> 1.0.0"},
      {:floki, "~> 0.32.0"},
      {:meeseeks, "~> 0.16"},

      # {:pathex, "~> 2.3"},
      {:pathex, path: "../pathex", override: true},
      # {:pathex_html, path: "../pathex_html"},
    ]
  end
end
