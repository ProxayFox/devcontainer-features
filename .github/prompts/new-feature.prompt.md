---
description: Scaffold a new dev container Feature (installer, metadata, tests)
mode: agent
---

# New Dev Container Feature

Create a new dev container Feature named `{{featureName}}` that installs `{{toolDescription}}`.

## Steps

1. Create `src/{{featureName}}/devcontainer-feature.json` following the schema in existing features. Set `id`, `version` (start at `1.0.0`), `name`, `description`, `documentationURL`, and `options` (at minimum a `version` option with a sensible default).

2. Create `src/{{featureName}}/install.sh`:
   - Start with `#!/bin/sh` and `set -e`
   - Set `DEBIAN_FRONTEND=noninteractive`
   - Read options from uppercase env vars
   - Support `version=latest` with a hardcoded `FALLBACK_VERSION`
   - Use `trap 'rm -rf "$TEMP_DIR"' EXIT` for cleanup
   - Install binary to `/usr/local/bin` with `install -m 755`
   - End with a verification command (e.g., `<binary> --version`)

3. Create `test/{{featureName}}/test.sh`:
   - Start with `#!/bin/bash` and `set -e`
   - Source `../\_global/common-utils.sh` if useful
   - Assert the binary is in PATH, is executable, and runs a basic command

4. Add a section to `README.md` with a usage snippet.
