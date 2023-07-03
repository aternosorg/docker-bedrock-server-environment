## aternosorg/docker-bedrock-server-environment

A docker image for running bedrock 1.7+ servers. This image does not include the bedrock server itself, you must provide it yourself.

### Usage

```bash
docker run -v /path/to/server:/server -w /server ghcr.io/aternosorg/docker-bedrock-server-environment:master ./bedrock_server
```