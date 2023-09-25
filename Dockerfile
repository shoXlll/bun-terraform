FROM oven/bun:1.0.3

WORKDIR /usr/src/app

COPY app/package.json ./ \
     app/bun.lockb ./

RUN bun install
