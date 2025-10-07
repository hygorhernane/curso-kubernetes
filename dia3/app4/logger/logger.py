
import time
import os
from datetime import datetime

# O diretório /app/logs será montado a partir do PVC
LOG_DIR = "/app/logs"
LOG_FILE = os.path.join(LOG_DIR, "persistent.log")
APP_VERSION = os.getenv("APP_VERSION", "1.0")

print(f"--- Logger App Versao: {APP_VERSION} ---")
print(f"Escrevendo logs em: {LOG_FILE}")

# Garante que o diretório de log exista
os.makedirs(LOG_DIR, exist_ok=True)

# Se o arquivo de log já existe, lê o último número de linha
count = 1
if os.path.exists(LOG_FILE):
    try:
        with open(LOG_FILE, "r") as f:
            lines = f.readlines()
            if lines:
                last_line = lines[-1]
                # Extrai o número do log da última linha (ex: "[...] Log #10")
                count = int(last_line.split("#")[-1].strip()) + 1
                print(f"Arquivo de log encontrado. Continuando a partir do log #{count}.")
    except (ValueError, IndexError):
        print("Nao foi possivel determinar o ultimo numero de log. Comecando do 1.")
        pass # Ignora erros de parsing e começa do 1

while True:
    with open(LOG_FILE, "a") as f:
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        f.write(f"[{timestamp}] [Versao: {APP_VERSION}] Log #{count}\n")
    print(f"Escreveu a entrada de log #{count}")
    count += 1
    time.sleep(10)

