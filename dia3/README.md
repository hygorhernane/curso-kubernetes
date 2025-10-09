# Dia 3: Aplicações Complexas e Helm

Esta pasta foca na criação e gerenciamento de aplicações mais complexas e distribuídas, com uma introdução ao Helm, o gerenciador de pacotes para Kubernetes.

## Conteúdo

*   **app1-lento, app2-..., etc.:** Diferentes aplicações usadas para demonstrar conceitos como sidecars, health checks e arquiteturas de microsserviços.
*   **app5/:** Uma aplicação de microsserviços mais complexa, com 5 contêineres (frontend, aggregator, processor, etc.) implantados em um único Pod usando Helm.
*   **app5-v2/:** Uma versão refatorada da `app5`, onde cada microsserviço é implantado em seu próprio Pod. Esta versão representa uma arquitetura mais robusta e escalável.
*   ***-helm/:** Vários exemplos de charts do Helm, mostrando como empacotar e distribuir aplicações no Kubernetes.