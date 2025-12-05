#!/bin/bash
set -e

# Optional: Import test library bundled with the container
if [ -f "/usr/local/etc/vscode-dev-containers/test-utils.sh" ]; then
    source /usr/local/etc/vscode-dev-containers/test-utils.sh
fi

# Check if clickhouse-local is installed and accessible
echo "Testing: clickhouse-local installation"
if ! command -v clickhouse-local &> /dev/null; then
    echo "❌ FAILED: clickhouse-local command not found"
    exit 1
fi
echo "✅ PASSED: clickhouse-local found"

# Check version output
echo "Testing: clickhouse-local version"
if ! clickhouse-local --version; then
    echo "❌ FAILED: clickhouse-local --version failed"
    exit 1
fi
echo "✅ PASSED: clickhouse-local version check"

# Test basic query
echo "Testing: basic SQL query"
RESULT=$(echo 'SELECT 1 as test' | clickhouse-local 2>&1)
if [ $? -ne 0 ]; then
    echo "❌ FAILED: Basic query failed: $RESULT"
    exit 1
fi
if ! echo "$RESULT" | grep -q "1"; then
    echo "❌ FAILED: Query did not return expected result"
    exit 1
fi
echo "✅ PASSED: Basic query works"

echo ""
echo "✅ All tests passed!"