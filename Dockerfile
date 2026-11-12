FROM debian:trixie-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y apache2-utils curl squid \
    && rm -rf /var/lib/apt/lists/*

COPY squid.conf.template /etc/squid/squid.conf
COPY --chmod=0555 docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 3128

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl --proxy http://127.0.0.1:3128 --noproxy "" --silent --max-time 3 --output /dev/null --write-out '%{http_code}' http://example.com/ | grep -q '^407$'

USER proxy
ENTRYPOINT ["/docker-entrypoint.sh"]