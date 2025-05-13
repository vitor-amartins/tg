defmodule TaxCalculator.MixProject do
  use Mix.Project

  def project do
    [
      app: :tax_calculator,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :jason]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"}
    ]
  end

  # Configuração para gerar um executável via escript
  defp escript do
    [
      main_module: TaxCalculator.CLI,
      comment: "Calculadora de Imposto de Renda para Operações de Ações"
    ]
  end
end
