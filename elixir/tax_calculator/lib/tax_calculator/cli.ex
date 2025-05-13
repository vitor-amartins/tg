defmodule TaxCalculator.CLI do
  @moduledoc """
  Fornece uma interface de linha de comando para o cálculo de imposto de renda.
  """

  @doc """
  Ponto de entrada para a aplicação CLI.
  Recebe e processa os argumentos da linha de comando.
  """
  def main(args \\ []) do
    case args do
      [json_file] ->
        process_file(json_file)

      _ ->
        IO.puts("Uso: tax_calculator <arquivo.json>")
        System.halt(1)
    end
  end

  @doc """
  Processa um arquivo JSON de operações e imprime o resultado do cálculo.
  """
  def process_file(file_path) do
    case File.read(file_path) do
      {:ok, contents} ->
        process_json(contents)

      {:error, reason} ->
        IO.puts("Erro ao ler o arquivo: #{reason}")
        System.halt(1)
    end
  end

  @doc """
  Processa uma string JSON de operações e imprime o resultado do cálculo.
  """
  def process_json(json_string) do
    case Jason.decode(json_string) do
      {:ok, operations} ->
        tax = TaxCalculator.calculate_tax(operations)
        IO.puts(tax)

      {:error, reason} ->
        IO.puts("Erro ao decodificar JSON: #{reason}")
        System.halt(1)
    end
  end
end 