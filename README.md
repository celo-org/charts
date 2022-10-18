# charts

This is a collection of Helm charts for Kubernetes. The charts are used by cLabs to deploy and manage our infrastructure, and can be used by anyone else to manage their own infrastructure, specifically for Celo Network related resources.

The charts are published to the OCI registry at `oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci`. OCI registries are a new standard for container registries, and are supported by Helm 3+, and enabled by default in Helm 3.8.0+.

## List of charts

- [celo-fullnode](./charts/celo-fullnode/README.md) - Deploy Celo Network nodes with different configurations (archive nodes, light nodes, etc.)
- [common](./charts/common/README.md) - Common library with Celo validators and full nodes helper functions and templates

## Helm charts best practices

A list of best practices when writing Helm charts can be found in the [`docs/` folder](docs/helm-best-practices.md).
