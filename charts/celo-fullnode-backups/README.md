# celo-fullnode-backups

Automate celo-blockchain chain backups using PVC snapshots

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.6.0](https://img.shields.io/badge/AppVersion-1.6.0-informational?style=flat-square)

- [celo-fullnode-backups](#celo-fullnode-backups)
  - [Chart requirements](#chart-requirements)
  - [Important notes](#important-notes)
  - [Chart releases](#chart-releases)
  - [Basic chart operation](#basic-chart-operation)
  - [Values](#values)

## Chart requirements

- Tested with Kubernetes 1.23
- Tested with Helm v3.9.4
- CSI Driver support for snapshots

## Important notes

- This chart can be used to deploy a CronJob and schedeuled backups of a Celo fullnode. Backups are volumeSnapshots.
- Only tested with GKE. Feauture `Compute Engine persistent disk CSI Driver` must be enabled. See [here](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/gce-pd-csi-driver) for more information.
- It may work with other cloud providers / CSI drivers as far as they support PVC snapshots, but this is not tested.
- The chart can copy the snapshot reference from the origin namespace to a target namespace. This is useful because it is not possible to reference an snapshot from a different namespace. The target namespace must exist before the backup is executed. The snapshot in the cloud is not duplicated, only the reference in Kubernetes is duplicated.

## Chart releases

Chart is released to oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci/celo-fullnode-backups repository automatically every commit to `main` branch.
Just remind yourself to bump the version of the chart in the [Chart.yaml](./Chart.yaml) file.
This pricess is configured using GitHub Actions in the [helm_release.yml](../../.github/workflows/helm_release.yml)
and [helm_lint.yml](../../.github/workflows/helm_lint.yml) files.

## Basic chart operation

To install/manage a release named `celo-mainnet-fullnode` connected to `mainnet` in namespace `celo` using `values-mainnet-node.yaml` custom values:

```bash
# Select the chart release to use
CHART_RELEASE="oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci/celo-fullnode-backups --version=0.3.0" # Use remote chart and specific version
CHART_RELEASE="./" # Use this local folder

# (Only for local chart) Sync helm dependencies
helm dependency update

# (Optional) Render the chart template to check the templates
helm template celo-mainnet-fullnode --create-namespace -f values-mainnet-node.yaml --namespace=celo --output-dir=/tmp "$CHART_RELEASE"

# Installing the chart
helm install celo-mainnet-fullnode --create-namespace -f values-mainnet-node.yaml --namespace=celo "$CHART_RELEASE"

# (Optional) Check a diff when upgrading the chart
# Using https://github.com/databus23/helm-diff
helm diff -C5 upgrade celo-mainnet-fullnode -f values-mainnet-node.yaml --namespace=celo "$CHART_RELEASE"

# Upgrade the chart
helm upgrade celo-mainnet-fullnode -f values-mainnet-node.yaml --namespace=celo "$CHART_RELEASE"
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| gemini | object | `{"enabled":false}` | Source: [FairwindsOps/gemini](https://github.com/FairwindsOps/gemini) |
| geth.additional_flags | string | `""` | Extra flags to pass to celo-blockchain |
| geth.gcmode | string | `"full"` | gcmode for celo-blockchain. Possible values are `full` and `archive` |
| geth.persistence.size | string | `"100Gi"` | Size of the persistent volume claim for the celo-blockchain statefulset. It will be used as the source for the snapshot (so snapshot size) |
| geth.persistence.storageClassName | string | `"premium-rwo"` | Storage class for the persistent volume claim for the celo-blockchain statefulset. |
| geth.resources | object | `{"limits":{},"requests":{"cpu":"3","memory":"8Gi"}}` | resources for the celo-blockchain statefulset |
| snapshot.copy_process.enabled | bool | `true` |  |
| snapshot.copy_process.namespace_copy_to | string | `"rc1"` |  |
| snapshot.copy_process.volumeSnapshot_name_copy_to | string | `"forno-snapshot"` | Name for the volumeSnapshot and volumeSnapshotContent that the "move" process will create |
| snapshot.move_schedule | string | `"10/20 * * * *"` |  |
| snapshot.schedule[0].every | string | `"20 minutes"` |  |
| snapshot.schedule[0].keep | int | `2` |  |
| snapshot.schedule[1].every | string | `"1 days"` |  |
| snapshot.schedule[1].keep | int | `1` |  |
| snapshot.snapshot_schedule[0].every | string | `"20 minutes"` |  |
| snapshot.snapshot_schedule[0].keep | int | `2` |  |
| snapshot.snapshot_schedule[1].every | string | `"1 days"` |  |
| snapshot.snapshot_schedule[1].keep | int | `1` |  |
| snapshot.sync_schedule | string | `"0/20 * * * *"` |  |
| snapshot.volumeSnapshotClassName | string | `"gce-snaptshot"` | VolumeSnapshotClassName. Requires [gce-pd-csi-driver](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/gce-pd-csi-driver) to be installed. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0). To regenerate run `helm-docs` command at this folder.
