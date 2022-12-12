# Eksportisto monitoring

> This is intended to be temporary to assure continued monitoring for [Mento Labs](https://www.mento.org/) spinning out of cLabs.

## What is Grafana Agent?

[Grafana Agent](https://grafana.com/docs/agent/latest/) collects and forwards telemetry data to a specific Grafana stack. It supports Prometheus metrics, Loki compatible logs, and Tempo tracces.
For metric collection, the default deployment mode is a drop-in replacement for Prometheus `remote_write`. Grafana Agent acts similarly to a single-process Prometheus, doing service discovery, scraping, and remote writing. Some Prometheus features, such as querying, local storage, recording rules, and alerts are not present.

## How do we use it?

We use a Grafana Agent deployed to the [GKE Mainnet cluster in the GCP project `celo-testnet-production`](https://github.com/celo-org/infrastructure/tree/master/terraform/root-modules/gcp/mainnet-gke) to scrape [Eksportisto](https://github.com/celo-org/eksportisto) metrics, which give insights into the economics on the Celo blockchain. These metrics are needed and used by Mento Labs for alerting on Oracles.
The metrics are sent to <https://clabsmento.grafana.net/>, a dedicated stack set up for Mento while cLabs hosts some of the workloads they are tending to.

See [Mento tech spin-out](https://docs.google.com/document/d/1g-2JvsgZk2cjSUO92s5IBUcvBfyDKSTgKKgkp9TOWVI/edit#) for more background information.

## Deployment

See instructions at <https://grafana.com/docs/grafana-cloud/kubernetes-monitoring/other-methods/k8s-agent-metrics>.
