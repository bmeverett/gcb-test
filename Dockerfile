# syntax=docker/dockerfile:1.4
FROM node:16 as base
ENV NODE_ENV=production

FROM base as deps

WORKDIR /app
COPY --link package.json package-lock.json ./
RUN npm install --production=false --ignore-scripts

# Setup production node_modules
FROM base as production-deps

WORKDIR /app
COPY --link --from=deps /app/node_modules /app/node_modules
COPY --link package.json package-lock.json ./
RUN npm prune --production

FROM base AS builder
WORKDIR /app
COPY --link --from=deps /app/node_modules /app/node_modules
COPY --link . .
RUN npm run build


FROM node:16-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY --link --from=production-deps /app/node_modules /app/node_modules

COPY --link --from=builder /app/dist /app/dist
RUN apk --no-cache add tini

EXPOSE 3000
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/main"]
