import os
import requests
import socket
from flask import Flask

app = Flask(__name__)

# Configuration du proxy SOCKS5 fourni par Tailscale (local)
PROXY_PORT = 1055
PROXIES = {
    'http': f'socks5h://127.0.0.1:{PROXY_PORT}',
    'https': f'socks5h://127.0.0.1:{PROXY_PORT}'
}

@app.route('/')
def hello():
    status = "Non connecté"
    remote_data = "Aucune donnée"
    
    # Test : Essayer d'atteindre une IP ou un nom de machine sur votre Tailnet
    # Remplacez l'IP ci-dessous par l'IP d'une machine de votre réseau Tailscale (ex: 100.x.y.z)
    TARGET_IP = "100.125.159.32" 
    
    try:
        # On fait une requête via le proxy
        response = requests.get(f"http://{TARGET_IP}", proxies=PROXIES, timeout=3)
        status = "✅ SUCCÈS : Connecté au réseau Tailscale"
        remote_data = f"Code retour: {response.status_code}"
    except Exception as e:
        status = f"❌ ERREUR : {str(e)}"

    return f"""
    <h1>Test Render + Tailscale</h1>
    <p>Statut du tunnel : {status}</p>
    <p>Détails : {remote_data}</p>
    """

if __name__ == "__main__":
    # Render attend que l'app écoute sur le port 10000 par défaut (ou $PORT)
    port = int(os.environ.get("PORT", 10000))
    app.run(host='0.0.0.0', port=port)