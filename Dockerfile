ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*