# testnet

![Version: 0.3.2](https://img.shields.io/badge/Version-0.3.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

Private Celo network Helm chart for Kubernetes

**Homepage:** <https://clabs.co>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://celo.org>
* <https://docs.celo.org>
* <https://clabs.co>
* <https://github.com/celo-org>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://us-west1-docker.pkg.dev/devopsre/clabs-public-oci | common | 0.3.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| blockscout.db.name | string | `"blockscout"` |  |
| blockscout.image.indexerTag | string | `"indexer"` |  |
| blockscout.image.repository | string | `"gcr.io/celo-testnet/blockscout"` |  |
| blockscout.image.webTag | string | `"web"` |  |
| bootnode.bootnodeIpAddress | string | `""` |  |
| bootnode.defaultBootnodeClusterIP | string | `"10.0.0.12"` |  |
| bootnode.image.repository | string | `"us.gcr.io/celo-testnet/geth-all"` |  |
| bootnode.image.tag | string | `"21d8283af60927589566cb282ab640f1ccec6ebd"` |  |
| celotool.image.repository | string | `"us.gcr.io/celo-testnet/celo-monorepo"` |  |
| celotool.image.tag | string | `"celotool-dc5e5dfa07231a4ff4664816a95eae606293eae9"` |  |
| domain.name | string | `"celo-networks-dev"` |  |
| enableBootnode | bool | `true` |  |
| enableFornoIngress | bool | `true` |  |
| extraPodLabels.proxy.mode | string | `"full"` |  |
| extraPodLabels.secondary.mode | string | `"full"` |  |
| extraPodLabels.txnode.mode | string | `"full"` |  |
| extraPodLabels.txnode_private.mode | string | `"archive"` |  |
| extraPodLabels.txnode_private.stack | string | `"blockscout"` |  |
| extraPodLabels.validator.mode | string | `"full"` |  |
| forceFornoDomain | string | `""` |  |
| genesis.genesisFileBase64 | string | `""` |  |
| genesis.genesisForceUrl | string | `"https://gist.githubusercontent.com/jcortejoso/eba86918c7b7c7546589edd9a32f1f08/raw/b564a1cb50c1fb5261ea5238b0c0b2d055af9ba4/genesis.json"` | Genesis force URL |
| genesis.network | string | `"testnet"` |  |
| genesis.networkId | int | `1110` |  |
| genesis.useGenesisFileBase64 | bool | `false` |  |
| geth.account.secret | string | `"password"` |  |
| geth.diskSizeGB | int | `5` |  |
| geth.faultyValidators | int | `0` |  |
| geth.image.repository | string | `"us.gcr.io/celo-org/geth"` |  |
| geth.image.tag | string | `"1.7.4"` |  |
| geth.light.maxpeers | int | `1000` |  |
| geth.light.serve | int | `70` |  |
| geth.maxpeers | int | `1150` |  |
| geth.ping_ip_from_packet | bool | `false` |  |
| geth.pprof.enabled | bool | `false` |  |
| geth.pprof.port | int | `6060` |  |
| geth.privateTxNodediskSizeGB | int | `10` |  |
| geth.proxyExtraSnippet | string | `"echo \"Proxy\"\n"` |  |
| geth.proxyNodeSelector | object | `{}` |  |
| geth.proxyTolerations | list | `[]` |  |
| geth.resources.limits | object | `{}` |  |
| geth.resources.requests.cpu | string | `"500m"` |  |
| geth.resources.requests.memory | string | `"256Mi"` |  |
| geth.secondaryNodeSelector | object | `{}` |  |
| geth.secondaryTolerations | list | `[]` |  |
| geth.secondayExtraSnippet | string | `"echo \"secondary-validator\"\n"` |  |
| geth.static_ips | bool | `false` |  |
| geth.storage | bool | `true` |  |
| geth.txNodeExtraSnippet | string | `"echo \"txnode\"\n"` |  |
| geth.txNodeNodeSelector | object | `{}` |  |
| geth.txNodePrivateExtraSnippet | string | `"echo \"txnode-private\"\nADDITIONAL_FLAGS=\"${ADDITIONAL_FLAGS} --http.timeout.read 600 --http.timeout.write 600 --http.timeout.idle 2400\"\n"` |  |
| geth.txNodePrivateNodeSelector | object | `{}` |  |
| geth.txNodePrivateTolerations | list | `[]` |  |
| geth.txNodeTolerations | list | `[]` |  |
| geth.txNodesIPAddressArray[0] | string | `"1.2.3.4"` |  |
| geth.validatorExtraSnippet | string | `"echo \"Validator\"\n"` |  |
| geth.validatorNodeSelector | object | `{}` |  |
| geth.validatorTolerations | list | `[]` |  |
| geth.verbosity | int | `1` |  |
| geth.vmodule | string | `"consensus/*=2"` |  |
| geth.ws_port | int | `8546` |  |
| imagePullPolicy | string | `"Always"` |  |
| ingressClassName | string | `"nginx"` |  |
| metrics.enabled | bool | `true` |  |
| mnemonic | string | `"girl beauty clarify deliver force dynamic wonder shoe install erosion rib resource cannon topple prevent slot brown zero banana exercise quiz spot mercy misery"` |  |
| nodeSelector | object | `{}` |  |
| pvcAnnotations.proxy | object | `{}` |  |
| pvcAnnotations.secondary | object | `{}` |  |
| pvcAnnotations.txnode | object | `{}` |  |
| pvcAnnotations.txnode_private | object | `{}` |  |
| pvcAnnotations.validator | object | `{}` |  |
| replicaInitialCount | int | `0` |  |
| replicas.proxiesPerValidator[0] | int | `0` |  |
| replicas.proxiesPerValidator[1] | int | `1` |  |
| replicas.proxiesPerValidator[2] | int | `0` |  |
| replicas.secondaries | int | `0` |  |
| replicas.txNodes | int | `1` |  |
| replicas.txNodesPrivate | int | `1` |  |
| replicas.validators | int | `3` |  |
| updateStrategy.proxy.rollingUpdate.partition | int | `0` |  |
| updateStrategy.proxy.type | string | `"RollingUpdate"` |  |
| updateStrategy.secondaries.rollingUpdate.partition | int | `0` |  |
| updateStrategy.secondaries.type | string | `"RollingUpdate"` |  |
| updateStrategy.tx_nodes.rollingUpdate.partition | int | `0` |  |
| updateStrategy.tx_nodes.type | string | `"RollingUpdate"` |  |
| updateStrategy.tx_nodes_private.rollingUpdate.partition | int | `0` |  |
| updateStrategy.tx_nodes_private.type | string | `"RollingUpdate"` |  |
| updateStrategy.validators.rollingUpdate.partition | int | `0` |  |
| updateStrategy.validators.type | string | `"RollingUpdate"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
