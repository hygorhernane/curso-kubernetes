# Dia 1: Introdução ao Docker e Contêineres

Esta pasta contém os arquivos do primeiro dia de treinamento, focados nos conceitos básicos de Docker.

## Conteúdo

*   `app.js`: Uma aplicação web simples em Node.js.
*   `Dockerfile`: As instruções para construir a imagem Docker da aplicação `app.js`.
*   `docker-compose.yml`: Um arquivo para orquestrar a aplicação e um banco de dados PostgreSQL com Docker Compose.
*   `package.json`: As dependências da aplicação Node.js.
*   `views/`: A view da aplicação web, usando o template engine Pug.

O objetivo é demonstrar como criar uma imagem Docker, executá-la e orquestrar múltiplos contêineres localmente.