---
title: EzSolver
emoji: 🧩
colorFrom: blue
colorTo: green
sdk: docker
app_port: 7860
pinned: false
---

# EzSolver - Cloudflare Turnstile Solver

HTTP API service for solving Cloudflare Turnstile challenges using a real Chrome browser.

## API

### POST `/solve`

```json
{
  "sitekey": "0x4AAAAAAAA...",
  "siteurl": "https://example.com",
  "timeout": 45
}
```

Response:
```json
{
  "token": "0.xxx...",
  "elapsed": 4.23
}
```

### GET `/health`

Returns service status:
```json
{
  "status": "ok",
  "workers": 2,
  "active": 0,
  "queued": 0
}
```
