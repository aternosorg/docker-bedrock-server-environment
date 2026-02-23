FROM ubuntu:noble

ARG TARGETARCH

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        wget \
        ca-certificates \
        libcurl4 \
        openssl && \
    rm -rf /var/lib/apt/lists/*

# Sideload the legacy OpenSSL 1.0.0 and 1.1 libraries for older Bedrock versions
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        wget -q http://ports.ubuntu.com/ubuntu-ports/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.23_arm64.deb && \
        wget -q http://ports.ubuntu.com/ubuntu-ports/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.13_arm64.deb; \
    else \
        wget -q http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb && \
        wget -q http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.13_amd64.deb; \
    fi && \
    dpkg -i libssl1.1*.deb libssl1.0.0*.deb && \
    rm libssl1.1*.deb libssl1.0.0*.deb

# Install ARM tools and Box64
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        echo "ARM64 detected. Installing Box64 and its dependencies..." && \
        apt-get update && \
        apt-get install -y --no-install-recommends gnupg && \
        wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list && \
        wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg && \
        apt-get update && \
        apt-get install -y --no-install-recommends box64 && \
        rm -rf /var/lib/apt/lists/*; \
    else \
        echo "AMD64 detected. Skipping emulator setup."; \
    fi

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /server

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]