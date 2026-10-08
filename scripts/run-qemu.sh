#!/bin/sh
# run-qemu.sh — prueba la ISO de W3M Linux en QEMU
# Uso: ./scripts/run-qemu.sh [ruta-iso]

set -e
cd "$(dirname "$0")/.."
ISO="${1:-../buildroot/output/images/rootfs.iso}"

if [ ! -f "$ISO" ]; then
    echo "ISO no encontrada: $ISO"
    echo "Constrúyela primero: ./scripts/build.sh"
    exit 1
fi

exec qemu-system-x86_64 \
    -cdrom "$ISO" \
    -m 512 \
    -vga std \
    -netdev user,id=n0 -device e1000,netdev=n0 \
    -usb -device usb-tablet
