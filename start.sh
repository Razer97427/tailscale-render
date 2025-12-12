#!/bin/sh

echo "🚀 Démarrage..."

# 1. Démarrer le démon Tailscale en mode userspace + SOCKS5
# On utilise /tmp car sur Render seul /tmp et certains dossiers sont inscriptibles parfois, 
# mais surtout pour stocker le socket.
/app/tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --socket=/tmp/tailscaled.sock &

# 2. Attendre que le démon démarre
echo "⏳ Attente du démon Tailscale..."
sleep 5

# 3. Connecter la machine au réseau
# --hostname permet de la reconnaître dans votre admin panel Tailscale
echo "🔑 Authentification..."
/app/tailscale --socket=/tmp/tailscaled.sock up --authkey=${TAILSCALE_AUTH_KEY} --hostname=render-app

echo "✅ Tailscale connecté. Lancement de l'application..."

# 4. Lancer l'application (la commande passée dans le Dockerfile)
exec "$@"