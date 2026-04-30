#!/bin/bash

set -e

# Get version from options (default to latest stable)
VERSION="${VERSION:-"0.24.2"}"

echo "Installing lazydocker version ${VERSION}..."

# Ensure required tools are installed
if ! command -v curl >/dev/null 2>&1; then
    echo "Installing curl..."
    apt-get update -y
    apt-get install -y curl
fi

if ! command -v file >/dev/null 2>&1; then
    echo "Installing file..."
    apt-get update -y
    apt-get install -y file
fi

# Get architecture using uname and map to GitHub release naming convention
UNAME_ARCH=$(uname -m)

case "$UNAME_ARCH" in
    x86_64)
        ARCH="x86_64"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    armv7l)
        ARCH="armv7"
        ;;
    armv6l)
        ARCH="armv6"
        ;;
    i686|i386)
        ARCH="x86"
        ;;
    *)
        echo "Error: Unsupported architecture: $UNAME_ARCH"
        exit 1
        ;;
esac

# Construct download URL
DOWNLOAD_URL="https://github.com/jesseduffield/lazydocker/releases/download/v${VERSION}/lazydocker_${VERSION}_Linux_${ARCH}.tar.gz"

echo "Downloading from: $DOWNLOAD_URL"

# Download the archive
if ! curl -fsSL -o /tmp/lazydocker.tar.gz "$DOWNLOAD_URL"; then
    echo "Error: Failed to download lazydocker from $DOWNLOAD_URL"
    exit 1
fi

# Verify the download is a valid gzip file
if ! file /tmp/lazydocker.tar.gz | grep -q "gzip compressed data"; then
    echo "Error: Downloaded file is not a valid gzip archive"
    echo "File type: $(file /tmp/lazydocker.tar.gz)"
    rm -f /tmp/lazydocker.tar.gz
    exit 1
fi

# Extract and install
echo "Extracting lazydocker..."
tar -xzf /tmp/lazydocker.tar.gz -C /tmp

# Install to /usr/local/bin
install -m 755 /tmp/lazydocker /usr/local/bin/lazydocker

# Cleanup
rm -f /tmp/lazydocker.tar.gz /tmp/lazydocker

# Verify installation
if command -v lazydocker >/dev/null 2>&1; then
    echo "lazydocker $(lazydocker --version) installed successfully!"
else
    echo "Error: lazydocker installation verification failed"
    exit 1
fi
