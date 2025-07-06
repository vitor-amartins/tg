#! /bin/bash

hyperfine --warmup 3 --runs 100 \
    'cat generator/inputs/001_transacoes_20.json | docker run --rm --cpus="1.0" --memory="1024m" -i stocktax-go' \
    'cat generator/inputs/002_transacoes_20.json | docker run --rm --cpus="1.0" --memory="1024m" -i stocktax-go' \
    'cat generator/inputs/003_transacoes_1000.json | docker run --rm --cpus="1.0" --memory="1024m" -i stocktax-go' \
    'cat generator/inputs/004_transacoes_1000.json | docker run --rm --cpus="1.0" --memory="1024m" -i stocktax-go' \
    'cat generator/inputs/005_transacoes_10000.json | docker run --rm --cpus="1.0" --memory="1024m" -i stocktax-go' \
    'cat generator/inputs/006_transacoes_10000.json | docker run --rm --cpus="1.0" --memory="1024m" -i stocktax-go'

hyperfine --warmup 1 --runs 3 \
    'cat generator/inputs/007_transacoes_1000000.json | docker run --rm --cpus="1.0" --memory="1024m" -i stocktax-go' \
    'cat generator/inputs/008_transacoes_1000000.json | docker run --rm --cpus="1.0" --memory="1024m" -i stocktax-go'