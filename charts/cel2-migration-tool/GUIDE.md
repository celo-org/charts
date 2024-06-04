# Node Migration Guide

This guide is intended to help you migrate a Celo L1 node to a Celo L2 (CEL2) node.

## Prerequisites

Before you begin, you should have the following available:

- A Celo L1 datadir to migrate. Directory must be from a full node (archive node as origin is not required). It can be used as "archive" once migrated.
- Cel2 Rollup config.json file (for well-known networks like Alfajores, Baklava, and Mainnet this will be provided)
- Cel2 L1 contract addresses (for well-known networks like Alfajores, Baklava, and Mainnet this will be provided)

## Steps

1. **Stop the L1 node**. The node we will use to migrate the data should be stopped to avoid any data corruption.
Alternatively, you can download the data from a public source if available. In case of Alfajores, go to Alfajores cluster and stop the node that will be used as datasource:

```bash
gcloud container clusters get-credentials --project celo-testnet-production --location us-west1-a alfajores
kubectl --context=gke_celo-testnet-production_us-west1-a_alfajores -n alfajores scale sts alfajores-tx-nodes --replicas 3
```

1. **Create a backup of the L1 datadir**. This process use GCP Snapshots, as it will be more time and cost-effective (compared to packing and downloading the data)

```bash
kubectl --context=gke_celo-testnet-production_us-west1-a_alfajores -n alfajores apply -f - <<EOF
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: data-alfajores-tx-nodes-3
spec:
  volumeSnapshotClassName: gce-snaptshot
  source:
    persistentVolumeClaimName: data-alfajores-tx-nodes-3
EOF
```

1. **Scale the node back to the original size**: Wait until the snapshot is created and then scale the node back to the original size.

```bash
kubectl --context=gke_celo-testnet-production_us-west1-a_alfajores -n alfajores scale sts alfajores-tx-nodes --replicas 4
```

1. **(OPTIONAL) Move the snapshot to another project**. If you want to use the snapshot in another project, you must "move" it. This is done by creating a disk from the snapshot in a different project, and then creating a new snapshot from the disk.

```bash
# Get the snapshot reference
snapshot_content=$(kubectl --context=gke_celo-testnet-production_us-west1-a_alfajores -n alfajores get volumesnapshot data-alfajores-tx-nodes-3 -o jsonpath='{.status.boundVolumeSnapshotContentName}')
snapshot_handle=$(kubectl --context=gke_celo-testnet-production_us-west1-a_alfajores -n alfajores get volumesnapshotcontent $snapshot_content -o jsonpath='{.status.snapshotHandle}')

# Create the disk in the new project
gcloud compute --project blockchaintestsglobaltestnet disks create alfajores-snapshot-move --source-snapshot $snapshot_handle --zone us-west1-b

# Create the snapshot in the new project
gcloud compute disks snapshot alfajores-snapshot-move --project=blockchaintestsglobaltestnet --zone=us-west1-b --snapshot-names=alfajores-snapshot-full

# Delete the disk
gcloud compute disks delete alfajores-snapshot-move --project=blockchaintestsglobaltestnet --zone=us-west1-b
```

1. **Import the snapshot as a VolumeSnapshot**. This will allow us to create a new PVC from the snapshot using Kubernetes. Move your kubernetes context to the disired gke cluster and run:

```bash
kubectl apply -f - <<EOF
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotContent
metadata:
  name: alfajores-snapshot-full
spec:
  deletionPolicy: Retain
  driver: pd.csi.storage.gke.io
  source:
    snapshotHandle: projects/blockchaintestsglobaltestnet/global/snapshots/alfajores-snapshot-full
  volumeSnapshotRef:
    name: alfajores-snapshot-full
    namespace: alfajores-jctest
---
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: alfajores-snapshot-full
  namespace: alfajores-jctest
spec:
  source:
    volumeSnapshotContentName: alfajores-snapshot-full
EOF

1. Create a PVC from the snapshot. This will allow us to create a new pod (or cronjob) with the data from the snapshot.

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  annotations:
    resize.topolvm.io/increase: 10Gi
    resize.topolvm.io/inodes-threshold: 5%
    resize.topolvm.io/storage_limit: 300Gi
    resize.topolvm.io/threshold: 10%
  name: alfajores-input
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 60Gi
  storageClassName: standard-rwo
  dataSource:
    name: alfajores-snapshot-full
    kind: VolumeSnapshot
    apiGroup: snapshot.storage.k8s.io
EOF
```

1. Create a PVC for the output files.

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  annotations:
    resize.topolvm.io/increase: 10Gi
    resize.topolvm.io/inodes-threshold: 5%
    resize.topolvm.io/storage_limit: 1000Gi
    resize.topolvm.io/threshold: 10%
  name: alfajores-output
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 150Gi
  storageClassName: standard-rwo
EOF
```

1. **Install the chart with the migration tool**. This chart will create a cronjob that will read the data from the PVC and migrate it to the L2 network. Check the values file to set the correct values for the migration (config and l1-contract file urls, l1 rpc endpoint, pvc names, etc.)

```bash
helm upgrade --install cel2-migration-tool ./cel2-migration-tool
```

1. **Run the migration tool**. The CronJob is configured with a schedule that never runs, so you must run it manually:

```bash
kubectl create job --from=cronjob/cel2-migration-tool manual-cel2-migration-tool
```

1. **Check the logs**. The migration tool will output logs to the pod. You can check the logs with:

```bash
kubectl get pods
kubectl logs <pod-name> download-dependencies
kubectl logs <pod-name> chain-ops
kubectl logs <pod-name> geth-load
```

1. Once the migration seems to be complete (no new logs from the `geth-load` container), connect to the L2 node and check the data.

```bash
kubectl exec -it <pod-name> -c geth-load -- /bin/sh
```

```bash
# Attach to the geth console
geth --datadir /tmp attach /output/geth.ipc
```

```bash
# Check the block number
eth.blockNumber

# Check the balance of some accounts
eth.getBalance("0x...")

# Check the number of transactions
eth.getTransactionCount("0x...")
```

1. When geth node seems to have finished to migrate the data, create a file so the pod can continue and upload the data.

```bash
touch /output/.finished
```
