# Dockerfile.web (Spring Boot)
FROM openjdk:17-jdk-slim

WORKDIR /app

# 1. Cria um usuário e grupo não-root
RUN groupadd -r --gid 1001 appgroup && \
    useradd -r --uid 1001 --gid appgroup appuser

# 2. Copia o JAR da aplicação (assumindo que foi construído previamente)
# O ideal aqui seria um build multi-stage
COPY --chown=appuser:appgroup target/app-reader.jar app.jar

# 3. Muda para o usuário não-root
USER appuser

# Porta do Spring Boot
EXPOSE 8080

# Inicia o Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]
