import json
import random
import argparse
import os

def gerar_transacoes(n):
    transacoes = []
    acoes_em_carteira = 0

    for _ in range(n):
        if acoes_em_carteira == 0 or random.random() < 0.5:
            # Gera uma operação de compra
            quantidade = random.randint(10, 1000)
            preco = round(random.uniform(1, 200), 2)
            transacoes.append({
                "type": "buy",
                "unitCost": preco,
                "amount": quantidade
            })
            acoes_em_carteira += quantidade
        else:
            # Gera uma operação de venda
            quantidade = random.randint(1, acoes_em_carteira)
            preco = round(random.uniform(1, 200), 2)
            transacoes.append({
                "type": "sell",
                "unitCost": preco,
                "amount": quantidade
            })
            acoes_em_carteira -= quantidade

    return transacoes

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Gerar transações de ações para cálculo de IR.")
    parser.add_argument("n", type=int, help="Número de transações a serem geradas")

    args = parser.parse_args()
    resultado = gerar_transacoes(args.n)

    os.makedirs("inputs", exist_ok=True)
    caminho_arquivo = f"inputs/transacoes_{args.n}.json"
    with open(caminho_arquivo, "w") as f:
        json.dump(resultado, f)

    print(f"Arquivo salvo em: {caminho_arquivo}")
