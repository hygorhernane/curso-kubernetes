# Base linux a ser usada 
# alpine, ubuntu, debian, rhel, ubi ...
FROM alpine

# anotação e metadados
LABEL engenheiro="hygorhernane@gmail.com"

# comandos a serem configurados
RUN apk add --update nodejs npm curl

# Copiar arquivos para dentro do ambiente do container do build
COPY . /src

# mover-se internamete para ambiente do build
WORKDIR /src

# Instale o codigo node
RUN  npm install

# abra e maque a porta 8080 nos metadados
EXPOSE 8080

# sete o ponto de entrada, o comando base a ser executado com o container 
ENTRYPOINT ["node", "./app.js"]
