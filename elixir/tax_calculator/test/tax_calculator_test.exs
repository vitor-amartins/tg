defmodule TaxCalculatorTest do
  use ExUnit.Case
  doctest TaxCalculator

  test "Caso 1: Vendas abaixo de R$20.000 (isentas)" do
    operations = [
      %{"type" => "buy", "unitCost" => 10.00, "amount" => 100},
      %{"type" => "sell", "unitCost" => 15.00, "amount" => 50},
      %{"type" => "sell", "unitCost" => 15.00, "amount" => 50}
    ]
    
    assert TaxCalculator.calculate_tax(operations) == 0.0
  end

  test "Caso 2: Compensação de prejuízo em lucro futuro" do
    operations = [
      %{"type" => "buy", "unitCost" => 10.00, "amount" => 10000},
      %{"type" => "sell", "unitCost" => 20.00, "amount" => 5000},
      %{"type" => "sell", "unitCost" => 5.00, "amount" => 5000}
    ]
    
    assert TaxCalculator.calculate_tax(operations) == 7500.0
  end

  test "Caso 3: Venda parcial com prejuízo e lucro" do
    operations = [
      %{"type" => "buy", "unitCost" => 100.00, "amount" => 1000},
      %{"type" => "sell", "unitCost" => 50.00, "amount" => 500},
      %{"type" => "sell", "unitCost" => 200.00, "amount" => 300}
    ]
    
    assert TaxCalculator.calculate_tax(operations) == 750.0
  end

  test "Caso 4: Compra adicional e venda com preço médio (sem imposto)" do
    operations = [
      %{"type" => "buy", "unitCost" => 100.00, "amount" => 1000},
      %{"type" => "buy", "unitCost" => 250.00, "amount" => 500},
      %{"type" => "sell", "unitCost" => 150.00, "amount" => 1000}
    ]
    
    assert TaxCalculator.calculate_tax(operations) == 0.0
  end

  test "Caso 5: Sequência completa com lucro final tributável" do
    operations = [
      %{"type" => "buy", "unitCost" => 100.00, "amount" => 1000},
      %{"type" => "buy", "unitCost" => 250.00, "amount" => 500},
      %{"type" => "sell", "unitCost" => 150.00, "amount" => 1000},
      %{"type" => "sell", "unitCost" => 250.00, "amount" => 500}
    ]
    
    assert TaxCalculator.calculate_tax(operations) == 7500.0
  end

  test "Caso 6: Múltiplas operações com lucros e prejuízos" do
    operations = [
      %{"type" => "buy", "unitCost" => 100.00, "amount" => 1000},
      %{"type" => "sell", "unitCost" => 20.00, "amount" => 500},
      %{"type" => "sell", "unitCost" => 200.00, "amount" => 200},
      %{"type" => "sell", "unitCost" => 200.00, "amount" => 200},
      %{"type" => "sell", "unitCost" => 250.00, "amount" => 100}
    ]
    
    assert TaxCalculator.calculate_tax(operations) == 2250.0
  end

  test "Caso 7: Sequência complexa com múltiplas compras e vendas" do
    operations = [
      %{"type" => "buy", "unitCost" => 100.00, "amount" => 1000},
      %{"type" => "sell", "unitCost" => 20.00, "amount" => 500},
      %{"type" => "sell", "unitCost" => 200.00, "amount" => 200},
      %{"type" => "sell", "unitCost" => 200.00, "amount" => 200},
      %{"type" => "sell", "unitCost" => 250.00, "amount" => 100},
      %{"type" => "buy", "unitCost" => 200.00, "amount" => 1000},
      %{"type" => "sell", "unitCost" => 150.00, "amount" => 500},
      %{"type" => "sell", "unitCost" => 300.00, "amount" => 435},
      %{"type" => "sell", "unitCost" => 300.00, "amount" => 65}
    ]
    
    assert TaxCalculator.calculate_tax(operations) == 5025.0
  end

  test "Caso 8: Operações com lucro elevado" do
    operations = [
      %{"type" => "buy", "unitCost" => 100.00, "amount" => 1000},
      %{"type" => "sell", "unitCost" => 500.00, "amount" => 1000},
      %{"type" => "buy", "unitCost" => 200.00, "amount" => 1000},
      %{"type" => "sell", "unitCost" => 500.00, "amount" => 1000}
    ]
    
    assert TaxCalculator.calculate_tax(operations) == 105000.0
  end

  test "Caso 9: Operações com valores fracionados" do
    operations = [
      %{"type" => "buy", "unitCost" => 5000.00, "amount" => 10},
      %{"type" => "sell", "unitCost" => 4000.00, "amount" => 5},
      %{"type" => "buy", "unitCost" => 15000.00, "amount" => 5},
      %{"type" => "buy", "unitCost" => 4000.00, "amount" => 2},
      %{"type" => "buy", "unitCost" => 23000.00, "amount" => 2},
      %{"type" => "sell", "unitCost" => 20000.00, "amount" => 1},
      %{"type" => "sell", "unitCost" => 12000.00, "amount" => 10},
      %{"type" => "sell", "unitCost" => 15000.00, "amount" => 3}
    ]
    
    assert TaxCalculator.calculate_tax(operations) == 2550.0
  end

  test "Caso 10: Operações mistas com novas compras intermediárias" do
    operations = [
      %{"type" => "buy", "unitCost" => 10.00, "amount" => 1000},
      %{"type" => "sell", "unitCost" => 30.00, "amount" => 500},
      %{"type" => "sell", "unitCost" => 50.00, "amount" => 420},
      %{"type" => "buy", "unitCost" => 20.00, "amount" => 420},
      %{"type" => "sell", "unitCost" => 45.00, "amount" => 500}
    ]
    
    assert TaxCalculator.calculate_tax(operations) == 4515.0
  end

  test "Exemplo ilustrativo do README" do
    operations = [
      %{"type" => "buy", "unitCost" => 10.00, "amount" => 1000},
      %{"type" => "sell", "unitCost" => 30.00, "amount" => 500},
      %{"type" => "sell", "unitCost" => 50.00, "amount" => 420},
      %{"type" => "sell", "unitCost" => 60.00, "amount" => 80}
    ]
    
    assert TaxCalculator.calculate_tax(operations) == 2520.0
  end
end
