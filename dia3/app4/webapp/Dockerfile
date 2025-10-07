# Dockerfile para a WebApp
FROM python:3.9-slim
WORKDIR /app

# 1. Instala as dependências como root
RUN pip install Flask

# 2. Copia a aplicação
COPY app.py .

# 3. Cria um usuário e grupo não-root
RUN groupadd -r --gid 1001 appgroup && \
    useradd -r --uid 1001 --gid appgroup appuser

# 4. Muda o dono do diretório de trabalho
RUN chown -R appuser:appgroup /app

# 5. Muda para o usuário não-root
USER appuser

EXPOSE 8080
CMD ["flask", "run", "--host=0.0.0.0", "--port=8080"]
