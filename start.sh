#!/bin/sh

echo "🚀 Démarrage du mode Exit Node..."

# 1. Démarrer le démon Tailscale
# Note : On garde le mode userspace car Render bloque l'accès au kernel.
# On garde le socket dans /tmp pour éviter les erreurs de permission.
/app/tailscaled --tun=userspace-networking --socket=/tmp/tailscaled.sock &

# 2. Attendre que le démon démarre
echo "⏳ Attente du démon Tailscale..."
sleep 5

# 3. Connecter la machine et l'annoncer comme Exit Node
# --advertise-exit-node : C'est le flag magique
# --hostname : Donnez-lui un nom clair pour le retrouver dans la console
echo "🔑 Authentification et déclaration Exit Node..."
/app/tailscale --socket=/tmp/tailscaled.sock up \
  --authkey=${TAILSCALE_AUTH_KEY} \
  --hostname=render-exit-node \
  --advertise-exit-node

echo "✅ Tailscale connecté. Le service est prêt à relayer (si Render le permet)."

# 4. Lancer l'application dummy pour empêcher le conteneur de s'éteindre
exec "$@"