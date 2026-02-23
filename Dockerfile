FROM ubuntu:bionic AS bionic
RUN apt-get update && \
    apt-get install -y --no-install-recommends libssl1.0.0 && \
    mkdir /export && \
    cp /usr/lib/*/libssl.so.1.0.0 /usr/lib/*/libcrypto.so.1.0.0 /export/

FROM ubuntu:focal AS focal
RUN apt-get update && \
    apt-get install -y --no-install-recommends libssl1.1 && \
    mkdir /export && \
    cp /usr/lib/*/libssl.so.1.1 /usr/lib/*/libcrypto.so.1.1 /export/

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
COPY --from=bionic /export/* /usr/lib/
COPY --from=focal /export/* /usr/lib/

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