# web_app.py (Aplicação Web)

from flask import Flask, jsonify
import requests
import os

app = Flask(__name__)

COUNTER_URL = os.getenv("COUNTER_URL", "http://localhost:8081")

# --- Sondas de Saúde (CRITICAL!) ---
@app.route('/healthz')
def liveness_probe():
    # Verifica se a Web App está rodando
    return jsonify({"status": "running"}), 200

@app.route('/ready')
def readiness_probe():
    # 1. Checa a dependência do Contador
    try:
        response_counter = requests.get(f"{COUNTER_URL}/healthz", timeout=1)
        if response_counter.status_code != 200:
            return jsonify({"status": "error", "reason": "Counter not ready"}), 500
    except requests.exceptions.RequestException:
        return jsonify({"status": "error", "reason": "Counter connection failed"}), 500

    # 2. Checa a dependência do Banco de Dados (exemplo - a lógica real de DB vai no contador)
    # * Para uma verificação mais robusta, você pode tentar abrir uma conexão leve com o DB.
    # Como o DB está no mesmo Pod, basta verificar se a porta responde, mas a app
    # principal que usa o DB é o Counter. A Web App depende do Counter.

    return jsonify({"status": "ready", "dependencies": "ok"}), 200

# --- Lógica de Negócio ---
@app.route('/')
def home():
    try:
        # Chama o contador para registrar um acesso
        requests.post(f"{COUNTER_URL}/increment")
        return "Olá! Acesso registrado com sucesso.", 200
    except requests.exceptions.RequestException:
        return "Erro: Falha na comunicação com o Contador.", 503

if __name__ == '__main__':
    # A porta 8080 deve corresponder à porta no deployment.yaml
    app.run(host='0.0.0.0', port=8080)