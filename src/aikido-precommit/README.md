
# Aikido Secrets Pre-commit Hook (aikido-precommit)

Installs AikidoSec's pre-commit hook for scanning secrets, passwords, and API keys before commits

## Example Usage

```json
"features": {
    "ghcr.io/ProxayFox/devcontainer-features/aikido-precommit:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Version of the aikido-local-scanner to install (use 'latest' for auto-detection) | string | latest |
| setupGlobalHooks | Configure git global hooks path (set to false for download-only) | boolean | true |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/ProxayFox/devcontainer-features/blob/main/src/aikido-precommit/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
