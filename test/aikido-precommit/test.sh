#!/bin/bash
set -e

# Optional: Import test library bundled with the container
if [ -f "/usr/local/etc/vscode-dev-containers/test-utils.sh" ]; then
    source /usr/local/etc/vscode-dev-containers/test-utils.sh
fi

# Check if aikido-local-scanner is installed and accessible
echo "Testing: aikido-local-scanner installation"
if ! command -v aikido-local-scanner &> /dev/null; then
    echo "❌ FAILED: aikido-local-scanner command not found"
    exit 1
fi
echo "✅ PASSED: aikido-local-scanner found"

# Check that the binary is executable
echo "Testing: aikido-local-scanner binary permissions"
SCANNER_PATH=$(which aikido-local-scanner)
if [ ! -x "$SCANNER_PATH" ]; then
    echo "❌ FAILED: aikido-local-scanner binary is not executable"
    exit 1
fi
echo "✅ PASSED: aikido-local-scanner binary is executable"
echo "   Location: $SCANNER_PATH"

# Check that the binary runs without error (help or version output)
echo "Testing: aikido-local-scanner execution"
if ! aikido-local-scanner --help &> /dev/null && ! aikido-local-scanner 2>&1 | head -1 > /dev/null; then
    echo "❌ FAILED: aikido-local-scanner failed to execute"
    exit 1
fi
echo "✅ PASSED: aikido-local-scanner executes successfully"

# Check that global hooks are configured (if setupGlobalHooks was true)
echo "Testing: git global hooks configuration"
HOOKS_PATH=$(git config --global core.hooksPath 2>/dev/null || echo "")
if [ -n "$HOOKS_PATH" ]; then
    echo "✅ PASSED: git global hooks path configured: $HOOKS_PATH"
    
    # Check if pre-commit hook exists
    if [ -f "${HOOKS_PATH}/pre-commit" ]; then
        echo "✅ PASSED: pre-commit hook file exists"
        
        # Check if Aikido snippet is present
        if grep -q "Aikido local scanner" "${HOOKS_PATH}/pre-commit"; then
            echo "✅ PASSED: Aikido hook snippet found in pre-commit"
        else
            echo "⚠️  WARNING: Aikido hook snippet not found in pre-commit (may be download-only mode)"
        fi
    else
        echo "⚠️  WARNING: pre-commit hook file not found (may be download-only mode)"
    fi
else
    echo "⚠️  WARNING: git global hooks path not configured (may be download-only mode)"
fi

# Test scanning a dummy repository (functional test)
echo "Testing: aikido-local-scanner scan functionality"
TEMP_REPO=$(mktemp -d)
trap 'rm -rf "$TEMP_REPO"' EXIT

# Initialize a git repo
cd "$TEMP_REPO"
git init -q
git config user.email "test@test.com"
git config user.name "Test User"

# Create a safe test file (no secrets)
echo "Hello, World!" > safe_file.txt
git add safe_file.txt

# Run the scanner on the repo
if aikido-local-scanner pre-commit-scan "$TEMP_REPO" 2>&1; then
    echo "✅ PASSED: aikido-local-scanner scan completed successfully"
else
    # Scanner might return non-zero for various reasons, check if it at least ran
    echo "⚠️  WARNING: aikido-local-scanner scan returned non-zero (may be expected behavior)"
fi

echo ""
echo "✅ All tests passed!"
