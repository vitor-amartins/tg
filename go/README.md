# Cálculo de Imposto de Renda sobre Ações - Implementação em Go

Esta é uma implementação em Go da aplicação para cálculo de imposto de renda sobre operações de ações, conforme especificado no README principal.

## Estrutura do Projeto

- `main.go`: Ponto de entrada da aplicação, responsável pela leitura da entrada e formatação da saída.
- `tax/tax.go`: Pacote que contém a lógica de cálculo de imposto.
- `tax/tax_test.go`: Testes unitários para o pacote tax, cobrindo todos os casos de exemplo.

## Como executar

### Compilar e executar

```bash
cd go
go build -o tax
cat input.json | ./tax
```

Onde `input.json` é um arquivo contendo a lista de operações no formato especificado.

### Executar diretamente (sem compilar)

```bash
cd go
cat input.json | go run main.go
```

### Executar os testes

```bash
cd go
go test ./... -v
```

## Detalhes da Implementação

A implementação segue uma arquitetura modular com clara separação de responsabilidades:

1. **Entrada/Saída (main.go)**: 
   - Leitura de entrada JSON via stdin
   - Conversão em estruturas de dados
   - Formatação da saída

2. **Lógica de Negócio (tax/tax.go)**:
   - Cálculo do preço médio das ações
   - Processamento de compras e vendas
   - Cálculo do imposto devido considerando:
     - Threshold de R$20.000 para isenção
     - Compensação de prejuízos
     - Alíquota de 15% sobre o lucro

3. **Testes (tax/tax_test.go)**:
   - Implementação de todos os casos de exemplo fornecidos
   - Verificação automática dos resultados esperados

## Pontos Importantes da Implementação

1. **Preço Médio Ponderado**: Atualizado corretamente a cada compra.
2. **Tratamento de Perdas**: As perdas são acumuladas e usadas para compensar lucros futuros.
3. **Threshold de Isenção**: Vendas com valor total ≤ R$20.000 são isentas de imposto.
4. **Compensação de Perdas**: Prejuízos anteriores podem ser usados para reduzir o lucro tributável.
5. **Arredondamento**: O valor final é arredondado para duas casas decimais.

## Desempenho

A implementação é eficiente em termos de processamento e memória:

- **Complexidade de Tempo**: O(n) onde n é o número de operações
- **Complexidade de Espaço**: O(1), usando apenas estruturas de dados fixas
- **Alocação de Memória**: Minimizada através do uso de referências e estruturas simples 