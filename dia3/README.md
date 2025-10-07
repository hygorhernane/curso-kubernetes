# Resumo dos Aplicativos de Treinamento Kubernetes

Este diretório contém 5 aplicações de exemplo, cada uma projetada para demonstrar um conjunto específico de conceitos do Kubernetes, com complexidade crescente. Todas as aplicações foram preparadas para serem compatíveis tanto com clusters Kubernetes padrão (como o AKS) quanto com clusters OpenShift com políticas de segurança restritas.

---

## App1: Simulação de Liveness/Readiness Probe

*   **Propósito:** Uma aplicação web simples em Python (Flask) que simula um tempo de inicialização lento de 15 segundos.
*   **Tecnologia:** Python.
*   **Conceitos Demonstrados:**
    *   **`readinessProbe`**: Essencial para ensinar por que é crucial esperar uma aplicação estar totalmente pronta antes de enviar tráfego para ela.
    *   **`livenessProbe`**: Pode ser usado para demonstrar como o Kubernetes reinicia um pod que não está respondendo.

---

## App2: Aplicação Multi-Contêiner (Frontend + Backend)

*   **Propósito:** Uma aplicação web em Python que consiste em um contêiner de `frontend` e um de `backend` rodando no mesmo Pod. O frontend se comunica com o backend via `localhost`.
*   **Tecnologia:** Python.
*   **Conceitos Demonstrados:**
    *   **Padrão Multi-Contêiner:** Como e por que agrupar contêineres em um único Pod.
    *   **Comunicação Intra-Pod:** Uso de `localhost` para comunicação entre contêineres.
    *   **Helm:** Gerenciamento de uma implantação com múltiplos contêineres através de um Helm Chart customizado.

---

## App3: Padrão Sidecar com ConfigMap e Secret

*   **Propósito:** Uma aplicação Java onde um contêiner "reader" (web) lê informações que um contêiner "logger" (sidecar) escreve em um volume compartilhado. As informações escritas são injetadas de ConfigMaps e Secrets.
*   **Tecnologia:** Java.
*   **Conceitos Demonstrados:**
    *   **Padrão Sidecar:** Um contêiner estendendo a funcionalidade do contêiner principal.
    *   **`ConfigMap`**: Para injetar dados de configuração não sensíveis.
    *   **`Secret`**: Para injetar dados sensíveis.
    *   **Volume `emptyDir`**: Para compartilhar arquivos entre contêineres dentro do mesmo Pod.

---

## App4: Persistência de Dados e Estratégias de Deploy

*   **Propósito:** Uma aplicação em Python com dois deployments distintos. Um "logger" escreve continuamente em um volume persistente, enquanto uma "webapp" serve para observar as atualizações de deploy.
*   **Tecnologia:** Python.
*   **Conceitos Demonstrados:**
    *   **`PersistentVolumeClaim` (PVC)**: Como garantir que os dados de uma aplicação sobrevivam a reinicializações e atualizações do Pod.
    *   **Estratégias de Deploy**: Demonstração visual da diferença entre `RollingUpdate` (sem indisponibilidade) e `Recreate` (com indisponibilidade).

---

## App5: Microsserviços, Helm e Padrões Avançados

*   **Propósito:** Uma aplicação complexa de "Painel de Análise" com 5 contêineres em Node.js que simula um pipeline de dados em tempo real (geração, processamento, agregação, visualização) e inclui um sidecar de logging (Fluent Bit).
*   **Tecnologia:** Node.js, Fluent Bit.
*   **Conceitos Demonstrados:**
    *   **Arquitetura de Microsserviços:** Simulação de um sistema mais realista com múltiplas responsabilidades.
    *   **Padrões Avançados de Sidecar:** Múltiplos sidecars, cada um com uma função (processamento, agregação, logging).
    *   **Gerenciamento de Complexidade com Helm:** Uso de um Helm Chart bem estruturado para gerenciar uma aplicação complexa.
    *   **Múltiplos Volumes:** Uso simultâneo de `PVC` e `emptyDir` para diferentes propósitos.
    *   **União de Conceitos:** Serve como um projeto final que amarra todos os conceitos aprendidos nos outros 4 apps.
