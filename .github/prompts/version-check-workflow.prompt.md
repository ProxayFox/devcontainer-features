---
description: Create or update a version-check workflow for automated upstream version bumps
mode: agent
---

# Version-Check Workflow

Create a GitHub Actions workflow at `.github/workflows/{{featureName}}-version-check.yml` that:

1. Runs weekly on a cron schedule (pick a unique time slot on Monday UTC).
2. Fetches the latest upstream version of `{{featureName}}` (from GitHub releases API, upstream install script, or similar).
3. Compares it against the current default in `src/{{featureName}}/devcontainer-feature.json` and/or `FALLBACK_VERSION` in `install.sh`.
4. If a newer version exists, updates the relevant files and opens a PR using `peter-evans/create-pull-request@v8` with branch `chore/{{featureName}}-version-update`.

Reference existing workflows in `.github/workflows/lazydocker-version-check.yml` and `.github/workflows/aikido-version-check.yml` for patterns.
