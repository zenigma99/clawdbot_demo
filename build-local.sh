#!/usr/bin/env bash
# build-local.sh
# Build Moltbot direttamente sul server (no registry)
set -euo pipefail

echo "==> Building Moltbot localmente sul server"

# ==========================================
# CONFIGURAZIONE
# ==========================================

BUILD_DIR="/home/ubuntu/docker-data/stacks/moltbot"
IMAGE_NAME="moltbot:local"

# ==========================================
# VERIFICA DIPENDENZE
# ==========================================

if ! command -v docker >/dev/null 2>&1; then
  echo "❌ Docker non trovato."
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "❌ Git non trovato. Installalo con: sudo apt install git"
  exit 1
fi

# ==========================================
# CLONE REPOSITORY
# ==========================================

echo "==> Clonando repository Moltbot..."

cd "${BUILD_DIR}"

if [ -d "moltbot" ]; then
  echo "Directory moltbot già esistente. Aggiornamento..."
  cd moltbot
  git pull
else
  git clone https://github.com/moltbot/moltbot.git
  cd moltbot
fi

# ==========================================
# BUILD IMMAGINE
# ==========================================

echo "==> Building Docker image..."
echo "    Questo può richiedere 5-10 minuti..."

docker build -t "${IMAGE_NAME}" -f Dockerfile .

echo ""
echo "✅ Build completato!"
echo ""
echo "Immagine creata: ${IMAGE_NAME}"
echo ""
echo "==> Prossimi passi:"
echo "1. Configura il file .env"
echo "2. Avvia con: docker-compose up -d"
echo ""