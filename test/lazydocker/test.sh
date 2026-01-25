#!/bin/bash
set -e

# Optional: Import test library bundled with the container
if [ -f "/usr/local/etc/vscode-dev-containers/test-utils.sh" ]; then
    source /usr/local/etc/vscode-dev-containers/test-utils.sh
fi

# Check if lazydocker is installed and accessible
echo "Testing: lazydocker installation"
if ! command -v lazydocker &> /dev/null; then
    echo "❌ FAILED: lazydocker command not found"
    exit 1
fi
echo "✅ PASSED: lazydocker found"

# Check version output
echo "Testing: lazydocker version"
if ! lazydocker --version; then
    echo "❌ FAILED: lazydocker --version failed"
    exit 1
fi
echo "✅ PASSED: lazydocker version check"

# Check that the binary is executable
echo "Testing: lazydocker binary permissions"
LAZYDOCKER_PATH=$(which lazydocker)
if [ ! -x "$LAZYDOCKER_PATH" ]; then
    echo "❌ FAILED: lazydocker binary is not executable"
    exit 1
fi
echo "✅ PASSED: lazydocker binary is executable"

echo ""
echo "✅ All tests passed!"
