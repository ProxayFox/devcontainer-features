# Copilot Instructions

## Repo Purpose

Single dev container Feature set published to GHCR. Each Feature follows the [containers.dev spec](https://containers.dev/implementors/features/) with metadata, installer, and tests under its own folder. See <README.md> for usage snippets.

## Layout

```text
src/<feature>/devcontainer-feature.json   # metadata + options (source of truth for defaults)
src/<feature>/install.sh                  # installer script
test/<feature>/test.sh                    # sanity tests (run inside a built container)
test/<feature>/scenarios.json             # optional extra test scenarios
test/_global/common-utils.sh              # shared test helpers (check/reportResults)
```

## Commands

Task                   | Command
---------------------- | ------------------------------------------------------------------------------
Run all feature tests  | `devcontainer features test`
Test one feature       | `devcontainer features test -f <feature>`
Test specific scenario | `devcontainer features test -f <feature> --skip-scenarios --filter <scenario>`
Validate metadata      | `devcontainer features info manifest src/<feature>`

## CI Workflows (`.github/workflows/`)

- **[test.yaml](.github/workflows/test.yaml)** -- runs on push to `main` and PRs. Currently only matrices `clickhouse-local`; lazydocker and aikido-precommit are not in CI yet.
- **[validate.yml](.github/workflows/validate.yml)** -- validates all `devcontainer-feature.json` files on PRs.
- **[release.yaml](.github/workflows/release.yaml)** -- publishes features to GHCR on push to `main` when any `devcontainer-feature.json` changes.
- **aikido-version-check.yml / lazydocker-version-check.yml** -- weekly cron jobs that compare upstream versions and open update PRs automatically.

## Option → Env Mapping

Feature options become uppercase env vars in `install.sh` (e.g., `version` → `VERSION`, `installMethod` → `INSTALLMETHOD`). Default values live in each `devcontainer-feature.json`.

## Installer Conventions

- Non-interactive: set `DEBIAN_FRONTEND=noninteractive`.
- Install minimal prerequisites; clean temp dirs/archives (use `trap … EXIT`).
- Use `install -m 755` for binaries into `/usr/local/bin`.
- Always verify the install at the end (e.g., `<binary> --version`).
- For version resolution: support `latest` with a hardcoded `FALLBACK_VERSION` as backup.

## Test Conventions

- Tests use `set -e` for fast failure.
- Assume feature binaries are already installed in `PATH`.
- Shared helpers in <test/_global/common-utils.sh> provide `check` and `reportResults` functions.
- Extra scenarios go in `test/<feature>/scenarios.json` with a companion `<scenario>.sh` script.

## Adding a New Feature

1. Create `src/<feature>/devcontainer-feature.json` (mirror existing schema, set `id`, `version`, `options`).
2. Write `src/<feature>/install.sh` consuming options via uppercase env vars.
3. Add `test/<feature>/test.sh` with sanity checks.
4. Update <README.md> with a usage snippet.
5. Bump the `version` field to publish a new tag.

## Publishing

Each feature is semvered in its `devcontainer-feature.json`; images publish to `ghcr.io/proxayfox/devcontainer-features/<feature>:<major>`. Keep metadata version in sync with published tags.

## Dev Environment

The repo's own dev container (<.devcontainer/devcontainer.json>) uses Node 24 + Docker-in-Docker + GitHub CLI. The `@devcontainers/cli` package is installed globally on container create.
