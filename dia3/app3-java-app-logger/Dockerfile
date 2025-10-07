# Dockerfile.logger
FROM openjdk:17-jdk-slim

WORKDIR /app

# 1. Compila o código como root
COPY SidecarLogger.java .
RUN javac SidecarLogger.java

# 2. Cria um usuário e grupo não-root
RUN groupadd -r --gid 1001 appgroup && \
    useradd -r --uid 1001 --gid appgroup appuser

# 3. Muda o dono do diretório de trabalho
RUN chown -R appuser:appgroup /app

# 4. Muda para o usuário não-root
USER appuser

# Define o comando de execução
CMD ["java", "SidecarLogger"]
