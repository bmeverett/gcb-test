FROM node:16 as base
ENV NODE_ENV=production

FROM base as deps

WORKDIR /app
ADD package.json package-lock.json ./
RUN npm install --production=false --ignore-scripts

# Setup production node_modules
FROM base as production-deps

WORKDIR /app
COPY --from=deps /app/node_modules /app/node_modules
ADD package.json package-lock.json ./
RUN npm prune --production

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules /app/node_modules
COPY . .
RUN npm run build


FROM node:16-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY --from=production-deps /app/node_modules /app/node_modules

COPY --from=builder /app/dist /app/dist
RUN apk --no-cache add tini

EXPOSE 3000
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/main"]
