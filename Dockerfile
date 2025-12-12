FROM python:3.9-slim

# Installation de curl et nettoyage
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# --- INSTALLATION TAILSCALE ---
ENV TS_VERSION=1.50.0
ENV TSFILE=tailscale_${TS_VERSION}_amd64.tgz
RUN curl -fsSL https://pkgs.tailscale.com/stable/${TSFILE} -o tailscale.tgz \
    && tar xzf tailscale.tgz --strip-components=1 \
    && rm tailscale.tgz
# ------------------------------

# Installation des dépendances Python
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copie du code et du script
COPY app.py .
COPY start.sh .

# Rendre le script exécutable
RUN chmod +x start.sh

# Définition du script comme point d'entrée
ENTRYPOINT ["./start.sh"]

# Commande par défaut
CMD ["python", "app.py"]