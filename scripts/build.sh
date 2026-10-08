#!/bin/sh
# build.sh — construye W3M Linux (Buildroot external tree)
# Requiere: buildroot instalado o en $BR2_DIR, ~10 GB libres, internet.
# Uso: ./scripts/build.sh [ruta-a-buildroot]

set -e
cd "$(dirname "$0")/.."
W3M_TREE="$PWD"

BR2_DIR="${1:-${BR2_DIR:-../buildroot}}"
if [ ! -f "$BR2_DIR/Makefile" ]; then
    echo "Buildroot no encontrado en: $BR2_DIR"
    echo "Obténlo:  git clone https://gitlab.com/buildroot/buildroot.git"
    exit 1
fi

cd "$BR2_DIR"
make BR2_EXTERNAL="$W3M_TREE" w3m_linux_defconfig
make BR2_EXTERNAL="$W3M_TREE" -j"$(nproc)"

echo
echo "== Listo: $BR2_DIR/output/images/"
ls -lh output/images/ || true
