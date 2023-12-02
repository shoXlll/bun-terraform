FROM oven/bun:1.0-alpine

WORKDIR /application

COPY application/package.json application/bun.lockb ./

RUN bun install
