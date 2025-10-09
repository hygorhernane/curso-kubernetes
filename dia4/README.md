# Dia 4: Pipelines de CI/CD

Esta pasta é dedicada à automação, contendo as configurações para as pipelines de Integração Contínua e Entrega Contínua (CI/CD).

## Conteúdo

*   **pipeline-app5/:** Contém a configuração da pipeline de CI para a aplicação `app5`, usando o Azure Pipelines. Esta pipeline é responsável por:
    1.  Construir as imagens Docker dos microsserviços.
    2.  Enviar as imagens para um registro de contêiner.
    3.  Atualizar os manifestos do Helm com as novas tags das imagens.
    4.  Fazer o commit das alterações de volta para o repositório Git, para que o Argo CD possa fazer a implantação.

O objetivo é demonstrar um fluxo de trabalho GitOps completo.