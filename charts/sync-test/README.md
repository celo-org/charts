# sync-test

Umbrella chart for running OP-Stack sync tests. Deploys **op-geth** and **op-node** as subcharts with a single `helm install` command.

## Prerequisites

- Kubernetes cluster
- Helm 3
- For consensus/execution modes on mainnet: a VolumeSnapshot to restore from (not needed for sepolia)

Build subchart dependencies before first use:

```bash
helm dependency build
```

## Networks

Network-specific configuration (bootnodes, L1 RPCs, genesis/rollup URLs, etc.) is provided via files in `networks/`:

| Network | File | Snapshot needed? |
|---------|------|-----------------|
| Celo mainnet | `networks/mainnet.yaml` | Yes (consensus/execution) |
| Celo sepolia | `networks/sepolia.yaml` | No (started as L2) |

To add a new network, create a new file in `networks/` with the required values. See `networks/mainnet.yaml` for reference.

## Sync Modes

| Mode | Preset | Description |
|------|--------|-------------|
| **Consensus** | `presets/consensus.yaml` | Restores from snapshot, derives blocks from L1 |
| **Execution** | `presets/execution.yaml` | Restores from snapshot, syncs blocks via p2p |
| **Snap** | `presets/snap.yaml` | Fresh start with genesis init, syncs state via snap protocol |

## Required Parameters

| Parameter | Description |
|-----------|-------------|
| `op-geth.image.repository` | op-geth container image repository |
| `op-geth.image.tag` | op-geth container image tag |
| `op-node.image.repository` | op-node container image repository |
| `op-node.image.tag` | op-node container image tag |
| `op-geth.secrets.nodeKey.value` | op-geth p2p private key (unique per deployment) |
| `op-node.secrets.p2pKeys.value` | op-node p2p private key (unique per deployment) |
| `snapshot.volumeSnapshotName` | VolumeSnapshot name (consensus/execution only) |

## Usage

### Deploy all sync modes at once

The `run-sync-tests.sh` script installs all three sync modes (snap, execution, consensus) in a single command. It generates random p2p keys for each release automatically.

```bash
./run-sync-tests.sh <network> [options]
```

| Option | Description |
|--------|-------------|
| `--geth-image <repo:tag>` | op-geth container image (required) |
| `--node-image <repo:tag>` | op-node container image (required) |
| `--snapshot <name>` | VolumeSnapshot name (required for consensus/execution on mainnet) |
| `-n, --namespace <ns>` | Kubernetes namespace |
| `--prefix <prefix>` | Release name prefix (default: network name) |
| `--` | Pass remaining arguments to `helm install` |

Example:

```bash
./run-sync-tests.sh mainnet \
  -n mainnet-sync-test \
  --geth-image us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-geth:abc123 \
  --node-image us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-node:abc123 \
  --snapshot mainnet-cel2-migrated
```

This creates three releases: `mainnet-snap`, `mainnet-execution`, and `mainnet-consensus`.

### Deploy individual sync modes

All commands use two `-f` flags: first the sync mode preset, then the network. The network file is applied last so it can override preset defaults (e.g. sepolia disables snapshots for all modes).

#### Consensus sync

```bash
helm install cr16-consensus . \
  -n <namespace> \
  -f presets/consensus.yaml \
  -f networks/mainnet.yaml \
  --set snapshot.volumeSnapshotName=mainnet-cel2-migrated \
  --set op-geth.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-geth \
  --set op-geth.image.tag=<commit-sha> \
  --set op-node.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-node \
  --set op-node.image.tag=<commit-sha> \
  --set op-geth.secrets.nodeKey.value=0x$(openssl rand -hex 32) \
  --set op-node.secrets.p2pKeys.value=0x$(openssl rand -hex 32)
```

#### Execution sync

```bash
helm install cr16-execution . \
  -n <namespace> \
  -f presets/execution.yaml \
  -f networks/mainnet.yaml \
  --set snapshot.volumeSnapshotName=mainnet-cel2-migrated \
  --set op-geth.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-geth \
  --set op-geth.image.tag=<commit-sha> \
  --set op-node.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-node \
  --set op-node.image.tag=<commit-sha> \
  --set op-geth.secrets.nodeKey.value=0x$(openssl rand -hex 32) \
  --set op-node.secrets.p2pKeys.value=0x$(openssl rand -hex 32)
```

#### Snap sync

```bash
helm install cr16-snap . \
  -n <namespace> \
  -f presets/snap.yaml \
  -f networks/mainnet.yaml \
  --set op-geth.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-geth \
  --set op-geth.image.tag=<commit-sha> \
  --set op-node.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-node \
  --set op-node.image.tag=<commit-sha> \
  --set op-geth.secrets.nodeKey.value=0x$(openssl rand -hex 32) \
  --set op-node.secrets.p2pKeys.value=0x$(openssl rand -hex 32)
```

## Monitoring

```bash
# Pod status
kubectl get pods -l app.kubernetes.io/instance=<release-name> -n <namespace>

# op-geth logs
kubectl logs -f <release-name>-op-geth-0 -c op-geth -n <namespace>

# op-node logs
kubectl logs -f <release-name>-op-node-0 -c op-node -n <namespace>
```

## Upgrading releases

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

## Cleanup

```bash
helm uninstall <release-name> -n <namespace>
```

PVCs have `helm.sh/resource-policy: keep` and are **not deleted** by
`helm uninstall`. You must delete them manually:

```bash
kubectl delete pvc data-<release-name>-op-geth-0 data-<release-name>-op-node-0 -n <namespace>
```

## Architecture

The chart deploys:

- **op-geth StatefulSet** (1 replica) -- execution engine
- **op-node StatefulSet** (1 replica) -- consensus engine
- **PVCs** -- created by the chart (not StatefulSet volumeClaimTemplates) with
  `helm.sh/resource-policy: keep` to survive upgrades and uninstalls
  - op-geth: restored from VolumeSnapshot (consensus/execution) or fresh (snap)
  - op-node: small disk for rollup config and safe head data

The op-node L2 URL is automatically derived from the release name (`http://<release>-op-geth-authrpc-0:8551`), so cross-component naming is handled by the chart.
