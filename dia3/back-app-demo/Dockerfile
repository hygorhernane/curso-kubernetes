# Dockerfile.counter
FROM python:3.9-slim

WORKDIR /app

# Instale a aplicação e dependências (Flask, psycopg2, etc.)
COPY counter_app.py .
# Se tiver um requirements.txt...

EXPOSE 8081

CMD ["python", "counter_app.py"]