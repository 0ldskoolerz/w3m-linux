# W3M Linux

Distro Linux minimalista estilo **Windows 3.x** construida con
**Buildroot** + **BusyBox**, con el escritorio
**[W3M](https://github.com/0ldskoolerz/W3M)** (WM X11) y
**[w3m-apps](https://github.com/0ldskoolerz/w3m-apps)**.

ISO objetivo: **~60 MB**. Filosofía: BusyBox userland + X11 mínimo +
nuestro escritorio, nada más.

## Herramientas del sistema (decisión de diseño)

| Categoría | Herramienta | Por qué |
|---|---|---|
| Init | BusyBox init + inittab | arranque directo, sin systemd |
| Userland | BusyBox completo | sh, coreutils, red (udhcpc), mdev (dispositivos) |
| Filesystems | e2fsprogs, dosfstools, util-linux (fdisk/blkid) | formatear/preparar discos |
| Gráficos | xserver_xorg-server + drivers fbdev/vesa/evdev/kbd | X mínimo, sin GLX pesado |
| Escritorio | w3m (WM) + w3m-apps (fm/term/task/calc/notepad) | nuestro stack |
| Audio | alsa-utils (amixer) | `audio.lua` con backend ALSA (sin pactl) |
| Red | busybox udhcpc + wpa_supplicant + iw | wifi real sin NetworkManager |
| Bluetooth | bluez (btmgmt) | para `bluetooth.lua` |
| Boot | syslinux (BIOS) | ISO/USB booteable |
| Remoto | dropbear (SSH) | debugging de la distro |
| Reloj | busybox hwclock / ntpd | hora del sistema |

**Excluido deliberadamente**: systemd, NetworkManager, PipeWire/PulseAudio,
udisks2, Python, Perl, compiladores en runtime.

## Estructura del repo (external tree de Buildroot)

```
configs/
  w3m_linux_defconfig     configuración Buildroot completa
package/
  w3m/                    paquete: WM (github.com/0ldskoolerz/W3M)
  w3m-apps/               paquete: apps (github.com/0ldskoolerz/w3m-apps)
board/w3m/
  rootfs-overlay/
    etc/inittab           auto-login en tty1 -> startw3m
    etc/init.d/S60w3m     script de sesión
    root/.w3mrc           config del escritorio copiada al arranque
scripts/
  build.sh                wrapper de make buildroot
  make-iso.sh             empaqueta la ISO con syslinux
```

## Compilar la distro (requiere Linux con internet)

```sh
sudo pacman -S buildroot --  # o: git clone buildroot y export BR2_EXTERNAL
git clone https://github.com/0ldskoolerz/w3m-linux.git
cd w3m-linux
./scripts/build.sh          # -> output/images/rootfs.iso + bzImage
```

El script hace:
1. descarga/compila Buildroot con `BR2_EXTERNAL=$PWD`
2. toolchain + kernel + busybox + X + w3m + w3m-apps
3. ISO booteable con syslinux

## Probar

```sh
# QEMU (BIOS):
qemu-system-x86_64 -cdrom output/images/w3m.iso -m 512 -vga std
# con red y audio:
qemu-system-x86_64 -cdrom w3m.iso -m 512 -netdev user,id=n0 \
  -device e1000,netdev=n0 -audiodev pa,id=snd
# USB: dd if=rootfs.iso of=/dev/sdX
```

Dentro del sistema: auto-login como root → `startw3m` → escritorio W3M.

## Licencias

Buildroot (GPLv2+), BusyBox (GPLv2), W3M/w3m-apps (MIT).
