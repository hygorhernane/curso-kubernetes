# Dockerfile para o Logger
FROM python:3.9-slim

WORKDIR /app

# 1. Copia a aplicação
COPY logger.py .

# 2. Cria um usuário e grupo não-root
RUN groupadd -r --gid 1001 appgroup && \
    useradd -r --uid 1001 --gid appgroup appuser

# 3. Muda o dono do diretório de trabalho
RUN chown -R appuser:appgroup /app

# 4. Muda para o usuário não-root
USER appuser

# O -u garante que a saída do Python não seja bufferizada, aparecendo imediatamente nos logs do K8s
CMD ["python", "-u", "logger.py"]
