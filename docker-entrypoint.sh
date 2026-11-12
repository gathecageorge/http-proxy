#!/bin/sh
set -eu

if [ -z "${SQUID_USERNAME:-}" ] || [ -z "${SQUID_PASSWORD:-}" ]; then
    printf '%s\n' "ERROR: SQUID_USERNAME and SQUID_PASSWORD must be set" >&2
    exit 1
fi

case "$SQUID_USERNAME" in
    *[!A-Za-z0-9._-]*)
        printf '%s\n' "ERROR: SQUID_USERNAME may only contain letters, numbers, '.', '_' and '-'" >&2
        exit 1
        ;;
esac

case "$SQUID_PASSWORD" in
    *'
'*)
        printf '%s\n' "ERROR: SQUID_PASSWORD must not contain a newline" >&2
        exit 1
        ;;
esac

password_bytes=$(printf '%s' "$SQUID_PASSWORD" | wc -c)
if [ "$password_bytes" -gt 72 ]; then
    printf '%s\n' "ERROR: SQUID_PASSWORD must be at most 72 bytes for bcrypt" >&2
    exit 1
fi

umask 077
printf '%s\n' "$SQUID_PASSWORD" | htpasswd -B -C 12 -i -c /tmp/squid.passwd "$SQUID_USERNAME"
unset SQUID_USERNAME SQUID_PASSWORD

rm -f /tmp/squid.pid
exec squid -N -f /etc/squid/squid.conf
