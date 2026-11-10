#!/bin/bash
# Maps Railway onto AnythingLLM, then hands over to the upstream entrypoint.
set -e

STORAGE_DIR="${STORAGE_DIR:-/app/server/storage}"
ENV_FILE="$STORAGE_DIR/.env"
mkdir -p "$STORAGE_DIR"

# AnythingLLM saves what you set in the UI (LLM provider, keys, the instance
# password) to /app/server/.env. That file is inside the image, so a redeploy
# would reset it. Keep it on the volume and link it into place.
if [ ! -s "$ENV_FILE" ]; then
  rand() { head -c 48 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c "$1"; }
  {
    echo "SERVER_PORT=$SERVER_PORT"
    echo "STORAGE_DIR='$STORAGE_DIR'"
    # SIG_KEY and SIG_SALT encrypt stored credentials; JWT_SECRET signs sessions.
    # Generated once, so they stay the same for the life of the volume.
    echo "SIG_KEY='$(rand 40)'"
    echo "SIG_SALT='$(rand 40)'"
    echo "JWT_SECRET='$(rand 40)'"
    # The first password comes from the template's ADMIN_PASSWORD. It is written
    # here once rather than passed as AUTH_TOKEN, because a variable would win
    # over the file on every boot and undo a password change made in the UI.
    if [ -n "${ADMIN_PASSWORD:-}" ]; then
      echo "AUTH_TOKEN='$ADMIN_PASSWORD'"
    else
      echo "[railway] ADMIN_PASSWORD is empty: this instance is open to anyone with the URL until you set a password in Settings > Security" >&2
    fi
  } > "$ENV_FILE"
  chmod 600 "$ENV_FILE"
  echo "[railway] first boot: wrote $ENV_FILE"
fi
ln -sfn "$ENV_FILE" /app/server/.env

chown -R anythingllm:anythingllm "$STORAGE_DIR"
chown -h anythingllm:anythingllm /app/server/.env

exec setpriv --reuid=anythingllm --regid=anythingllm --init-groups \
  env HOME=/app /bin/bash /usr/local/bin/docker-entrypoint.sh
