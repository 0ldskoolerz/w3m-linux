# auto-arranque del escritorio en el primer login (tty1)
if [ "$(tty)" = "/dev/tty1" ] && [ ! -f /tmp/.w3m-started ]; then
    touch /tmp/.w3m-started
    startw3m
fi
