# syntax=docker/dockerfile:1.7
FROM node:22-bookworm-slim AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci --ignore-scripts

COPY . .
RUN npm run build

FROM node:22-bookworm-slim AS runtime
ENV NODE_ENV=production \
    PORT=3000
WORKDIR /app

RUN groupadd --system app && useradd --system --gid app --home-dir /nonexistent --shell /usr/sbin/nologin app

COPY package*.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force
COPY --from=build --chown=app:app /app/dist ./dist

USER app
EXPOSE 3000
CMD ["node", "dist/server.js"]
