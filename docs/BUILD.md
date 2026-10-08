# W3M Linux — Guía de construcción

## Requisitos del host (donde compilas)

- Linux x86_64 con: `gcc make git cpio python3 rsync wget unzip`
- ~10 GB de disco libre
- Conexión a internet (Buildroot descarga fuentes)

En Arch/CachyOS:

```sh
sudo pacman -S base-devel rsync cpio python unzip wget
```

**Nota sobre git**: los paquetes w3m/w3m-apps/w3m-net se descargan como
**tarballs de tag** de GitHub durante la build (mecanismo `$(call github,...)`
de Buildroot) — no necesitas git ni en el host ni en la distro. Si
prefieres clonar con submodules o usar ramas, entonces sí instala git
en el host: `sudo pacman -S git`.

## Construir

```sh
# 1. Buildroot (versión estable)
git clone --depth 1 --branch 2024.02 https://gitlab.com/buildroot/buildroot.git

# 2. W3M Linux (external tree)
git clone https://github.com/0ldskoolerz/w3m-linux.git

# 3. Lanzar
cd w3m-linux
./scripts/build.sh ../buildroot
# primera construcción: 30–90 min (toolchain + kernel + todo)
```

Salida: `../buildroot/output/images/rootfs.iso`

## Probar en QEMU

```sh
./scripts/run-qemu.sh ../buildroot/output/images/rootfs.iso
```

Boot → auto-login root → escritorio W3M con las apps.

## Notas de integración

- **Audio**: la distro incluye `audio-alsa.lua` (amixer) en
  `/usr/share/w3m/plugins/`; `startw3m` copia todos los plugins a
  `~/.w3m/plugins/`. El `audio.lua` original (pactl) degrada a "sin
  audio" — desactívalo en `plugins =` del w3m.conf si no usas PulseAudio.
- **Red**: `wpa_supplicant` + `iw` instalados; `red.lua` (nmcli) no
  funciona sin NetworkManager — wifi se configura con `wpa_cli` o el
  applet `wpa_action` (pendiente de plugin específico).
- **Kernel config**: `board/w3m/linux-w3m.config` es una base; es
  probable que necesites `make linux-menuconfig` para tu hardware
  específico (GPU concreta, wifi concreta).
- **Red al arranque**: `/etc/init.d/S40net` (overlay) levanta eth0 y
  wlan0 automaticamente: DHCP con 3 reintentos via udhcpc; wifi via
  wpa_supplicant si editaste `/etc/wpa_supplicant.conf`. Sin cable y
  sin wifi configurada, el arranque sigue (no se bloquea).
- **Dependencias cubiertas en el defconfig**:
  - w3m (WM): lua (plugins), xlib-libX11
  - w3m-apps: busybox (ls/cp/mv/tar/awk/ps...), file, xlib-libX11
  - w3m-net: net-tools (ifconfig/route/arp/netstat/mii-tool),
    traceroute, nmap, tcpdump, wpa_supplicant, iw
- **Versión de Buildroot**: probado con receta 2024.02; los .mk usan
  solo APIs estables de paquetes (generic-package).

## Estructura de la primera imagen

```
~60 MB ISO:
  kernel 6.6 (~8 MB)
  rootfs musl + busybox (~4 MB)
  Xorg + drivers (~10 MB)
  w3m + w3m-apps (~150 KB)
  alsa-utils, wpa_supplicant, dropbear, e2fsprogs... (~15 MB)
  espacio en ISO para boot (syslinux)
```
