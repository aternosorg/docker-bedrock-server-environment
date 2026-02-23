#!/bin/bash

if [ ! -f "./bedrock_server" ]; then
    echo "ERROR: 'bedrock_server' binary not found in $PWD!"
    exit 1
fi

if [ -z "$LD_LIBRARY_PATH" ]; then
    export LD_LIBRARY_PATH="."
else
    export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
fi

ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    exec box64 ./bedrock_server | tee -a server.log
else
    exec ./bedrock_server | tee -a server.log
fi