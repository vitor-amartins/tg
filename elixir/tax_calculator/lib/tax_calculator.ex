defmodule TaxCalculator do
  @moduledoc """
  Calcula o imposto de renda sobre operações de compra e venda de ações.
  """

  @doc """
  Calcula o imposto de renda devido sobre uma lista de operações de compra e venda de ações.

  ## Parâmetros

    * `operations` - Lista de operações no formato:
      [
        %{"type" => "buy", "unitCost" => 10.00, "amount" => 100},
        %{"type" => "sell", "unitCost" => 20.00, "amount" => 50}
      ]

  ## Retorno

    Um número de ponto flutuante representando o imposto total devido.

  ## Regras

    * Compras atualizam o preço médio ponderado das ações
    * Vendas utilizam o preço médio para calcular lucro/prejuízo
    * Vendas totais ≤ R$20.000 são isentas de imposto
    * Tributação de 15% sobre o lucro em vendas > R$20.000
    * Prejuízos podem ser compensados em lucros futuros
  """
  def calculate_tax(operations) do
    operations
    |> process_operations()
    |> Float.round(2)
  end

  defp process_operations(operations) do
    # Estado inicial: sem ações, sem lucro/prejuízo acumulado, sem imposto
    initial_state = %{
      average_cost: 0.0,       # Preço médio das ações em carteira
      shares: 0,               # Quantidade de ações em carteira
      accumulated_loss: 0.0,   # Prejuízo acumulado para compensação futura
      total_tax: 0.0           # Imposto acumulado
    }

    # Processa cada operação sequencialmente
    Enum.reduce(operations, initial_state, fn operation, state ->
      case operation["type"] do
        "buy" -> process_buy(operation, state)
        "sell" -> process_sell(operation, state)
      end
    end)
    |> Map.get(:total_tax)
  end

  # Processa uma operação de compra
  defp process_buy(operation, state) do
    amount = operation["amount"]
    unit_cost = operation["unitCost"]
    current_amount = state.shares
    current_cost = state.average_cost

    # Atualiza o preço médio ponderado e a quantidade de ações
    if current_amount == 0 do
      # Primeira compra
      %{state | average_cost: unit_cost, shares: amount}
    else
      # Calcula o novo preço médio ponderado
      total_cost = current_cost * current_amount + unit_cost * amount
      total_shares = current_amount + amount
      new_average_cost = total_cost / total_shares

      %{state | average_cost: new_average_cost, shares: total_shares}
    end
  end

  # Processa uma operação de venda
  defp process_sell(operation, state) do
    amount = operation["amount"]
    unit_cost = operation["unitCost"]

    # Calcula o valor total da operação
    total_sale_value = amount * unit_cost

    # Calcula o custo da operação baseado no preço médio
    cost_basis = amount * state.average_cost

    # Calcula o resultado da operação (lucro ou prejuízo)
    profit_or_loss = total_sale_value - cost_basis

    # Atualiza a quantidade de ações
    new_shares = state.shares - amount

    # Aplica as regras de tributação
    {new_accumulated_loss, new_tax} = calculate_tax_for_sale(
      profit_or_loss,
      total_sale_value,
      state.accumulated_loss,
      state.total_tax
    )

    # Atualiza o estado
    %{
      state |
      shares: new_shares,
      accumulated_loss: new_accumulated_loss,
      total_tax: new_tax
    }
  end

  # Calcula o imposto para uma operação de venda
  defp calculate_tax_for_sale(profit_or_loss, total_sale_value, accumulated_loss, total_tax) do
    # Isenção para vendas menores ou iguais a R$20.000
    if total_sale_value <= 20_000 do
      # Apenas atualiza o prejuízo acumulado se necessário
      if profit_or_loss < 0 do
        {accumulated_loss + abs(profit_or_loss), total_tax}
      else
        {accumulated_loss, total_tax}
      end
    else
      # Operações de venda acima de R$20.000
      cond do
        # Se já há prejuízo acumulado e essa operação deu lucro
        accumulated_loss > 0 and profit_or_loss > 0 ->
          # Compensa o prejuízo acumulado contra o lucro atual
          if profit_or_loss <= accumulated_loss do
            # Prejuízo absorve todo o lucro
            {accumulated_loss - profit_or_loss, total_tax}
          else
            # Lucro excede o prejuízo - calcula o imposto sobre o excedente
            taxable_profit = profit_or_loss - accumulated_loss
            new_tax = taxable_profit * 0.15
            {0, total_tax + new_tax}
          end

        # Se a operação teve prejuízo
        profit_or_loss < 0 ->
          # Acumula o prejuízo para compensação futura
          {accumulated_loss + abs(profit_or_loss), total_tax}

        # Caso contrário, a operação deu lucro e não há prejuízo acumulado
        profit_or_loss > 0 ->
          new_tax = profit_or_loss * 0.15
          {accumulated_loss, total_tax + new_tax}

        # Caso especial: profit_or_loss == 0
        true ->
          {accumulated_loss, total_tax}
      end
    end
  end

  @doc """
  Hello world.

  ## Examples

      iex> TaxCalculator.hello()
      :world

  """
  def hello do
    :world
  end
end
