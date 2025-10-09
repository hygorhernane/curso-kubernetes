# Pipeline de CI/CD para a Aplicação app5

Esta pasta contém os arquivos de configuração para a pipeline de CI/CD da `app5`.

## Estrutura

*   `azure-pipelines.yml`: Define a pipeline de CI (Continuous Integration) usando o Azure Pipelines.
*   `update-image-tag.sh`: Um script auxiliar para atualizar a tag da imagem no arquivo `values.yaml` do Helm.

## Fluxo da Pipeline

1.  **Gatilho (Trigger):** A pipeline é acionada por um `push` para a branch `main` que inclua alterações nas pastas `dia3/app5/apps/` ou `dia3/app5/dockerfiles/`.
2.  **Build & Push:** A pipeline constrói a imagem Docker para cada microsserviço que foi alterado e a envia para um registro de contêiner.
3.  **Update de Manifestos:** Após o push da imagem, a pipeline atualiza a tag da imagem no arquivo `dia3/app5/helm/app5-chart/values.yaml`.
4.  **Commit:** A alteração no `values.yaml` é commitada e enviada de volta para o repositório Git.
5.  **Deploy (Argo CD):** O Argo CD, configurado no seu cluster OpenShift, detecta a mudança no repositório Git e sincroniza a aplicação, implantando a nova versão.
