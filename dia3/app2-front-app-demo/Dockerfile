# Dockerfile.web
FROM python:3.9-slim

WORKDIR /app

# 1. Instala as dependências como root
RUN pip install flask requests

# 2. Copia a aplicação
COPY web_app.py .

# 3. Cria um usuário e grupo não-root
RUN groupadd -r --gid 1001 appgroup && \
    useradd -r --uid 1001 --gid appgroup appuser

# 4. Muda o dono do diretório de trabalho
RUN chown -R appuser:appgroup /app

# 5. Muda para o usuário não-root
USER appuser

EXPOSE 8080

CMD ["python", "web_app.py"]