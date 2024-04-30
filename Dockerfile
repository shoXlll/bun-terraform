FROM oven/bun:1.1-alpine

WORKDIR /application

COPY package.json ./

RUN bun install
