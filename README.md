## aternosorg/docker-bedrock-server-environment

A docker image for running Bedrock servers (currently tested with 1.6+). This image does not include the Bedrock server itself, you must provide it yourself.

### Usage

```bash
docker run -v /path/to/server:/server -w /server aternos/bedrock-server-environment
```

The image contains an entrypoint that automatically handles ARM emulation and loads old libraries for older Bedrock server versions.
By default, the entrypoint expects the server executable to be named `bedrock_server` located in the working directory
of the container. You can change this by setting the `BEDROCK_EXECUTABLE` environment variable to the path of your server executable.

The default entrypoint also writes the server output to a file named `server.log` in the working directory. You can change this by 
setting the `LOG_FILE` environment variable to the desired log file path.