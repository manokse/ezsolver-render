"""
Keep-alive pinger to prevent Render free tier from spinning down.
Pings /health every 14 minutes (Render spins down after 15 min of inactivity).
Runs in a background thread alongside the main service.
"""

import os
import threading
import time
import urllib.request
import urllib.error


def _ping_loop():
    """Ping self /health endpoint every 14 minutes."""
    port = os.environ.get("PORT", "8191")
    # On Render, the internal URL uses localhost
    url = f"http://127.0.0.1:{port}/health"

    # Wait a bit for the service to start before first ping
    time.sleep(30)

    while True:
        try:
            req = urllib.request.Request(url, method="GET")
            with urllib.request.urlopen(req, timeout=10) as resp:
                pass
            print(f"[keep_alive] pinged {url} — ok")
        except Exception as e:
            print(f"[keep_alive] ping failed: {e}")

        # 14 minutes = 840 seconds
        time.sleep(840)


def start_keep_alive():
    """Start the keep-alive pinger in a daemon thread."""
    t = threading.Thread(target=_ping_loop, daemon=True)
    t.start()
    print("[keep_alive] started — pinging /health every 14 min")
