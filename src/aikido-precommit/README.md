# Aikido Secrets Pre-commit Hook (aikido-precommit)

Installs AikidoSec's pre-commit hook for scanning secrets, passwords, and API keys before commits

## Example Usage

```json
"features": {
    "ghcr.io/ProxayFox/devcontainer-features/aikido-precommit:1": {}
}
```

## Options

Options Id       | Description                                                                      | Type    | Default Value
---------------- | -------------------------------------------------------------------------------- | ------- | -------------
version          | Version of the aikido-local-scanner to install (use 'latest' for auto-detection) | string  | latest
setupGlobalHooks | Configure git global hooks path (set to false for download-only)                 | boolean | true

## Version Management

This feature supports two version strategies:

### Auto-detection (default)

With `version: "latest"` (the default), the installer fetches the current version from [Aikido's official install script](https://github.com/AikidoSec/pre-commit/blob/main/installation-samples/install-global/install-aikido-hook.sh) at build time. This ensures you always get the latest scanner version without manual updates.

If the upstream script is unreachable, a fallback version is used (kept up-to-date via automated PRs).

### Pinned version

For reproducible builds or to use a specific version, set an explicit version:

```json
"features": {
    "ghcr.io/ProxayFox/devcontainer-features/aikido-precommit:1": {
        "version": "v1.0.116"
    }
}
```

--------------------------------------------------------------------------------

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/ProxayFox/devcontainer-features/blob/main/src/aikido-precommit/devcontainer-feature.json). Add additional notes to a `NOTES.md`._
