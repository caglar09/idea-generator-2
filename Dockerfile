FROM node:25-slim

# git: required by server/project.ts writeProject() for `git init`
# ca-certificates: required for HTTPS calls to cloud LLM providers
RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Optimize layer caching: install production dependencies first
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Copy application source (no build step; Node 25 runs TS directly)
COPY server ./server
COPY public ./public

# Prepare persistence and export mount points
RUN mkdir -p /app/data /projects \
    && chown -R node:node /app /projects

ENV NODE_ENV=production \
    HOST=0.0.0.0 \
    PORT=8300 \
    DB_FILE=/app/data/ideas.db \
    DEFAULT_PROJECTS_ROOT=/projects

EXPOSE 8300

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD ["node", "-e", "fetch('http://127.0.0.1:' + (process.env.PORT || 8300) + '/api/providers').then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))"]

USER node

# Exec form so Node runs as PID 1 and receives SIGTERM directly
CMD ["node", "server/index.ts"]
