# Aikido Secrets Pre-commit Hook (aikido-precommit)

Installs [AikidoSec's pre-commit hook](https://github.com/AikidoSec/pre-commit) for scanning secrets, passwords, and API keys before commits. This helps prevent accidentally committing sensitive information to your repositories.

## Features

- Scans staged files for secrets, API keys, passwords, and other sensitive data
- Runs automatically on `git commit` when global hooks are configured
- Supports Linux (x86_64, ARM64) and macOS (ARM64)
- Lightweight binary with no runtime dependencies
- Configurable version selection

## Usage

Add this Feature to your `devcontainer.json`:

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/proxayfox/devcontainer-features/aikido-precommit:1": {}
    }
}
```

### With Custom Options

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/proxayfox/devcontainer-features/aikido-precommit:1": {
            "version": "v1.0.116",
            "setupGlobalHooks": true
        }
    }
}
```

## Options

Option             | Type    | Default    | Description
------------------ | ------- | ---------- | ------------------------------------------------------------------
`version`          | string  | `v1.0.116` | Version of the aikido-local-scanner to install
`setupGlobalHooks` | boolean | `true`     | Configure git global hooks path (set to `false` for download-only)

## How It Works

When `setupGlobalHooks` is `true` (default), the Feature:

1. Installs the `aikido-local-scanner` binary to `/usr/local/bin/`
2. Configures `git config --global core.hooksPath` to use `/etc/git-hooks/` (or respects an existing hooks path)
3. Creates a `pre-commit` hook that runs the scanner on every commit

When you run `git commit`, the scanner will:

- Analyze staged files for potential secrets
- Block the commit if secrets are detected
- Allow the commit to proceed if no issues are found

## Manual Usage

You can also run the scanner manually:

```bash
# Scan a repository
aikido-local-scanner pre-commit-scan /path/to/repo

# Scan the current repository
aikido-local-scanner pre-commit-scan "$(git rev-parse --show-toplevel)"
```

## Download-Only Mode

If you prefer to manage git hooks yourself, set `setupGlobalHooks` to `false`:

```jsonc
{
    "features": {
        "ghcr.io/proxayfox/devcontainer-features/aikido-precommit:1": {
            "setupGlobalHooks": false
        }
    }
}
```

This installs only the binary without modifying your git configuration.

## Supported Platforms

- Linux x86_64
- Linux ARM64
- macOS ARM64 (Apple Silicon)

## Resources

- [AikidoSec Pre-commit Repository](https://github.com/AikidoSec/pre-commit)
- [Aikido Security](https://www.aikido.dev/)
