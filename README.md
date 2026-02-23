## aternosorg/docker-bedrock-server-environment

A docker image for running Bedrock servers. This image does not include the Bedrock server itself, you must provide it yourself.

### Usage

```bash
docker run -v /path/to/server:/server -w /server aternos/bedrock-server-environment ./bedrock_server
```

### Versions

Older Bedrock versions require older libraries provided by older Ubuntu versions. 
This image builds multiple images for different Ubuntu versions, and you can specify which one to use by using the appropriate tag.

You can use either the Ubuntu version name alone or as a suffix for either a branch name or a tag name.

| Bedrock versions | Ubuntu version / tag |
|------------------|----------------------|
| < 1.7            | `bionic`             |
| 1.7 - 1.19.22    | `focal`              |
| 1.19.30 - ???    | `jammy`              |
| \> ???           | `noble`              |