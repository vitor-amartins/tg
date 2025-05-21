# Docker para Calculadora de Imposto de Renda - Implementação em Elixir

Este documento contém instruções para construir e executar a calculadora de imposto de renda usando Docker.

## Estrutura do Docker

A configuração Docker utiliza um build multi-estágio para criar uma imagem otimizada:

1. **Estágio de Build**: Usa `hexpm/elixir:1.18.0-erlang-26.0.2-alpine-3.19.1` para compilar o aplicativo Elixir
2. **Estágio Final**: Usa `alpine:3.19.1` como base mínima contendo apenas o executável e suas dependências de runtime

Este processo resulta em uma imagem Docker significativamente menor, contendo apenas o necessário para executar a aplicação.

## Como construir e executar

### Usando Docker diretamente

Construir a imagem:
```bash
docker build -t tax_calculator_elixir .
```

Executar a aplicação com um arquivo de entrada:
```bash
cat example.json | docker run -i tax_calculator_elixir
```

### Usando Docker Compose

Construir e executar:
```bash
docker-compose build
```

Executar com arquivo de entrada:
```bash
cat example.json | docker-compose run --rm tax_calculator
```

## Otimizações da Imagem

A imagem Docker é otimizada das seguintes formas:

1. **Multi-estágio**: Separa o ambiente de build do ambiente de runtime
2. **Alpine Linux**: Base extremamente leve
3. **Dependências mínimas**: Apenas o essencial para executar o aplicativo
4. **Arquivos desnecessários**: Excluídos via .dockerignore

O resultado é uma imagem Docker compacta e eficiente para executar a calculadora de imposto. 