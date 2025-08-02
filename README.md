# Tips

## commands

### start dev container

```bash
docker compose up -d
```

### production image build

```bash
docker build -t deployment/bun -f deployment/Dockerfile application
```

### host package install

```bash
bun install
```

### container package install

```bash
docker run \
--rm \
-w /temp \
-v bun_node_modules:/temp/node_modules/ \
-v ./application/bunfig.toml:/temp/bunfig.toml \
-v ./application/package.json:/temp/package.json \
oven/bun:1.2-alpine bun install
```

### update lockfile

```bash
docker run \
--name package-installer \
-w /temp \
-v bun_node_modules:/temp/node_modules/ \
-v ./application/bunfig.toml:/temp/bunfig.toml \
-v ./application/package.json:/temp/package.json \
oven/bun:1.2-alpine bun install -y \
&& docker cp package-installer:/temp/bun.lockb ./application/ \
&& docker cp package-installer:/temp/yarn.lock ./application/ \
&& docker rm -v package-installer
```

### renovate config validate

```bash
docker run --rm \
-v ./renovate.json:/app/renovate.json \
-w /app \
renovate/renovate:slim renovate-config-validator
```
