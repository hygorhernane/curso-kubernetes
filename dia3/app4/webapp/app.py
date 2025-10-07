# app.py para a WebApp
from flask import Flask
import os

app = Flask(__name__)

# A versão será injetada via variável de ambiente no Deployment
APP_VERSION = os.getenv("APP_VERSION", "1.0")

@app.route('/')
def home():
    # Exibe a versão do app para demonstrar o Rolling Update
    return f"<h1>Ola! Bem-vindo a WebApp.</h1><p>Versao: {APP_VERSION}</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
