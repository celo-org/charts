# sync-test

Umbrella chart for running Celo L2 sync tests. Deploys **op-geth** and **op-node** as subcharts with a single `helm install` command.

Uses a shared eigenda-proxy instance (`http://eigenda-proxy-api:4242`) which is not deployed by this chart.

## Prerequisites

- Kubernetes cluster
- Helm 3
- For consensus/execution modes: a VolumeSnapshot to restore from

Build subchart dependencies before first use:

```bash
helm dependency build
```

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

### Consensus sync

```bash
helm install cr16-consensus . \
  -n <namespace> \
  -f presets/consensus.yaml \
  --set snapshot.volumeSnapshotName=mainnet-cel2-migrated \
  --set op-geth.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-geth \
  --set op-geth.image.tag=<commit-sha> \
  --set op-node.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-node \
  --set op-node.image.tag=<commit-sha> \
  --set op-geth.secrets.nodeKey.value=0x$(openssl rand -hex 32) \
  --set op-node.secrets.p2pKeys.value=0x$(openssl rand -hex 32)
```

### Execution sync

```bash
helm install cr16-execution . \
  -n <namespace> \
  -f presets/execution.yaml \
  --set snapshot.volumeSnapshotName=mainnet-cel2-migrated \
  --set op-geth.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-geth \
  --set op-geth.image.tag=<commit-sha> \
  --set op-node.image.repository=us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-node \
  --set op-node.image.tag=<commit-sha> \
  --set op-geth.secrets.nodeKey.value=0x$(openssl rand -hex 32) \
  --set op-node.secrets.p2pKeys.value=0x$(openssl rand -hex 32)
```

### Snap sync

```bash
helm install cr16-snap . \
  -n <namespace> \
  -f presets/snap.yaml \
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

## Cleanup

All PVCs are Helm-managed and deleted automatically on uninstall:

```bash
helm uninstall <release-name> -n <namespace>
```

## Architecture

The chart deploys:

- **op-geth StatefulSet** (1 replica) -- execution engine
- **op-node StatefulSet** (1 replica) -- consensus engine
- **PVCs** -- Helm-managed for automatic cleanup
  - op-geth: restored from VolumeSnapshot (consensus/execution) or fresh (snap)
  - op-node: small disk for rollup config and safe head data

The op-node L2 URL is automatically derived from the release name (`http://<release>-op-geth-authrpc-0:8551`), so cross-component naming is handled by the chart.
