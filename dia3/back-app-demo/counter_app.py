# counter_app.py (Contador de Acessos e Registros)

from flask import Flask, jsonify
import psycopg2 # Exige a instalação de uma biblioteca para PostgreSQL
import os

app = Flask(__name__)

# Configurações do DB lidas do values.yaml (via variáveis de ambiente)
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("POSTGRES_DB", "mydb")
DB_USER = os.getenv("POSTGRES_USER", "myuser")
DB_PASS = os.getenv("POSTGRES_PASSWORD", "mypassword")

def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        return conn
    except Exception as e:
        print(f"Database connection error: {e}")
        return None

# --- Sondas de Saúde (CRITICAL!) ---
@app.route('/healthz')
def liveness_probe():
    # 1. Checa a conexão com o DB
    conn = get_db_connection()
    if conn is None:
        return jsonify({"status": "error", "reason": "DB not reachable"}), 500
    
    conn.close()
    return jsonify({"status": "running"}), 200

# O Readiness é o mesmo do Liveness aqui, pois a única dependência é o DB.
@app.route('/ready')
def readiness_probe():
    return liveness_probe()

# --- Lógica de Negócio ---
@app.route('/increment', methods=['POST'])
def increment_counter():
    conn = get_db_connection()
    if conn is None:
        return "Erro: Banco de Dados indisponível.", 503

    # Lógica de incremento do contador no DB
    try:
        cursor = conn.cursor()
        cursor.execute("CREATE TABLE IF NOT EXISTS accesses (id SERIAL PRIMARY KEY, timestamp TIMESTAMP DEFAULT NOW());")
        cursor.execute("INSERT INTO accesses DEFAULT VALUES;")
        conn.commit()
        cursor.close()
        conn.close()
        return "Contador incrementado.", 200
    except Exception as e:
        conn.rollback()
        conn.close()
        return f"Erro ao registrar: {e}", 500

if __name__ == '__main__':
    # A porta 8081 deve corresponder à porta no deployment.yaml
    app.run(host='0.0.0.0', port=8081)