# charts

This is a collection of Helm charts for Kubernetes. The charts are used by cLabs to deploy and manage our infrastructure, and can be used by anyone else to manage their own infrastructure, specifically for Celo Network related resources.

The charts are published to the OCI registry at `oci://us-west1-docker.pkg.dev/devopsre/clabs-public-oci`. OCI registries are a new standard for container registries, and are supported by Helm 3+, and enabled by default in Helm 3.8.0+.

## List of charts

- [accounts-exporter](./charts/accounts-exporter/README.md) - Exports ethereum wallet balances to Prometheus.
- [akeyless-gadmin-producer](./charts/akeyless-gadmin-producer/README.md) - Deploys Akeyless Google Admin producer.
- [akeyless-gcp-producer](./charts/akeyless-gcp-producer/README.md) - Deploys Akeyless GCP custom producer.
- [akeyless-grafana-access-policy-producer](./charts/akeyless-grafana-access-policy-producer/README.md) - Helm Chart for Grafana Access Policy Producer
- [akeyless-grafana-access-policy-rotated](./charts/akeyless-grafana-access-policy-rotated/README.md) - Deploys Akeyless Grafana access policy rotator.
- [akeyless-grafana-sa-producer](./charts/akeyless-grafana-sa-producer/README.md) - Deploys Akeyless Grafana Service Account producer.
- [akeyless-okta-producer](./charts/akeyless-okta-producer/README.md) - Deploys Akeyless Okta custom producer.
- [attestation-bot](./charts/attestation-bot/README.md) - Chart which is used to run attestations
- [blockscout](./charts/blockscout/README.md) - Helm chart for deploying the Blockscout-based Celo Explorer.
- [cel2-migration-tool](./charts/cel2-migration-tool/README.md) - Node migration tool for Cel2 network
- [celo-fullnode](./charts/celo-fullnode/README.md) - Helm chart for deploying a Celo fullnode. More info at https://docs.celo.org
- [celo-fullnode-backups](./charts/celo-fullnode-backups/README.md) - Automate celo-blockchain chain backups using PVC snapshots
- [celostats](./charts/celostats/README.md) - Chart which is used to deploy a celostats setup for a celo testnet
- [clean-pvcs](./charts/clean-pvcs/README.md) - Delete PVCs not mounted for some time
- [common](./charts/common/README.md) - Helm chart with helper templates and functions for Celo nodes. Import into your chart with `dependencies` and use the templates and functions
- [daily-chain-backup](./charts/daily-chain-backup/README.md) - A Helm chart for deploying cron job to periodically run chain backups and upload to GCS
- [eigenda-proxy](./charts/eigenda-proxy/README.md) - Helm chart deploying Layr-Labs eigenda-proxy
- [image-annotator-webhook](./charts/image-annotator-webhook/README.md) - Deploys a kubernetes webhook to mutate podSpecs to include container images as annotations
- [k8s-digester](./charts/k8s-digester/README.md) - K8S Digester translates images tags to shas
- [kong-celo-fullnode](./charts/kong-celo-fullnode/README.md) - Chart wrapper over celo-fullnode chart to adapt to Forno. It requires a Kong controller, kong ingressClass and kong crds installed in the cluster, and creates the Kong consumers, plugins and rate limits.
- [konga](./charts/konga/README.md) - Chart which is used to run konga for Kong ingress
- [llama-web3-proxy](./charts/llama-web3-proxy/README.md) - Deploys llama-web3-proxy for aggregating blockchain RPC providers.
- [load-test](./charts/load-test/README.md) - Chart which is used to run load test for a Celo Network
- [nethermind](./charts/nethermind/README.md) - .NET Core Ethereum client
- [odis-combiner](./charts/odis-combiner/README.md) - Helm chart for deploying Celo ODIS signer in AKS
- [odis-loadtest](./charts/odis-loadtest/README.md) - Helm chart for deploying Celo ODIS load tests in GKE
- [odis-signer](./charts/odis-signer/README.md) - Helm chart for deploying Celo ODIS signer
- [op-batcher](./charts/op-batcher/README.md) - Celo implementation for op-batcher client (Optimism Rollup)
- [op-bootnode](./charts/op-bootnode/README.md) - Celo implementation for op-bootnode (Optimism Rollup)
- [op-geth](./charts/op-geth/README.md) - Celo implementation for op-geth execution engine (Optimism Rollup)
- [op-node](./charts/op-node/README.md) - Celo implementation for op-node consensus engine (Optimism Rollup)
- [op-proposer](./charts/op-proposer/README.md) - Celo implementation for op-proposer client (Optimism Rollup)
- [op-proxyd](./charts/op-proxyd/README.md) - Celo implementation for OP proxyd
- [op-signer-service](./charts/op-signer-service/README.md) - A Helm chart for OP signer service
- [op-tx-overload](./charts/op-tx-overload/README.md) - Generate load on Optimism Bedrock using transactions with random calldata.
- [op-ufm](./charts/op-ufm/README.md) - A Helm chart for OP User Facing Monitoring
- [optics-keymaster](./charts/optics-keymaster/README.md) - Optics Keymaster
- [prysm](./charts/prysm/README.md) - Go implementation of Ethereum proof of stake.
- [rosetta](./charts/rosetta/README.md) - Rosetta Client for Celo Networks
- [safe-client-gateway](./charts/safe-client-gateway/README.md) - Helm chart for deploying Celo Safe Client Gateway
- [safe-config-service](./charts/safe-config-service/README.md) - Helm chart for deploying Celo Safe Config Service
- [safe-transaction-service](./charts/safe-transaction-service/README.md) - Helm chart for deploying Celo Safe Transaction Service
- [socket-exporter](./charts/socket-exporter/README.md) - A Helm chart for socket-exporter
- [team-trigger-workflow](./charts/team-trigger-workflow/README.md) - A Helm chart to run team-trigger-workflow at cLabs
- [testnet](./charts/testnet/README.md) - Private Celo network Helm chart for Kubernetes
- [ultragreen-dashboard](./charts/ultragreen-dashboard/README.md) - Celo Ultragreed Dashboard

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
