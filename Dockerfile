FROM mintplexlabs/anythingllm:1.19.0

# Railway mounts the volume owned by root, and the app runs as uid 1000.
# The wrapper fixes ownership as root, then drops to the app's user.
USER root
ENV STORAGE_DIR=/app/server/storage \
    SERVER_PORT=3001
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
ENTRYPOINT ["/bin/bash", "/usr/local/bin/railway-entrypoint.sh"]
