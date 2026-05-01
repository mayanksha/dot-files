#!/bin/sh
set -e

mkdir -p /root/.ssh
chmod 700 /root/.ssh

if [ ! -f /root/.ssh/config ]; then
    cp /etc/skel/.ssh/config /root/.ssh/config
    chmod 600 /root/.ssh/config
    echo "[ts-warp-entrypoint] Installed default ~/.ssh/config"
fi

if [ ! -f /root/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 \
        -C "warp-coexist-$(hostname)" \
        -f /root/.ssh/id_ed25519 \
        -N "" \
        >/dev/null
    echo "[ts-warp-entrypoint] Generated SSH keypair. Public key:"
    cat /root/.ssh/id_ed25519.pub
fi

exec /usr/local/bin/containerboot "$@"
