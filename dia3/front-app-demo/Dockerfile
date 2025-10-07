# Dockerfile.web
FROM python:3.9-slim

WORKDIR /app

# Instale a aplicação e dependências (Flask, Requests, etc.)
COPY web_app.py .
# Se tiver um requirements.txt:
# COPY requirements.txt .
# RUN pip install -r requirements.txt

EXPOSE 8080

CMD ["python", "web_app.py"]