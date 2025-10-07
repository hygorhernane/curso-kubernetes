# app.py
import time
import os
from datetime import datetime
from flask import Flask, jsonify

app = Flask(__name__)

# Variável para rastrear o estado de prontidão após a simulação
INITIALIZATION_COMPLETE = False
START_TIME = datetime.now()

# --- Simulação de Inicialização Lenta ---

def initialize_app():
    global INITIALIZATION_COMPLETE
    
    # Mensagem ANTES do timer
    print(f"[{datetime.now().strftime('%H:%M:%S')}] ESTOU INICIANDO: Simulação de carga de trabalho crítica (15 segundos).")
    
    # Atraso de 15 segundos
    time.sleep(15) 
    
    # Mensagem DEPOIS do timer
    print(f"[{datetime.now().strftime('%H:%M:%S')}] INICIEI E ESTOU PRONTO: O código de inicialização de 15 segundos foi concluído.")
    
    INITIALIZATION_COMPLETE = True

# Executa a função de inicialização em uma thread separada ou fora do loop principal
# Para fins de simulação simples e bloqueio de tempo, rodamos no escopo principal.
initialize_app() 

# ----------------------------------------

@app.route('/')
def home():
    if not INITIALIZATION_COMPLETE:
        # Teoricamente, o tráfego não deveria chegar aqui devido ao Readiness Probe,
        # mas é bom ter uma fallback.
        return "Aplicação ainda em processo de inicialização...", 503
    return "Olá! A aplicação está funcionando e pronta para servir o tráfego.", 200

# Endpoint de Saúde/Prontidão
@app.route('/healthz')
def healthz():
    if INITIALIZATION_COMPLETE:
        # Retorna 200 (OK) somente APÓS a inicialização de 15s
        return jsonify({"status": "ready", "uptime": str(datetime.now() - START_TIME)}), 200
    else:
        # Retorna 503 (Serviço Indisponível) se o timer ainda não terminou
        # O Readiness Probe falhará enquanto este status for retornado.
        return jsonify({"status": "not_ready", "reason": "Aguardando inicialização"}), 503

if __name__ == '__main__':
    # Roda na porta 8080
    app.run(host='0.0.0.0', port=8080)
