# Calculadora de Imposto de Renda para Operações de Ações

Aplicação desenvolvida em Elixir para calcular o imposto de renda sobre operações de compra e venda de ações, seguindo as regras da Receita Federal.

## Funcionalidades

- Cálculo do preço médio ponderado das ações em carteira
- Compensação de prejuízos em lucros futuros
- Isenção para vendas abaixo de R$20.000
- Alíquota de 15% sobre o lucro tributável

## Requisitos

- Elixir 1.18 ou superior
- Erlang 27.0 ou superior

## Instalação

```bash
# Clone o repositório
git clone [URL_DO_REPOSITORIO]
cd tax_calculator

# Instale as dependências
mix deps.get

# Compile o projeto
mix compile

# Gere o executável
mix escript.build
```

## Uso

A aplicação recebe um arquivo JSON contendo uma lista de operações de compra e venda de ações e retorna o valor total de imposto devido.

```bash
./tax_calculator [arquivo.json]
```

### Formato do arquivo JSON

O arquivo deve conter uma lista de operações no seguinte formato:

```json
[
  {"type": "buy", "unitCost": 10.00, "amount": 100},
  {"type": "sell", "unitCost": 15.00, "amount": 50}
]
```

Onde:
- `type`: tipo de operação ("buy" para compra, "sell" para venda)
- `unitCost`: custo unitário da ação (número > 0)
- `amount`: quantidade de ações (inteiro > 0)

### Saída

A aplicação retorna um número de ponto flutuante representando o imposto total devido, com precisão de 1 casa decimal.

## Testes

Para executar os testes automatizados:

```bash
mix test
```

## Exemplos

Vários exemplos estão incluídos nos testes. Para ver os exemplos em ação, examine os testes em `test/tax_calculator_test.exs`.

## Desenvolvimento

- Este projeto segue boas práticas de programação funcional em Elixir
- O código é organizado de forma modular e testável
- O fluxo de processamento é implementado usando funções recursivas e pattern matching

## Performance e Design

### Complexidade Algoritmica

- **Tempo**: O(n) onde n é o número de operações, pois cada operação é processada exatamente uma vez.
- **Espaço**: O(1) para o processamento, pois mantemos apenas um estado constante independente do número de operações.

### Decisões de Design

1. **Imutabilidade**: Usamos o paradigma funcional do Elixir para trabalhar com dados imutáveis, facilitando o raciocínio sobre o código.
2. **Estrutura de Dados**: Utilizamos mapas para representar o estado, proporcionando acesso eficiente aos dados.
3. **Funções Puras**: As funções de processamento são puras, sem efeitos colaterais, tornando o código previsível e testável.
4. **Modularidade**: O código está organizado em funções pequenas com responsabilidades específicas.

### Otimizações Potenciais

Para volumes muito grandes de operações, poderíamos considerar:

- Processamento paralelo utilizando o modelo de concorrência do Elixir
- Processamento em lotes para reduzir o uso de memória
- Implementação de cache para cálculos frequentes
