#!/bin/bash

# Script para atualizar uma tag de imagem em um arquivo values.yaml do Helm.
# Requer a ferramenta 'yq' (https://github.com/mikefarah/yq).

set -e

if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <caminho-para-values.yaml> <chave-yaml> <nova-tag>"
    echo "Exemplo: $0 ./values.yaml frontend.image.tag 1.2.3"
    exit 1
fi

VALUES_FILE=$1
YAML_KEY=$2
NEW_TAG=$3

if [ ! -f "$VALUES_FILE" ]; then
    echo "Erro: Arquivo $VALUES_FILE não encontrado." >&2
    exit 1
fi

# Verifica se o yq está instalado
if ! command -v yq &> /dev/null
then
    echo "Erro: yq não está instalado. Por favor, instale-o para continuar." >&2
    exit 1
fi

# Usa o yq para atualizar o arquivo
yq e ".${YAML_KEY} = \"${NEW_TAG}\"" -i "$VALUES_FILE"

echo "Arquivo $VALUES_FILE atualizado com sucesso: ${YAML_KEY} -> ${NEW_TAG}"

