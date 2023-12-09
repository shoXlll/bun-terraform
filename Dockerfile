FROM oven/bun:1.0-alpine

WORKDIR /application

COPY package.json bun.lockb ./

RUN bun install
