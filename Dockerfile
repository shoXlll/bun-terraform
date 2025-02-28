FROM oven/bun:1.2-alpine

WORKDIR /application

COPY package.json ./

RUN bun install
