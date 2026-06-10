FROM python:3.11-slim

# Install Chrome, Xvfb, and deps
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    xvfb \
    xauth \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libwayland-client0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    libxshmfence1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome stable
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY solver.py .
COPY service.py .
COPY keep_alive.py .

# Render sets PORT env var; default to 8191 for local runs
ENV PORT=8191
ENV MAX_WORKERS=1
ENV PYTHONUNBUFFERED=1

# Start Xvfb in background, then run the service
CMD Xvfb :99 -screen 0 1280x900x24 & \
    export DISPLAY=:99 && \
    python service.py
