# sync-test

Umbrella chart for running OP-Stack sync tests. Deploys **op-geth** and **op-node** as subcharts.

Each `helm install` deploys one sync mode (snap, execution, or consensus) for one network (mainnet or sepolia). To exercise multiple modes against the same image, run `helm install` once per mode with a different release name — see [Running all three modes](#running-all-three-modes-for-a-network) below.

## Architecture

The chart deploys:

- **op-geth StatefulSet** (1 replica) — execution engine
- **op-node StatefulSet** (1 replica) — consensus engine
- **PVCs** — created by the chart (not StatefulSet `volumeClaimTemplates`) with
  `helm.sh/resource-policy: keep` to survive upgrades and uninstalls
  - op-geth: restored from VolumeSnapshot (consensus/execution) or fresh (snap)
  - op-node: small disk for rollup config and safe head data

The op-node L2 URL is automatically derived from the release name (`http://<release>-op-geth-authrpc-0:8551`), so cross-component naming is handled by the chart.

## Prerequisites

- Kubernetes cluster
- Helm 3
- For consensus/execution modes on mainnet: a `VolumeSnapshot` to restore from (sepolia does not need one — it started life as an L2)

Build subchart dependencies before first use:

```bash
helm dependency build
```

## Helm release naming

It is assumed that synctests will be run in groups of 3, one for each of the consensus, execution and snap syncmodes. The dashboard expects names of the form `<prefix>-consensus`, `<prefix>-execution` & `<prefix>-snap`. If you diverge from this convention then the dashboard will likely not work as expected.

## Networks

Network-specific configuration (bootnodes, L1 RPCs, genesis/rollup URLs, etc.) is provided via files in `networks/`:

| Network | File | Snapshot needed? |
|---------|------|-----------------|
| Celo mainnet | `networks/mainnet.yaml` | Yes (consensus/execution) |
| Celo sepolia | `networks/sepolia.yaml` | No (started as L2) |

To add a new network, create a new file in `networks/`. See `networks/mainnet.yaml` for reference.

## Sync modes

| Mode | Preset | Description |
|------|--------|-------------|
| **Consensus** | `presets/consensus.yaml` | Restores from snapshot, derives blocks from L1 |
| **Execution** | `presets/execution.yaml` | Restores from snapshot, syncs blocks via p2p |
| **Snap** | `presets/snap.yaml` | Fresh start with genesis init, syncs state via snap protocol |

## Required values

Every install must provide:

| Value | Notes |
|-------|-------|
| `op-geth.secrets.nodeKey.value` | 32-byte hex p2p private key. Generate with `0x$(openssl rand -hex 32)` |
| `op-node.secrets.p2pKeys.value` | 32-byte hex p2p private key. Generate with `0x$(openssl rand -hex 32)` |
| `snapshot.volumeSnapshotName` | Required **only when `snapshot.enabled: true`**, which is the default for the `consensus` and `execution` presets. The `snap` preset and `networks/sepolia.yaml` both set `snapshot.enabled: false`, so no snapshot is needed in those cases. The chart fails at template time with a clear `required` error if a snapshot is needed but missing — so an attempt to run a mainnet consensus/execution sync without `--set snapshot.volumeSnapshotName=...` will fail loudly. |

Container images default to current production releases (see `values.yaml`). To test a custom build, override the tag (and optionally the repository):

```bash
--set op-geth.image.tag=<commit-sha>
--set op-node.image.tag=<commit-sha>
# Optionally, if your image is in a different registry:
--set op-geth.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-geth
--set op-node.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-node
```

## Example usage

All commands use two `-f` flags: first the sync mode preset, then the network file. The network file is applied last so it can override preset defaults (e.g. sepolia disables snapshots for all modes).

Commands below assume you are in the `sync-test` directory.

Note: The namespaces `mainnet-sync-test` and `sepolia-sync-test` exist on the
blockchain global testnet (AKA cel2 testnet) cluster, where historically these
tests were being run. The `mainnet-sync-test` namespace also contains a
volumesnapshot called `mainnet-cel2-migrated` which can be used for mainnet
syncs.

### Consensus sync (mainnet)

```bash
helm install v2.2.2-consensus . \
  -n mainnet-sync-test \
  -f presets/consensus.yaml \
  -f networks/mainnet.yaml \
  --set snapshot.volumeSnapshotName=mainnet-cel2-migrated \
  --set op-geth.secrets.nodeKey.value=0x$(openssl rand -hex 32) \
  --set op-node.secrets.p2pKeys.value=0x$(openssl rand -hex 32)
```

### Execution sync (mainnet)

```bash
helm install celo-reabse-16-execution . \
  -n mainnet-sync-test \
  -f presets/execution.yaml \
  -f networks/mainnet.yaml \
  --set snapshot.volumeSnapshotName=mainnet-cel2-migrated \
  --set op-geth.secrets.nodeKey.value=0x$(openssl rand -hex 32) \
  --set op-node.secrets.p2pKeys.value=0x$(openssl rand -hex 32)
```

### Snap sync (mainnet)

```bash
helm install celo-reabse-16-snap . \
  -n mainnet-sync-test \
  -f presets/snap.yaml \
  -f networks/mainnet.yaml \
  --set op-geth.secrets.nodeKey.value=0x$(openssl rand -hex 32) \
  --set op-node.secrets.p2pKeys.value=0x$(openssl rand -hex 32)
```

(No snapshot needed — `presets/snap.yaml` sets `snapshot.enabled: false`.)

### Sepolia (any mode)

```bash
helm install sepolia-consensus . \
  -n sepolia-sync-test \
  -f presets/consensus.yaml \
  -f networks/sepolia.yaml \
  --set op-geth.secrets.nodeKey.value=0x$(openssl rand -hex 32) \
  --set op-node.secrets.p2pKeys.value=0x$(openssl rand -hex 32)
```

(No snapshot needed — `networks/sepolia.yaml` overrides `snapshot.enabled: false` for all modes.)

## Monitoring

```bash
# Pod status
kubectl get pods -l app.kubernetes.io/instance=<release-name> -n <namespace>

# op-geth logs
kubectl logs -f <release-name>-op-geth-0 -c op-geth -n <namespace>

# op-node logs
kubectl logs -f <release-name>-op-node-0 -c op-node -n <namespace>
```

### Grafana dashboard

A pre-built Grafana dashboard is included in `dashboard.json`. It provides sync
percentage gauges, chain head timeseries, peer counts, CPU/memory usage, and log
panels for all three sync modes.

To import it:

1. Open Grafana and go to **Dashboards > New > Import**
2. Click **Upload dashboard JSON file** and select `dashboard.json` (or paste its contents)
3. Click **Import**

The dashboard uses two template variables at the top:

| Variable | Description | Default |
|----------|-------------|---------|
| `helm_release_prefix` | The release name prefix used during install (e.g. `celo-reabse-16`) | `celo-reabse-16` |
| `namespace` | Kubernetes namespace where the sync tests are running | `mainnet-sync-test` |

The dashboard expects Prometheus and Loki datasources to be configured in
Grafana. You may need to update the datasource UIDs in the JSON if yours differ
from the defaults.

## Upgrading releases

For example to use new image tags:

```bash
helm upgrade <release-name> . \
  -n <namespace> --reuse-values \
  --set op-geth.image.tag=<new-tag> \
  --set op-node.image.tag=<new-tag>
```

### How PVCs are protected during upgrades

Topolvm auto-resizes PVCs beyond the size in the chart values. If Helm tries to
patch a PVC with the original (smaller) size, the upgrade fails. To avoid this,
the PVC templates use Helm's `lookup` function to skip rendering when the PVC
already exists. This means Helm won't try to patch it.

However, when a resource disappears from the rendered templates, Helm treats it
as "removed from the chart" and deletes it. The `helm.sh/resource-policy: keep`
annotation on the PVC prevents this — it tells Helm to leave the resource alone
even when it's no longer in the rendered output. The chart sets this annotation
on PVCs at creation time.

This means that the PVCs remain after charts have been uninstalled and require
a manual cleanup step.

## Shutdown

```bash
helm uninstall <release-name> -n <namespace>
```

PVCs have `helm.sh/resource-policy: keep` and are **not deleted** by
`helm uninstall`. You must delete them manually:

```bash
kubectl delete pvc data-<release-name>-op-geth-0 data-<release-name>-op-node-0 -n <namespace>
```
