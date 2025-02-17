# celo-fullnode

Helm chart for deploying a Celo fullnode. More info at https://docs.celo.org

![Version: 0.7.6](https://img.shields.io/badge/Version-0.7.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.8.4](https://img.shields.io/badge/AppVersion-1.8.4-informational?style=flat-square)

- [celo-fullnode](#celo-fullnode)
  - [Chart requirements](#chart-requirements)
  - [Chart releases](#chart-releases)
  - [More relevant values](#more-relevant-values)
  - [Ingress setup](#ingress-setup)
  - [Basic chart operation](#basic-chart-operation)
  - [Values](#values)

## Chart requirements

- Tested with Kubernetes 1.23
- Tested with Helm v3.9.4

## Chart releases

Chart is released to oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci/celo-fullnode repository automatically every commit to `main` branch.
Just remind yourself to bump the version of the chart in the [Chart.yaml](./Chart.yaml) file.
This process is configured using GitHub Actions in the [helm_release.yml](../../.github/workflows/helm_release.yml)
and [helm_test.yml](../../.github/workflows/helm_test.yml) files.

## Relevant values

TODO

## Basic chart operation

To install/manage a release named `celo-mainnet-fullnode` connected to `mainnet` in namespace `celo` using `values-mainnet-node.yaml` custom values:

```bash
# Select the chart release to use
CHART_RELEASE="oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci/celo-fullnode --version=0.7.6" # Use remote chart and specific version
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
| aws | bool | `false` | Enables aws specific settings |
| azure | bool | `false` | Enables azure specific settings |
| deletePodCronJob | object | `{"enabled":false,"extraFlagsPod":"","extraFlagsPvc":"","extraSkippedPvc":[1,2,3],"podIndex":0,"schedule":"0 10,22 * * *"}` | Enable a CronJob that will delete a pod of the statefulset to force flushing the data to disk |
| deletePodCronJob.extraFlagsPod | string | `""` | Extra cmd flags to pass to the delete pod command |
| deletePodCronJob.extraFlagsPvc | string | `""` | Extra cmd flags to pass to the delete pvc command |
| deletePodCronJob.extraSkippedPvc | list | `[1,2,3]` | Extra PVC index(es) to skip deletion |
| deletePodCronJob.podIndex | int | `0` | Statefulset index to delete |
| deletePodCronJob.schedule | string | `"0 10,22 * * *"` | Cron expression for the CronJob. As reference for mainnet, the sync speed is around ~2000 blocks/minute, with a blockTime of 5 seconds, 1 day are 17280 blocks (so one day of sync is around 9 minutes) |
| extraInitContainers | list | `[]` | Additional initContainers to add to the statefulset |
| extraPodLabels | object | `{}` | Labels to add to the podTemplateSpec from statefulset |
| fullnameOverride | bool | `false` | Override default name format. Use false to use default name format, or a string to override |
| gcp | bool | `false` | Enables gcp specific settings |
| genesis | object | `{"genesisFileBase64":"","network":"rc1","networkId":42220,"useGenesisFileBase64":false}` | Blockchain genesis configuration |
| genesis.genesisFileBase64 | string | `""` | Base64 encoded genesis file if `useGenesisFileBase64` is set to true |
| genesis.network | string | `"rc1"` | Network name. Valid values are mainnet, rc1 (both for mainnet), baklava or afajores |
| genesis.networkId | int | `42220` | Network ID for custom testnet. Not used in case of mainnet, baklava or alfajores |
| genesis.useGenesisFileBase64 | bool | `false` | Use a custom genesis shared as part of a configmap. Used for custom networks with small genesis files |
| geth.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"component","operator":"In","values":["celo-fullnode"]}]},"topologyKey":"failure-domain.beta.kubernetes.io/zone"},"weight":100}]}}` | Pod Affinity # see https://www.verygoodsecurity.com/blog/posts/kubernetes-multi-az-deployments-using-pod-anti-affinity |
| geth.autoscaling | object | `{"behavior":{"scaleDown":{"policies":[{"periodSeconds":60,"type":"Pods","value":2},{"periodSeconds":60,"type":"Percent","value":25}],"selectPolicy":"Max","stabilizationWindowSeconds":1800},"scaleUp":{"policies":[{"periodSeconds":15,"type":"Pods","value":2},{"periodSeconds":15,"type":"Percent","value":25}],"selectPolicy":"Max","stabilizationWindowSeconds":600}},"enabled":false,"maxReplicas":5,"metrics":[{"resource":{"name":"cpu","target":{"averageUtilization":85,"type":"Utilization"}},"type":"Resource"}],"minReplicas":1}` | HPA configuration for celo-blockchain statefulset. Check official documentation for more info |
| geth.autoscaling.behavior | object | `{"scaleDown":{"policies":[{"periodSeconds":60,"type":"Pods","value":2},{"periodSeconds":60,"type":"Percent","value":25}],"selectPolicy":"Max","stabilizationWindowSeconds":1800},"scaleUp":{"policies":[{"periodSeconds":15,"type":"Pods","value":2},{"periodSeconds":15,"type":"Percent","value":25}],"selectPolicy":"Max","stabilizationWindowSeconds":600}}` | HPA behavior configuration |
| geth.autoscaling.enabled | bool | `false` | Enable HPA for celo-blockchain statefulset |
| geth.autoscaling.maxReplicas | int | `5` | Maximum number of replicas |
| geth.autoscaling.metrics | list | `[{"resource":{"name":"cpu","target":{"averageUtilization":85,"type":"Utilization"}},"type":"Resource"}]` | Metric reference for HPA |
| geth.autoscaling.minReplicas | int | `1` | Minimum number of replicas |
| geth.create_network_endpoint_group | bool | `false` | Use GPC's `cloud.google.com/neg` annotations to configure NEG for the RPC/WS services |
| geth.expose_rpc_externally | bool | `false` | Expose RPC port externally in the individual replica services |
| geth.extra_setup | string | `""` | Custom script (shell) that runs just before geth process is started |
| geth.flags | string | `"--txpool.nolocals"` | Geth's extra flags options (as string) |
| geth.gcmode | string | `"full"` | Blockchain garbage collection mode. Valid values are: full and archive |
| geth.gcp_workload_idantity_email | string | `""` |  |
| geth.image | object | `{"imagePullPolicy":"IfNotPresent","repository":"us.gcr.io/celo-org/geth","tag":"1.8.8"}` | Image for the celo-blockchain statefulset |
| geth.in_memory_discovery_table | bool | `false` | Enable blockchain option `--use-in-memory-discovery-table` |
| geth.light.maxpeers | int | `1000` | Maximum number of light clients to serve, or light servers to attach to |
| geth.light.serve | int | `70` | Maximum percentage of time allowed for serving LES requests (multi-threaded processing allows values over 100) |
| geth.maxpeers | int | `1150` | Maximum number of netwook peers. Includes both inbound and outbound connections, and light clients |
| geth.node_keys | list | `[]` | Array with Private keys used for as nodekey for the celo-blockchain replicas. Replica 0 will use the first ip, replica 1 the second, etc. |
| geth.ping_ip_from_packet | bool | `false` | Enable blockchain option `--ping-ip-from-packet` |
| geth.pprof | object | `{"enabled":true,"path":"/debug/metrics/prometheus","port":6060}` | Pprof configuration for celo-blockchain |
| geth.public_ip_per_node | list | `[]` | Array with 'public' ip addresses used for `nat=extip:<ip>` option. Replica 0 will use the first ip, replica 1 the second, etc. |
| geth.resources | object | `{"limits":{},"requests":{"cpu":"3","memory":"8Gi"}}` | Resources for `geth` container |
| geth.rpc_apis | string | `"eth,net,rpc,web3"` | API's exposed in the RPC/WS interfaces |
| geth.rpc_gascap | int | `10000000` | Gas cap that can be used in eth_call/estimateGas |
| geth.service_node_port_per_full_node | list | `[]` | Used if nodePort service type is specified. This is only intended to be used in AWS. |
| geth.service_protocols | list | `["TCP","UDP"]` | Create a differente service for each protocol |
| geth.service_type | string | `"LoadBalancer"` | Type of the LoadBalancer for the service attached to each replica. Each replica of the statefulset will have a service of this type. If type is `LoadBalancer`, it will be created with the `public_ip_per_node` as the `loadBalancerIP` |
| geth.syncmode | string | `"full"` | Blockchain sync mode. Valid values are: full, lightest, light and fast |
| geth.updateStrategy | object | `{"rollingUpdate":{"partition":0},"type":"RollingUpdate"}` | Celo-blockchain statefulset `updateStrategy` |
| geth.use_gstorage_data | bool | `false` | Use GCS backup. Deprecated |
| geth.verbosity | int | `2` | Loggin verbosity. Valid values are: 0-5. 0 is the least verbose |
| geth.ws_port | int | `8546` | WS-RPC server listening port |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.enabled | bool | `false` | Enable ingress resource for rpc and ws endpoints |
| ingress.hosts | list | `["celo-fullnode.local"]` | Ingress hostnames |
| ingress.ingressClassName | string | `"nginx"` | Ingress class name |
| ingress.tls | list | `[]` | Ingress TLS configuration |
| metrics | bool | `true` | Enable celo-blockchain metrics and prometheus scraping |
| nodeSelector | object | `{}` | Labels to add to `nodeSelector` field of the statefulset |
| replicaCount | int | `1` | Number of celo-blockchain statefulset replicas |
| storage.accessModes | string | `"ReadWriteOnce"` | accessMode for the volumes |
| storage.annotations | object | `{}` | celo-blockchain pvc annotations |
| storage.dataSource | object | `{}` | Include a dataSource in the volumeClaimTemplates |
| storage.enable | bool | `true` | Enable persistent storage for the celo-blockchain statefulset |
| storage.size | string | `"20Gi"` | Size of the persistent volume claim for the celo-blockchain statefulset |
| storage.storageClass | string | `"default"` | Name of the storage class to use for the celo-blockchain statefulset |
| tolerations | list | `[]` | Tolerations rules to add to `tolerations` field of the statefulset |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
