# common

Helm chart with helper templates and functions for Celo nodes. Import into your chart with `dependencies` and use the templates and functions

![Version: 0.5.2](https://img.shields.io/badge/Version-0.5.2-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

- [common](#common)
  - [Chart releases](#chart-releases)
  - [Basic chart operation](#basic-chart-operation)

## Chart releases

Chart is released to oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci/common repository automatically every commit to `master` branch.
Just remind yourself to bump the version of the chart in the [Chart.yaml](./Chart.yaml) file.
This process is configured using GitHub Actions in the [helm_release.yml](../../.github/workflows/helm_release.yml)
and [helm_test.yml](../../.github/workflows/helm_test.yml) files.

## Basic chart operation

To import this chart into your chart, add the following to your `requirements.yaml` file:

```yaml
dependencies:
  - name: common
    repository: oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci
    version: 0.5.2
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| celotool | object | `{"image":{"imagePullPolicy":"IfNotPresent","repository":"gcr.io/celo-testnet/celo-monorepo","tag":"celotool-dc5e5dfa07231a4ff4664816a95eae606293eae9"}}` | Celotool image. This image is used to derivate the private keys from the mnemonic. This is just internally used by cLabs and not required to be used for running nodes |
| genesis | object | `{"genesisFileBase64":"","genesisForceUrl":"https://gist.githubusercontent.com/jcortejoso/eba86918c7b7c7546589edd9a32f1f08/raw/b564a1cb50c1fb5261ea5238b0c0b2d055af9ba4/genesis.json","network":"rc1","networkId":42220,"useGenesisFileBase64":false}` | Blockchain genesis configuration |
| genesis.genesisFileBase64 | string | `""` | Base64 encoded genesis file if `useGenesisFileBase64` is set to true |
| genesis.genesisForceUrl | string | `"https://gist.githubusercontent.com/jcortejoso/eba86918c7b7c7546589edd9a32f1f08/raw/b564a1cb50c1fb5261ea5238b0c0b2d055af9ba4/genesis.json"` | Genesis force URL |
| genesis.network | string | `"rc1"` | Network name. Valid values are mainnet, rc1 (both for mainnet), baklava or afajores |
| genesis.networkId | int | `42220` | Network ID for custom testnet. Not used in case of mainnet, baklava or alfajores |
| genesis.useGenesisFileBase64 | bool | `false` | Use a custom genesis shared as part of a configmap. Used for custom networks with small genesis files |
| geth.gcmode | string | `"full"` | Blockchain garbage collection mode. Valid values are: full and archive |
| geth.gstorage_lz4 | bool | `true` | Use lz4 backups for chain (if enabled) |
| geth.image | object | `{"imagePullPolicy":"IfNotPresent","repository":"us.gcr.io/celo-testnet/geth","tag":"1b40b25d315bfcd792138e288ea61351d6c44d09"}` | Image for the celo-blockchain statefulset |
| geth.in_memory_discovery_table | bool | `false` | Enable blockchain option `--use-in-memory-discovery-table` |
| geth.ping_ip_from_packet | bool | `false` |  |
| geth.public_ip_per_node | list | `[]` | Array with 'public' ip addresses used for `nat=extip:<ip>` option. Replica 0 will use the first ip, replica 1 the second, etc. |
| geth.resources | object | `{"limits":{"cpu":"1000m","memory":"512Mi"},"requests":{"cpu":"500m","memory":"256Mi"}}` | Resources for `geth` container |
| geth.rpc_gascap | int | `10000000` | Gas cap that can be used in eth_call/estimateGas |
| geth.service_type | string | `"LoadBalancer"` | Type of the LoadBalancer for the service attached to each replica. Each replica of the statefulset will have a service of this type. If type is `LoadBalancer`, it will be created with the `public_ip_per_node` as the `loadBalancerIP` |
| geth.syncmode | string | `"full"` | Blockchain sync mode. Valid values are: full, lightest, light and fast |
| geth.verbosity | int | `2` | Loggin verbosity. Valid values are: 0-5. 0 is the least verbose |
| geth.ws_port | int | `8546` | WS-RPC server listening port |
| imagePullPolicy | string | `"IfNotPresent"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
