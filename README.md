# charts

This is a collection of Helm charts for Kubernetes. The charts are used by cLabs to deploy and manage our infrastructure, and can be used by anyone else to manage their own infrastructure, specifically for Celo Network related resources.

The charts are published to the OCI registry at `oci://us-west1-docker.pkg.dev/devopsre/clabs-public-oci`. OCI registries are a new standard for container registries, and are supported by Helm 3+, and enabled by default in Helm 3.8.0+.

## List of charts

- [akeyless-gadmin-producer](./charts/akeyless-gadmin-producer/README.md): Deploys Akeyless Google Admin producer.
- [akeyless-gcp-producer](./charts/akeyless-gcp-producer/README.md): Deploys Akeyless GCP custom producer.
- [akeyless-grafana-access-policy-producer](./charts/akeyless-grafana-access-policy-producer/README.md): Deploys Akeyless Grafana access policy producer.
- [akeyless-grafana-access-policy-rotated](./charts/akeyless-grafana-access-policy-rotated/README.md): Deploys Akeyless Grafana access policy rotator.
- [akeyless-grafana-sa-producer](./charts/akeyless-grafana-sa-producer/README.md): Deploys Akeyless Grafana Service Account producer.
- [akeyless-okta-producer](./charts/akeyless-okta-producer/README.md): Deploys Akeyless Okta custom producer.
- [blockscout](./charts/blockscout/README.md): Helm chart for deploying the Blockscout-based Celo Explorer. 
- [celo-fullnode-backups](./charts/celo-fullnode-backups/README.md): Automate Celo blockchain chain backups using PVC snapshots.
- [celo-fullnode](./charts/celo-fullnode/README.md): Deploy Celo Network nodes with different configurations (archive nodes, light nodes, etc.)
- [clean-pvcs](./charts/clean-pvcs/README.md): Delete PVCs that are not mounted and have not been recently created
- [common](./charts/common/README.md): Common library with Celo validators and full nodes helper functions and templates
- [daily-chain-backups](./charts/daily-chain-backup/README.md): Helm chart for a cron job taking periodic chain backups and uploading them to GCS.
- [image-annotator-webhook](./charts/image-annotator-webhook/README.md): Kubernetes mutating webhook that annotates Kubernetes objects with the container images used in the resource.
- [k8s-digester](./charts/k8s-digester/README.md): Helm chart for the k8s digester translating image tags to SHAs. 
- [kong-celo-fullnode](./charts/kong-celo-fullnode/README.md): Chart wrapper over celo-fullnode chart to adapt to Forno. It requires a Kong controller, kong ingressClass and kong CRDs installed in the cluster, and creates the Kong consumers, plugins and rate limits.
- [load-test](./charts/load-test/README.md): Helm chart to run a load test for a Celo Network.
- [odis-combiner](./charts/odis-combiner/README.md): Helm chart for the Celo ODIS combiners.
- [odis-loadtest](./charts/odis-loadtest/README.md): Helm chart for deploying the Celo ODIS load tests in GKE.
- [odis-signer](./charts/odis-signer/README.md): Helm chart for the Celo ODIS signers.
- [rosetta](./charts/rosetta/README.md): Helm chart for the [Celo Rosetta client](https://github.com/celo-org/rosetta).
- [safe-client-gateway](./charts/safe-client-gateway/README.md): Helm chart for deploying Celo Safe Client Gateway.
- [safe-config-service](./charts/safe-config-service/README.md): Helm chart for deploying Celo Safe Config Service.
- [safe-transaction-service](./charts/safe-transaction-service/README.md): Helm chart for deploying Celo Safe Transaction Service.
- [testnet](./charts/testnet/README.md): Helm chart for deploying an ephemeral Celo testnet.
- [ultragreen-dashboard](./charts/ultragreen-dashboard/README.md): Helm chart for deploying the [Celo Ultragreen](https://www.ultragreen.money/) dashboard.

## Helm charts best practices

A list of best practices when writing Helm charts can be found in the [`docs/` folder](docs/helm-best-practices.md).

## CI

This repo uses GitHub Actions to automatically perform the following:

- On Pull Request using the [`helm_test.yaml` workflow](./.github/workflows/helm_test.yml): check that chart version is bumped in `Chart.yaml`, lint, template, install/delete and test the modified charts in a Kind cluster. If the previous checks are OK, it will autogenerate a README for the chart using [helm-docs](https://github.com/norwoodj/helm-docs).
- On push to `main` using the [`helm_release` workflow](./.github/workflows/helm_release.yml): publish the new Helm release (version in `Chart.yaml`) in OCI format to Artifact Registry (project `devops`, URL `oci://us-west1-docker.pkg.dev/devopsre/clabs-public-oci`).

### Technologies

- For checking the `Chart.yaml` version, linting, installing/deleting and testing a chart the [chart-testing Action](https://github.com/helm/chart-testing-action) is used (based on the [helm/chart-testing](https://github.com/helm/chart-testing) CLI tool).
- For spinning a Kind cluster the [Kind Action](https://github.com/helm/kind-action) is used (based on [kind tool](https://kind.sigs.k8s.io/)).
- For autogenerating the chart README, a custom workflow based on [helm-docs](https://github.com/norwoodj/helm-docs) is used.
- For publishing a new chart release to Artifact Registry (project `devops`, URL `oci://us-west1-docker.pkg.dev/devopsre/clabs-public-oci`), a custom workflow is used.

## Installing a chart with custom values

The [chart-testing Action](https://github.com/helm/chart-testing-action) allows testing the installation/deletion of a chart using a custom `values.yaml` file. In order to do that, the action allows for a chart to have multiple custom values files matching the glob pattern `*-values.yaml` in a directory named `ci` in the root of the chart's directory. The chart is installed and tested for each of these files.

If no custom values file is present, the chart is installed and tested with defaults.
