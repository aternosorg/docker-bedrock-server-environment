ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG TARGETARCH

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        libcurl4 \
        openssl && \
    rm -rf /var/lib/apt/lists/*

RUN if [ "$TARGETARCH" = "arm64" ]; then \
        apt-get update && \
        apt-get install -y --no-install-recommends wget gnupg && \
        wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list && \
        wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg && \
        apt-get update && \
        apt-get install -y --no-install-recommends box64 && \
        rm -rf /var/lib/apt/lists/*; \
    fi

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /server

ENV LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]