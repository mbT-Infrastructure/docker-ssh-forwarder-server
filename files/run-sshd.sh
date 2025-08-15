#!/usr/bin/env bash
set -e -o pipefail

if [[ -n "$AUTHORIZED_PUBLIC_KEYS" ]]; then
    echo "$AUTHORIZED_PUBLIC_KEYS" > /media/ssh/authorized_keys
elif [[ -s /media/ssh/authorized_keys ]]; then
    echo "Using existing authorized public keys from /media/ssh/authorized_keys." >&2
else
    echo "No authorized public keys specified." >&2
    exit 15
fi
echo "Authorized public keys:" >&2
cat /media/ssh/authorized_keys >&2

if [[ -n "$HOST_KEY" ]]; then
    echo "$HOST_KEY" > /media/ssh/host_key
    chmod 0600 /media/ssh/host_key
elif [[ -f /media/ssh/host_key ]]; then
    echo "Using existing host key from /media/ssh/host_key." >&2
else
    cd /dev/shm
    echo "Host key not specified and no existing host key found. Create one." >&2
    public-key-infrastructure.sh --create ssh-key
    rm ssh-key.pub
    mv ssh-key /media/ssh/host_key
fi

if [[ -z "$PERMIT_LISTEN" ]]; then
    PERMIT_LISTEN="none"
fi
if [[ -z "$PERMIT_OPEN" ]]; then
    PERMIT_OPEN="none"
fi

replace-vars.sh /opt/ssh-forwarder-server/sshd_config-template \
    > /dev/shm/sshd_config

/usr/sbin/sshd -f /dev/shm/sshd_config -D -e 2>&1 \
    | sed '/^Connection closed by 127.0.0.1 port [0-9]+$/d' \
    >&2
