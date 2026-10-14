FROM python:3.12-slim

# ffmpeg requis pour la conversion audio (voir README)
RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Dépendances du frontend Flask et du backend FastAPI
COPY requirements.txt /tmp/requirements-frontend.txt
COPY api-translate-rt/requirements.txt /tmp/requirements-backend.txt
RUN pip install --no-cache-dir -r /tmp/requirements-frontend.txt -r /tmp/requirements-backend.txt \
    && rm -f /tmp/requirements-frontend.txt /tmp/requirements-backend.txt

COPY . .

# Rootless : l'UID est alloué par OpenShift (groupe 0), on groupe root pour la lecture
RUN useradd --create-home --uid 10001 appuser \
    && chown -R 10001:0 /app \
    && chmod -R g+rwX /app

USER 10001

EXPOSE 5000 8080
