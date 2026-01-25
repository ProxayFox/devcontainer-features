#!/bin/bash

set -e

# Get options from environment (feature options are uppercase)
VERSION="${VERSION:-"v1.0.116"}"
SETUP_GLOBAL_HOOKS="${SETUPGLOBALHOOKS:-"true"}"

# Normalize version format (ensure it starts with 'v')
if [[ ! "$VERSION" =~ ^v ]]; then
    VERSION="v${VERSION}"
fi

echo "Installing Aikido pre-commit scanner version ${VERSION}..."

# Ensure required tools are installed
export DEBIAN_FRONTEND=noninteractive

install_if_missing() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Installing $1..."
        apt-get update -y
        apt-get install -y "$2"
    fi
}

install_if_missing curl curl
install_if_missing unzip unzip
install_if_missing git git

# Detect platform and architecture
OS=$(uname -s)
ARCH=$(uname -m)

case "$OS" in
    Linux)
        PLATFORM="linux"
        ;;
    Darwin)
        PLATFORM="darwin"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        PLATFORM="windows"
        ;;
    *)
        echo "Error: Unsupported operating system: $OS"
        exit 1
        ;;
esac

case "$ARCH" in
    x86_64)
        ARCH_NAME="X86_64"
        ;;
    aarch64|arm64)
        ARCH_NAME="ARM64"
        ;;
    *)
        echo "Error: Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Construct download URL
BASE_URL="https://aikido-local-scanner.s3.eu-west-1.amazonaws.com/${VERSION}"
BINARY_NAME="aikido-local-scanner"
DOWNLOAD_FILE="${BINARY_NAME}.zip"
DOWNLOAD_URL="${BASE_URL}/${PLATFORM}_${ARCH_NAME}/${DOWNLOAD_FILE}"

echo "Downloading from: $DOWNLOAD_URL"

# Create temp directory with cleanup trap
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Download the archive
if ! curl -fsSL -o "${TEMP_DIR}/${DOWNLOAD_FILE}" "$DOWNLOAD_URL"; then
    echo "Error: Failed to download aikido-local-scanner from $DOWNLOAD_URL"
    exit 1
fi

# Extract and install
echo "Extracting aikido-local-scanner..."
unzip -q "${TEMP_DIR}/${DOWNLOAD_FILE}" -d "${TEMP_DIR}"

# Install to /usr/local/bin (system-wide for container)
INSTALL_DIR="/usr/local/bin"
install -m 755 "${TEMP_DIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"

echo "Installed ${BINARY_NAME} to ${INSTALL_DIR}/${BINARY_NAME}"

# Setup global git hooks if requested
if [ "$SETUP_GLOBAL_HOOKS" = "true" ]; then
    echo "Configuring global git hooks..."

    # Determine hooks directory
    GLOBAL_HOOKS_DIR="/etc/git-hooks"

    # Check if core.hooksPath is already set
    EXISTING_HOOKS_PATH=$(git config --global core.hooksPath 2>/dev/null || echo "")

    if [ -n "$EXISTING_HOOKS_PATH" ]; then
        echo "Using existing hooks path: $EXISTING_HOOKS_PATH"
        ACTUAL_HOOKS_DIR="$EXISTING_HOOKS_PATH"
    else
        echo "Setting global hooks path to: $GLOBAL_HOOKS_DIR"
        git config --global core.hooksPath "$GLOBAL_HOOKS_DIR"
        ACTUAL_HOOKS_DIR="$GLOBAL_HOOKS_DIR"
    fi

    # Create hooks directory if it doesn't exist
    mkdir -p "$ACTUAL_HOOKS_DIR"

    # Create/update pre-commit hook
    PRECOMMIT_HOOK="${ACTUAL_HOOKS_DIR}/pre-commit"

    # Define the Aikido hook snippet
    AIKIDO_HOOK_START="# --- Aikido local scanner ---"
    AIKIDO_HOOK_END="# --- End Aikido local scanner ---"
    AIKIDO_HOOK_SNIPPET="""
        ${AIKIDO_HOOK_START}
        [ -x \"${INSTALL_DIR}/${BINARY_NAME}\" ] || { echo \"Aikido local scanner not found at ${INSTALL_DIR}/${BINARY_NAME}\"; exit 1; }
        REPO_ROOT=\"\$(git rev-parse --show-toplevel)\"
        \"${INSTALL_DIR}/${BINARY_NAME}\" pre-commit-scan \"\$REPO_ROOT\"
        ${AIKIDO_HOOK_END}
    """

    # Check if hook file exists and if Aikido snippet is already present
    if [ -f "$PRECOMMIT_HOOK" ]; then
        if grep -q "$AIKIDO_HOOK_START" "$PRECOMMIT_HOOK"; then
            echo "Aikido hook already present in pre-commit, skipping..."
        else
            echo "Appending Aikido hook to existing pre-commit..."
            echo "" >> "$PRECOMMIT_HOOK"
            echo "$AIKIDO_HOOK_SNIPPET" >> "$PRECOMMIT_HOOK"
        fi
    else
        echo "Creating new pre-commit hook..."
        echo "#!/bin/sh" > "$PRECOMMIT_HOOK"
        echo "" >> "$PRECOMMIT_HOOK"
        echo "$AIKIDO_HOOK_SNIPPET" >> "$PRECOMMIT_HOOK"
    fi

    # Make hook executable
    chmod +x "$PRECOMMIT_HOOK"

    echo "Global pre-commit hook configured successfully!"
fi

# Verify installation
if command -v aikido-local-scanner >/dev/null 2>&1; then
    echo ""
    echo "✅ aikido-local-scanner installed successfully!"
    echo "   Location: $(which aikido-local-scanner)"
    if [ "$SETUP_GLOBAL_HOOKS" = "true" ]; then
        echo "   Global hooks: $(git config --global core.hooksPath)"
    fi
else
    echo "❌ Error: aikido-local-scanner installation failed"
    exit 1
fi
