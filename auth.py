from mitmproxy import http
import os
import base64

USERNAME = os.environ.get("AUTH_USERNAME", "")
PASSWORD = os.environ.get("AUTH_PASSWORD", "")

def request(flow: http.HTTPFlow) -> None:
    auth = flow.request.headers.get("Proxy-Authorization")
    if not auth:
        flow.response = http.Response.make(
            407,
            b"Proxy Authentication Required",
            {"Proxy-Authenticate": "Basic"}
        )
        return

    import base64
    method, encoded = auth.split(" ", 1)
    user, pw = base64.b64decode(encoded).decode().split(":", 1)

    if user != USERNAME or pw != PASSWORD:
        flow.response = http.Response.make(
            407,
            b"Invalid credentials",
            {"Proxy-Authenticate": "Basic"}
        )
