## aternosorg/docker-bedrock-server-environment

A docker image for running bedrock 1.7+ servers. This image does not include the bedrock server itself, you must provide it yourself.

### Usage

```bash
docker run -v /path/to/server:/server -w /server ghcr.io/aternosorg/docker-bedrock-server-environment ./bedrock_server
```

### Versions

For bedrock 1.19.30 or newer use the latest image:

```bash
docker run -v /path/to/server:/server -w /server ghcr.io/aternosorg/docker-bedrock-server-environment ./bedrock_server
```

For Bedrock 1.7-1.19.22 use the `1.0.0` tag:

```bash
docker run -v /path/to/server:/server -w /server ghcr.io/aternosorg/docker-bedrock-server-environment:1.0.0 ./bedrock_server
```