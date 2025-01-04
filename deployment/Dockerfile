FROM oven/bun:1.1-alpine AS base
WORKDIR /application

FROM base AS deps
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

FROM base AS builder
COPY . .
COPY --from=deps /application/node_modules ./node_modules
ENV NODE_ENV=production
RUN bun run build

FROM base AS runner
ENV NODE_ENV=production
COPY --from=builder /application/public ./public

COPY --from=builder /application/.next/standalone ./
COPY --from=builder /application/.next/static ./.next/static

USER bun
EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"
CMD ["bun", "run", "server.js"]
