#!/bin/bash
set -e

echo "Activating feature 'clickhouse-local'"

VERSION="${VERSION:-latest}"
INSTALL_METHOD="${INSTALLMETHOD:-quick}"

# Ensure basic dependencies
export DEBIAN_FRONTEND=noninteractive

if [ "$INSTALL_METHOD" = "apt" ]; then
    echo "Installing via APT repository..."
    
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl gnupg
    
    # Add GPG key
    GNUPGHOME=$(mktemp -d)
    export GNUPGHOME
    curl -fsSL 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' | \
        gpg --dearmor -o /usr/share/keyrings/clickhouse-keyring.gpg
    rm -rf "$GNUPGHOME"
    unset GNUPGHOME
    
    # Add repository
    echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg] https://packages.clickhouse.com/deb stable main" | \
        tee /etc/apt/sources.list.d/clickhouse.list
    
    apt-get update
    
    if [ "$VERSION" = "latest" ]; then
        apt-get install -y clickhouse-client
    else
        apt-get install -y clickhouse-client=${VERSION}
    fi
else
    echo "Installing via quick install script..."
    
    apt-get update
    apt-get install -y curl ca-certificates
    
    # Official quick install
    curl https://clickhouse.com/ | sh
    
    # Move to system path
    mv ./clickhouse /usr/local/bin/clickhouse
    
    # Create symlinks
    ln -sf /usr/local/bin/clickhouse /usr/local/bin/clickhouse-local
    ln -sf /usr/local/bin/clickhouse /usr/local/bin/clickhouse-client
fi

# Verify
if clickhouse-local --version; then
    echo "✓ ClickHouse Local CLI installed successfully!"
else
    echo "✗ Installation verification failed"
    exit 1
fi