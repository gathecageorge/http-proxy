#!/bin/bash
set -e

# Fail if environment variables are missing
if [ -z "$SQUID_USERNAME" ] || [ -z "$SQUID_PASSWORD" ]; then
    echo "ERROR: SQUID_USERNAME and SQUID_PASSWORD must be set"
    exit 1
fi

# Create the password file using htpasswd
htpasswd -b -c /etc/squid/passwd "$SQUID_USERNAME" "$SQUID_PASSWORD"

# Copy template to actual squid.conf
cp /etc/squid/squid.conf.template /etc/squid/squid.conf

# Ensure permissions (just in case)
chmod 666 /dev/stdout /dev/stderr

# Start Squid in foreground
exec squid -N -f /etc/squid/squid.conf
