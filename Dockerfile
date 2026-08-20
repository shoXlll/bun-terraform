FROM oven/bun:1.4-alpine

WORKDIR /application

COPY package.json ./

RUN bun install
