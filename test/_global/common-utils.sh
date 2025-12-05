#!/bin/bash

# Common test utilities for devcontainer features

FAILED=()

# Check if a command succeeds
# Usage: check "description" command args...
check() {
    local label="$1"
    shift
    echo -e "\n🧪 Testing: $label"
    if "$@"; then
        echo "✅ Passed: $label"
        return 0
    else
        echo "❌ Failed: $label"
        FAILED+=("$label")
        return 1
    fi
}

# Report final test results
reportResults() {
    echo -e "\n======================================"
    if [ ${#FAILED[@]} -eq 0 ]; then
        echo "✅ All tests passed!"
        exit 0
    else
        echo "❌ ${#FAILED[@]} test(s) failed:"
        printf '   - %s\n' "${FAILED[@]}"
        exit 1
    fi
}
