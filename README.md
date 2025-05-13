# Cálculo de Imposto de Renda sobre Ações

## Objetivo

Receber uma lista de operações de compra e venda de ações e retornar o valor total de imposto de renda devido, aplicando as regras da Receita Federal.

## Entrada

A entrada será em formato JSON, contendo uma lista de operações no seguinte esquema:

```json
[
  {"type": "buy", "unitCost": 10.00, "amount": 100},
  {"type": "sell", "unitCost": 20.00, "amount": 50}
]
```

### **Campos:**

- `type`: define o tipo da operação, podendo ser `"buy"` ou `“sell”`
- `unitCost`: custo unitário por ação (float > 0)
- `amount`: quantidade de ações (int > 0)

## Saída

Um único valor float com precisão de até duas casas decimais, representando o imposto total devido. Exemplo:

```json
150.0
```

## Regras de Negócio

### Compras

- Atualizam o preço médio ponderado das ações em carteira.
- Não geram impostos.

### Vendas

- Devem usar o preço médio para calcular o lucro ou prejuízo.
- Caso o valor total da venda seja menor ou igual a R$20.000, a operação é isenta de imposto.
- Apenas vendas com valor total acima de R$20.000 e com lucro são tributadas.

### Imposto

- Diferente do que é praticado pela Receita Federal, não será diferenciado operações de day trade ou swing trade: será considerado uma alíquota única de 15% sobre o lucro.
- Prejuízos anteriores podem ser compensados integralmente em lucros futuros.
- Não há imposto em casos de lucro zerado ou prejuízo.

### Regras adicionais

- As operações devem ser processadas na ordem recebida.
- Assume-se que não haverá vendas de quantidade maior do que a disponível, ou seja, não será necessário validação de consistência nesse aspecto.
- A aplicação não precisa tratar erros de entrada, como valores inválidos ou campos ausentes.
- A aplicação não dependerá de nenhum banco de dados, lidando com todas as operações em memória.
- O valor de saída deverá ser arredondado para a segunda casa decimal, pode-se utilizar a operação básica de arredondamento de cada linguagem.

## Exemplo ilustrativo

### Entrada

```json
[
  {"type": "buy", "unitCost": 10.00, "amount": 1000},
  {"type": "sell", "unitCost": 30.00, "amount": 500},
  {"type": "sell", "unitCost": 50.00, "amount": 420},
  {"type": "sell", "unitCost": 60.00, "amount": 80}
]
```

### Saída

```json
2520.0
```

## Exemplos de entrada e saída esperados

### Caso 1

**Entrada**

```json
[
  {"type": "buy", "unitCost": 10.00, "amount": 100},
  {"type": "sell", "unitCost": 15.00, "amount": 50},
  {"type": "sell", "unitCost": 15.00, "amount": 50}
]
```

**Saída**

```json
0.0
```

### Caso 2

**Entrada**

```json
[
  {"type": "buy", "unitCost": 10.00, "amount": 10000},
  {"type": "sell", "unitCost": 20.00, "amount": 5000},
  {"type": "sell", "unitCost": 5.00, "amount": 5000}
]
```

**Saída**

```json
7500.0
```

### Caso 3

**Entrada**

```json
[
  {"type": "buy", "unitCost": 100.00, "amount": 1000},
  {"type": "sell", "unitCost": 50.00, "amount": 500},
  {"type": "sell", "unitCost": 200.00, "amount": 300}
]
```

**Saída**

```json
750.0
```

### Caso 4

**Entrada**

```json
[
  {"type": "buy", "unitCost": 100.00, "amount": 1000},
  {"type": "buy", "unitCost": 250.00, "amount": 500},
  {"type": "sell", "unitCost": 150.00, "amount": 1000}
]
```

**Saída**

```json
0.0
```

### Caso 5

**Entrada**

```json
[
  {"type": "buy", "unitCost": 100.00, "amount": 1000},
  {"type": "buy", "unitCost": 250.00, "amount": 500},
  {"type": "sell", "unitCost": 150.00, "amount": 1000},
  {"type": "sell", "unitCost": 250.00, "amount": 500}
]
```

**Saída**

```json
7500.0
```

### Caso 6

**Entrada**

```json
[
  {"type": "buy", "unitCost": 100.00, "amount": 1000},
  {"type": "sell", "unitCost": 20.00, "amount": 500},
  {"type": "sell", "unitCost": 200.00, "amount": 200},
  {"type": "sell", "unitCost": 200.00, "amount": 200},
  {"type": "sell", "unitCost": 250.00, "amount": 100}
]
```

**Saída**

```json
2250.0
```

### Caso 7

**Entrada**

```json
[
  {"type": "buy", "unitCost": 100.00, "amount": 1000},
  {"type": "sell", "unitCost": 20.00, "amount": 500},
  {"type": "sell", "unitCost": 200.00, "amount": 200},
  {"type": "sell", "unitCost": 200.00, "amount": 200},
  {"type": "sell", "unitCost": 250.00, "amount": 100},
  {"type": "buy", "unitCost": 200.00, "amount": 1000},
  {"type": "sell", "unitCost": 150.00, "amount": 500},
  {"type": "sell", "unitCost": 300.00, "amount": 435},
  {"type": "sell", "unitCost": 300.00, "amount": 65}
]
```

**Saída**

```json
5025.0
```

### Caso 8

**Entrada**

```json
[
  {"type": "buy", "unitCost": 100.00, "amount": 1000},
  {"type": "sell", "unitCost": 500.00, "amount": 1000},
  {"type": "buy", "unitCost": 200.00, "amount": 1000},
  {"type": "sell", "unitCost": 500.00, "amount": 1000}
]
```

**Saída**

```json
105000.0
```

### Caso 9

**Entrada**

```json
[
  {"type": "buy", "unitCost": 5000.00, "amount": 10},
  {"type": "sell", "unitCost": 4000.00, "amount": 5},
  {"type": "buy", "unitCost": 15000.00, "amount": 5},
  {"type": "buy", "unitCost": 4000.00, "amount": 2},
  {"type": "buy", "unitCost": 23000.00, "amount": 2},
  {"type": "sell", "unitCost": 20000.00, "amount": 1},
  {"type": "sell", "unitCost": 12000.00, "amount": 10},
  {"type": "sell", "unitCost": 15000.00, "amount": 3}
]
```

**Saída**

```json
2550.0
```

### Caso 10

**Entrada**

```json
[
  {"type": "buy", "unitCost": 10.00, "amount": 1000},
  {"type": "sell", "unitCost": 30.00, "amount": 500},
  {"type": "sell", "unitCost": 50.00, "amount": 420},
  {"type": "buy", "unitCost": 20.00, "amount": 420},
  {"type": "sell", "unitCost": 45.00, "amount": 500}
]
```

**Saída**

```json
4515.0
```