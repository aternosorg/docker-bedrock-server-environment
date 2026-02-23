ARG LEGACY_ARCH=linux/amd64

# --- STAGE 1: Extract 2018 Legacy Environment (ALWAYS x86_64) ---
FROM --platform=${LEGACY_ARCH} ubuntu:bionic AS bionic
RUN apt-get update && \
    apt-get install -y --no-install-recommends libssl1.0.0 libstdc++6 libgcc1 && \
    mkdir -p /export && \
    cp -L /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /export/ || true && \
    cp -L /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /export/ || true && \
    cp -L /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /export/ || true && \
    cp -L /lib/x86_64-linux-gnu/libgcc_s.so.1 /export/ || true

# --- STAGE 2: Extract 2020 Legacy Environment (ALWAYS x86_64) ---
FROM --platform=${LEGACY_ARCH} ubuntu:focal AS focal
RUN apt-get update && \
    apt-get install -y --no-install-recommends libssl1.1 && \
    mkdir -p /export && \
    cp -L /usr/lib/x86_64-linux-gnu/libssl.so.1.1 /export/ || true && \
    cp -L /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /export/ || true

# --- STAGE 3: Final Universal Image (Noble 24.04) ---
FROM ubuntu:noble
ARG TARGETARCH

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl wget ca-certificates libcurl4 openssl file gnupg && \
    rm -rf /var/lib/apt/lists/*

# Inject legacy x86_64 libraries into an isolated folder
RUN mkdir -p /usr/lib/legacy-x86_64
COPY --from=bionic /export/ /usr/lib/legacy-x86_64/
COPY --from=focal /export/ /usr/lib/legacy-x86_64/

# Conditionally install Box64 for ARM builds
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg && \
        wget -q https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list && \
        apt-get update && apt-get install -y --no-install-recommends box64 && \
        rm -rf /var/lib/apt/lists/*; \
    fi

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir -p /server && chmod 777 /server
WORKDIR /server

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]