import os
import requests
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    # On récupère l'IP publique via un service externe
    try:
        public_ip = requests.get('https://ifconfig.me').text.strip()
    except:
        public_ip = "IP indisponible"

    # On retourne le message avec l'IP
    # Le <br> permet le saut de ligne en HTML
    return f"Je suis un Exit Node Tailscale sur Render. Je tourne en fond.<br>Voici mon ip publique : {public_ip}"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))
    app.run(host='0.0.0.0', port=port)