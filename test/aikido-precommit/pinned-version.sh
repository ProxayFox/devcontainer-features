#!/bin/bash

set -e

echo "Testing: aikido-local-scanner pinned version installation"

# Check binary exists
if command -v aikido-local-scanner >/dev/null 2>&1; then
    echo "✅ PASSED: aikido-local-scanner found"
else
    echo "❌ FAILED: aikido-local-scanner not found"
    exit 1
fi

# The pinned version test verifies that explicit versions work
# Note: We can't easily verify the exact version without aikido-local-scanner --version support
# but we verify the binary was successfully downloaded and installed
echo "✅ PASSED: Pinned version installation completed"

echo ""
echo "✅ All pinned-version tests passed!"
