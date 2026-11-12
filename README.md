# About the docker image
Runs an authenticated HTTP/HTTPS forward proxy using Squid. The image runs as
the unprivileged `proxy` user and only permits HTTP (port 80) and HTTPS
(CONNECT port 443). Requests to private, loopback, link-local, and selected
reserved destination ranges are denied.

# How to run
Set credentials in the environment and start the Compose service:

```sh
export SQUID_USERNAME='proxy-user'
export SQUID_PASSWORD='use-a-unique-strong-password'
docker compose up -d
```

The username may contain letters, numbers, `.`, `_`, and `-`; the password
must be a single line and at most 72 bytes.

The sample Compose configuration requires both variables, runs with a
read-only root filesystem, drops Linux capabilities, and exposes the proxy on
port 3128. It also sends an unauthenticated proxy request; the expected
`407 Proxy Authentication Required` response marks the service healthy. Adjust
the healthcheck timing in Compose if needed. Do not expose this port to
untrusted networks without suitable firewall controls.

The GitHub Actions workflow publishes `latest` and a short commit-SHA tag when
the image inputs change on `main`. It also rebuilds weekly without the build
cache and publishes a UTC date tag so base-image and package updates are
included.