# ClickHouse Local CLI (clickhouse-local)

Installs ClickHouse local CLI for SQL queries on local files

## Example Usage

```json
"features": {
    "ghcr.io/ProxayFox/devcontainer-features/clickhouse-local:1": {}
}
```

## Options

Options Id    | Description                                                      | Type   | Default Value
------------- | ---------------------------------------------------------------- | ------ | -------------
version       | ClickHouse version to install                                    | string | latest
installMethod | Installation method: 'quick' (binary) or 'apt' (package manager) | string | quick

--------------------------------------------------------------------------------

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/ProxayFox/devcontainer-features/blob/main/src/clickhouse-local/devcontainer-feature.json). Add additional notes to a `NOTES.md`._
