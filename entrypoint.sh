#!/bin/bash

SERVER_BIN="${BEDROCK_EXECUTABLE:-./bedrock_server}"
LOG_OUTPUT="${LOG_FILE:-server.log}"

if [ ! -f "$SERVER_BIN" ]; then
    echo "ERROR: Executable '$SERVER_BIN' not found in $PWD!"
    exit 1
fi
chmod +x "$SERVER_BIN" 2>/dev/null

ARCH=$(uname -m)
IS_ARM=false
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    IS_ARM=true
fi

NEEDS_LEGACY_1_0=false
NEEDS_LEGACY_1_1=false

if grep -q "libssl.so.1.0.0" "$SERVER_BIN"; then
    NEEDS_LEGACY_1_0=true
elif grep -q "libssl.so.1.1" "$SERVER_BIN"; then
    NEEDS_LEGACY_1_1=true
fi

export BOX64_LOG=0
export BOX64_NOBANNER=1

if [ "$NEEDS_LEGACY_1_0" = true ]; then

    if [ "$IS_ARM" = true ]; then
        export BOX64_LD_LIBRARY_PATH=".:/usr/lib/legacy-x86_64"
        export BOX64_EMULATED_LIBS="libstdc++.so.6:libgcc_s.so.1:libssl.so.1.0.0:libcrypto.so.1.0.0"
        box64 "$SERVER_BIN" 2>&1 | tee -a "$LOG_OUTPUT"
    else
        LD_LIBRARY_PATH=".:/usr/lib/legacy-x86_64:$LD_LIBRARY_PATH" "$SERVER_BIN" 2>&1 | tee -a "$LOG_OUTPUT"
    fi

elif [ "$NEEDS_LEGACY_1_1" = true ]; then

    if [ "$IS_ARM" = true ]; then
        export BOX64_LD_LIBRARY_PATH=".:/usr/lib/legacy-x86_64"
        export BOX64_EMULATED_LIBS="libssl.so.1.1:libcrypto.so.1.1"
        box64 "$SERVER_BIN" 2>&1 | tee -a "$LOG_OUTPUT"
    else
        LD_LIBRARY_PATH=".:/usr/lib/legacy-x86_64:$LD_LIBRARY_PATH" "$SERVER_BIN" 2>&1 | tee -a "$LOG_OUTPUT"
    fi

else
    if [ "$IS_ARM" = true ]; then
        export BOX64_LD_LIBRARY_PATH="."
        box64 "$SERVER_BIN" 2>&1 | tee -a "$LOG_OUTPUT"
    else
        LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH" "$SERVER_BIN" 2>&1 | tee -a "$LOG_OUTPUT"
    fi
fi