# rosetta

![Version: 0.1.3](https://img.shields.io/badge/Version-0.1.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.0.0](https://img.shields.io/badge/AppVersion-v2.0.0-informational?style=flat-square)

Rosetta Client for Celo Networks

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://github.com/celo-org/rosetta>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| bootnodeUrl | string | `""` |  |
| cli.enabled | bool | `false` |  |
| cli.image.repository | string | `"us.gcr.io/celo-testnet/rosetta-cli"` |  |
| cli.image.tag | string | `"v0.10.3"` |  |
| cli.replicaCount | int | `1` |  |
| cli.storage.accessModes | string | `"ReadWriteOnce"` | accessMode for the volumes |
| cli.storage.annotations | object | `{"resize.topolvm.io/increase":"10%","resize.topolvm.io/inodes-threshold":"5%","resize.topolvm.io/storage_limit":"300Gi","resize.topolvm.io/threshold":"10%"}` | celo-blockchain pvc annotations |
| cli.storage.dataSource | object | `{}` | Include a dataSource in the volumeClaimTemplates |
| cli.storage.size | string | `"10Gi"` | Size of the persistent volume claim for the celo-blockchain statefulset |
| cli.storage.storageClass | string | `"premium-rwo"` | Name of the storage class to use for the celo-blockchain statefulset |
| genesisUrl | string | `""` |  |
| image.repository | string | `"us.gcr.io/celo-testnet/rosetta"` |  |
| image.tag | string | `"v2.0.0"` |  |
| ingress.domain | string | `"integration-tests.celo-networks-dev.org"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.ingressClassName | string | `"nginx"` |  |
| network | string | `"mainnet"` |  |
| networkId | int | `42220` |  |
| nodeSelector | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources.requests.cpu | int | `7` |  |
| resources.requests.memory | string | `"12Gi"` |  |
| storage.accessModes | string | `"ReadWriteOnce"` | accessMode for the volumes |
| storage.annotations | object | `{"resize.topolvm.io/increase":"10%","resize.topolvm.io/inodes-threshold":"5%","resize.topolvm.io/storage_limit":"3000Gi","resize.topolvm.io/threshold":"10%"}` | celo-blockchain pvc annotations |
| storage.dataSource | object | `{}` | Include a dataSource in the volumeClaimTemplates |
| storage.size | string | `"200Gi"` | Size of the persistent volume claim for the celo-blockchain statefulset |
| storage.storageClass | string | `"premium-rwo"` | Name of the storage class to use for the celo-blockchain statefulset |
| tolerations | object | `{}` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
