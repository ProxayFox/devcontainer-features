# Dev Container Features

> A collection of custom [dev container Features](https://containers.dev/implementors/features/) for enhancing development environments. These Features are hosted on GitHub Container Registry and follow the [dev container Feature distribution specification](https://containers.dev/implementors/features-distribution/).

## Available Features

This repository contains a collection of dev container Features designed to streamline development workflows. Each Feature can be easily added to your dev container configuration.

### `clickhouse-local`

Installs the ClickHouse Local CLI, enabling you to run SQL queries on local files without setting up a full ClickHouse server. Perfect for data analysis, ETL development, and testing.

**Features:**

- Run SQL queries on CSV, TSV, JSON, Parquet, and other file formats
- No server setup required - works entirely locally
- Multiple installation methods (quick binary install or APT package manager)
- Configurable version selection

**Usage:**

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/proxayfox/devcontainer-features/clickhouse-local:1": {
            "version": "latest",
            "installMethod": "quick"
        }
    }
}
```

**Options:**

- `version` (string): ClickHouse version to install. Default: `"latest"`
- `installMethod` (string): Installation method - `"quick"` (binary) or `"apt"` (package manager). Default: `"quick"`

**Example:**

```bash
# Query a CSV file
$ clickhouse-local --query "SELECT * FROM file('data.csv', 'CSV') LIMIT 10"

# Run complex analytics
$ clickhouse-local --query "SELECT user_id, COUNT(*) as visits FROM file('logs.json', 'JSONEachRow') GROUP BY user_id"
```

## Repository Structure

This repository follows the standard dev container Features layout:

```text
├── src
│   └── clickhouse-local
│       ├── devcontainer-feature.json
│       └── install.sh
├── test
│   ├── _global
│   │   └── common-utils.sh
│   └── clickhouse-local
│       └── test.sh
└── README.md
```

Each Feature has its own subdirectory under `src/` containing:

- `devcontainer-feature.json` - Feature metadata and option definitions
- `install.sh` - Installation script executed during container build

## How It Works

When you add a Feature to your `devcontainer.json`, [implementing tools](https://containers.dev/supporting#tools) like VS Code Dev Containers or GitHub Codespaces will:

1. Read the Feature's metadata from `devcontainer-feature.json`
2. Export the configured options as environment variables
3. Execute the `install.sh` script during container build time

Options are automatically converted to uppercase environment variables following the [option resolution rules](https://containers.dev/implementors/features/#option-resolution).

## Using These Features

### Quick Start

Add any Feature to your `.devcontainer/devcontainer.json`:

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/proxayfox/devcontainer-features/clickhouse-local:1": {}
    }
}
```

### With Custom Options

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/proxayfox/devcontainer-features/clickhouse-local:1": {
            "version": "23.8",
            "installMethod": "apt"
        }
    }
}
```

## Distribution and Publishing

### Versioning

Features are individually versioned using semantic versioning (semver) in their `devcontainer-feature.json` file. See the [Feature specification](https://containers.dev/implementors/features/#versioning) for details.

### Publishing

Features in this repository are automatically published to GitHub Container Registry (GHCR) via GitHub Actions. The workflow is triggered on push to the main branch and publishes each Feature with the namespace:

```text
ghcr.io/proxayfox/devcontainer-features/<feature-name>:<version>
```

For example:

- `ghcr.io/proxayfox/devcontainer-features/clickhouse-local:1`

### Making Features Public

By default, GHCR packages are private. To make a Feature publicly accessible:

1. Navigate to the package settings: `https://github.com/users/ProxayFox/packages/container/devcontainer-features%2F<featureName>/settings`
2. Change visibility to "public"
3. This allows the Feature to be used in any dev container without authentication

## Contributing

Contributions are welcome! To add a new Feature:

1. Create a new directory under `src/` with your feature name
2. Add a `devcontainer-feature.json` with metadata and options
3. Create an `install.sh` script with installation logic
4. Add tests under `test/<feature-name>/`
5. Submit a pull request

## Resources

- [Dev Container Features Specification](https://containers.dev/implementors/features/)
- [Feature Distribution Specification](https://containers.dev/implementors/features-distribution/)
- [VS Code Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [GitHub Codespaces](https://github.com/features/codespaces)

## License

See [LICENSE](LICENSE) for details.
