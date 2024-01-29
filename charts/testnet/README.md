# testnet

![Version: 0.5.1](https://img.shields.io/badge/Version-0.5.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

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
| oci://us-west1-docker.pkg.dev/devopsre/clabs-public-oci | common | 0.5.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| blockscout.db.name | string | `"blockscout"` |  |
| blockscout.image.indexerTag | string | `"indexer"` |  |
| blockscout.image.repository | string | `"gcr.io/celo-testnet/blockscout"` |  |
| blockscout.image.webTag | string | `"web"` |  |
| bootnode | object | `{"defaultClusterIP":"10.0.0.12","enabled":true,"image":{"repository":"us.gcr.io/celo-testnet/geth-all","tag":"21d8283af60927589566cb282ab640f1ccec6ebd"}}` | Bootnode configuration |
| celotool.image.repository | string | `"us.gcr.io/celo-testnet/celo-monorepo"` |  |
| celotool.image.tag | string | `"celotool-dc5e5dfa07231a4ff4664816a95eae606293eae9"` |  |
| dataSource.archive | object | `{}` |  |
| dataSource.full | object | `{}` |  |
| deletePodCronJob | object | `{"component":"tx-nodes","enabled":false,"extraFlagsPod":"","extraFlagsPvc":"","extraSkippedPvc":[{"component":"validators","index":0},{"component":"validators","index":1},{"component":"validators","index":2},{"component":"tx-nodes","index":1}],"podIndex":0,"schedule":"0 10,22 * * *"}` | Enable a CronJob that will delete a pod of the statefulset to force flushing the data to disk |
| deletePodCronJob.component | string | `"tx-nodes"` | Component to delete. Valid values are validators, and tx-nodes |
| deletePodCronJob.extraFlagsPod | string | `""` | Extra cmd flags to pass to the delete pod command |
| deletePodCronJob.extraFlagsPvc | string | `""` | Extra cmd flags to pass to the delete pvc command |
| deletePodCronJob.extraSkippedPvc | list | `[{"component":"validators","index":0},{"component":"validators","index":1},{"component":"validators","index":2},{"component":"tx-nodes","index":1}]` | Extra PVC index(es) to skip deletion |
| deletePodCronJob.podIndex | int | `0` | Statefulset index to delete |
| deletePodCronJob.schedule | string | `"0 10,22 * * *"` | Cron expression for the CronJob. As reference for mainnet, the sync speed is around ~2000 blocks/minute, with a blockTime of 5 seconds, 1 day are 17280 blocks (so one day of sync is around 9 minutes) |
| domain.name | string | `"celo-networks-dev"` |  |
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
| geth.diskSizeGB | int | `5` |  |
| geth.faultyValidatorType | string | `""` |  |
| geth.faultyValidators | int | `0` |  |
| geth.image.repository | string | `"us.gcr.io/celo-org/geth"` |  |
| geth.image.tag | string | `"1.8.0"` |  |
| geth.in_memory_discovery_table | bool | `false` |  |
| geth.light.maxpeers | int | `1000` |  |
| geth.light.serve | int | `70` |  |
| geth.maxpeers | int | `1150` |  |
| geth.ping_ip_from_packet | bool | `false` |  |
| geth.pprof.enabled | bool | `false` |  |
| geth.pprof.port | int | `6060` |  |
| geth.privateTxNodediskSizeGB | int | `10` |  |
| geth.proxyAffinity | object | `{}` |  |
| geth.proxyExtraSnippet | string | `"echo \"Proxy\"\n"` |  |
| geth.proxySelector | object | `{}` |  |
| geth.proxyTolerations | list | `[]` |  |
| geth.resources.limits | object | `{}` |  |
| geth.resources.requests.cpu | string | `"500m"` |  |
| geth.resources.requests.memory | string | `"256Mi"` |  |
| geth.rpc_gascap | int | `0` |  |
| geth.secondaryAffinity | object | `{}` |  |
| geth.secondaryNodeSelector | object | `{}` |  |
| geth.secondaryTolerations | list | `[]` |  |
| geth.secondayExtraSnippet | string | `"echo \"secondary-validator\"\n"` |  |
| geth.static_ips | bool | `false` |  |
| geth.storage | bool | `true` |  |
| geth.storageClassName | string | `""` |  |
| geth.txNodeAffinity | object | `{}` |  |
| geth.txNodeExtraSnippet | string | `"echo \"txnode\"\n"` |  |
| geth.txNodeNodeSelector | object | `{}` |  |
| geth.txNodePrivateAffinity | object | `{}` |  |
| geth.txNodePrivateExtraSnippet | string | `"echo \"txnode-private\"\nADDITIONAL_FLAGS=\"${ADDITIONAL_FLAGS} --http.timeout.read 600 --http.timeout.write 600 --http.timeout.idle 2400\"\n"` |  |
| geth.txNodePrivateNodeSelector | object | `{}` |  |
| geth.txNodePrivateTolerations | list | `[]` |  |
| geth.txNodeTolerations | list | `[]` |  |
| geth.txNodesIPAddressArray[0] | string | `"1.2.3.4"` |  |
| geth.tx_fee_recipient | string | `""` |  |
| geth.validatorAffinity | object | `{}` |  |
| geth.validatorExtraSnippet | string | `"echo \"Validator\"\n"` |  |
| geth.validatorNodeSelector | object | `{}` |  |
| geth.validatorTolerations | list | `[]` |  |
| geth.validatorsIPAddressArray | list | `[]` |  |
| geth.verbosity | int | `1` |  |
| geth.vmodule | string | `"consensus/*=2"` |  |
| geth.ws_port | int | `8546` |  |
| imagePullPolicy | string | `"Always"` |  |
| ingressClassName | string | `"nginx"` |  |
| metrics.enabled | bool | `true` |  |
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
| secrets | object | `{"accountSecret":"password","accountSecretKey":"secret","bootnodePrivatekey":"","bootnodePrivatekeyKey":"","existingSecret":"","mnemonic":"girl beauty clarify deliver force dynamic wonder shoe install erosion rib resource cannon topple prevent slot brown zero banana exercise quiz spot mercy misery","mnemonicKey":"mnemonic"}` | Secrets for the accounts |
| secrets.accountSecret | string | `"password"` | Password to use for the accounts |
| secrets.accountSecretKey | string | `"secret"` | Key of the *existing* secret for the accountSecret. |
| secrets.bootnodePrivatekey | string | `""` | Private key to use for the bootnode |
| secrets.bootnodePrivatekeyKey | string | `""` | Key of the *existing* secret for the bootnode private key. |
| secrets.existingSecret | string | `""` | *Use an existing secret instead*. Name of the *existing* secret. |
| secrets.mnemonic | string | `"girl beauty clarify deliver force dynamic wonder shoe install erosion rib resource cannon topple prevent slot brown zero banana exercise quiz spot mercy misery"` | Mnemonic to use for the accounts |
| secrets.mnemonicKey | string | `"mnemonic"` | Key of the *existing* secret for the mnemonic. |
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
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
