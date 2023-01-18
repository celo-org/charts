# charts

This is a collection of Helm charts for Kubernetes. The charts are used by cLabs to deploy and manage our infrastructure, and can be used by anyone else to manage their own infrastructure, specifically for Celo Network related resources.

The charts are published to the OCI registry at `oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci`. OCI registries are a new standard for container registries, and are supported by Helm 3+, and enabled by default in Helm 3.8.0+.

## List of charts

- [akeyless-gcp-producer](./charts/akeyless-gcp-producer/README.md): Deploys Akeyless GCP custom producer.
- [akeyless-grafana-cloud-producer](./charts/akeyless-grafana-cloud-producer/README.md): Deploys Akeyless Grafana Cloud custom producer.
- [akeyless-okta-producer](./charts/akeyless-okta-producer/README.md): Deploys Akeyless Okta custom producer.
- [celo-fullnode](./charts/celo-fullnode/README.md): Deploy Celo Network nodes with different configurations (archive nodes, light nodes, etc.)
- [celo-fullnode-backups](./charts/celo-fullnode-backups/README.md): Automate celo-blockchain chain backups using PVC snapshots
- [clean-pvcs](./charts/clean-pvcs/README.md): Delete PVCs that are not mounted and have not been recently created
- [common](./charts/common/README.md): Common library with Celo validators and full nodes helper functions and templates
- [eksportisto-monitoring](./charts/eksportisto-monitoring/README.md): A Grafana Agent deployment to send Eksportisto data to the Mento Grafana Cloud instance.
- [kong-celo-fullnode](./charts/kong-celo-fullnode/README.md): Chart wrapper over celo-fullnode chart to adapt to Forno. It requires a Kong controller, kong ingressClass and kong crds installed in the cluster, and creates the Kong consumers, plugins and rate limits.
- [celo-safe-client-gateway](./charts/safe-client-gateway/README.md): Helm chart for deploying Celo Safe Client Gateway.
- [celo-safe-config-service](./charts/safe-config-service/README.md): Helm chart for deploying Celo Safe Config Service.
- [celo-safe-transaction-service](./charts/safe-transaction-service/README.md): Helm chart for deploying Celo Safe Transaction Service.

## Helm charts best practices

A list of best practices when writing Helm charts can be found in the [`docs/` folder](docs/helm-best-practices.md).
