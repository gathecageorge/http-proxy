FROM ubuntu

# Install squid and apache2-utils (for htpasswd)
RUN apt-get update && \
    apt-get install -y squid apache2-utils && \
    rm -rf /var/lib/apt/lists/*

# Ensure /dev/stdout and /dev/stderr exist (should already, but ensure proper perms)
RUN ln -sf /proc/self/fd/1 /dev/stdout \
 && ln -sf /proc/self/fd/2 /dev/stderr \
 && chmod 666 /dev/stdout /dev/stderr

# Copy the default squid.conf template
COPY squid.conf.template /etc/squid/squid.conf.template

# Entry point script to create user from env variables
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3128

ENTRYPOINT ["/docker-entrypoint.sh"]