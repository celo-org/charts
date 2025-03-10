# op-challenger

![Version: 0.1.8](https://img.shields.io/badge/Version-0.1.8-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: main](https://img.shields.io/badge/AppVersion-main-informational?style=flat-square)

A Helm chart for Fault Proof Monitoring

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://github.com/celo-org/optimism>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Kubernetes pod affinity |
| config.disputeGameFactoryProxy | string | `""` |  |
| config.gameWindow | string | `"672h0m0s"` |  |
| config.honestActors | list | `[]` |  |
| config.ignoredGames | list | `[]` |  |
| config.l1Beacon | string | `"https://celo-l1-beacon.celo-networks-dev.org"` |  |
| config.l2EthRPC | string | `"http://op-geth-sequencer-shared-rpc:8545"` |  |
| config.log.color | bool | `false` |  |
| config.log.format | string | `"json"` |  |
| config.log.level | string | `"INFO"` |  |
| config.maxConcurrency | int | `5` |  |
| config.metrics.addr | string | `"0.0.0.0"` |  |
| config.metrics.enabled | bool | `true` |  |
| config.metrics.port | int | `7300` |  |
| config.monitorInterval | string | `"30s"` |  |
| config.rollupRPC | string | `"http://op-node-sequencer-shared-rpc:9545"` |  |
| config.selectiveClaimResolution | bool | `false` |  |
| config.signer.address | string | `"0x000000000000"` |  |
| config.signer.enabled | bool | `false` |  |
| config.signer.endpoint | string | `"https://test.example.com"` |  |
| config.signer.tls.certManager.duration | string | `"438000h"` | Certificate duration |
| config.signer.tls.certManager.enabled | bool | `false` | Enable creating certificates through certmanager. This takes precedence over externalSecret. |
| config.signer.tls.certManager.issuerGroup | string | `""` | Issuer group |
| config.signer.tls.certManager.issuerKind | string | `"Issuer"` | Issuer kind |
| config.signer.tls.certManager.issuerName | string | `"test-issuer"` | Issuer name |
| config.signer.tls.certManager.renewBefore | string | `"8766h"` | Certificate renew before |
| config.signer.tls.enabled | bool | `false` | Enable TLS |
| config.signer.tls.externalSecret.tlsSecretCaKey | string | `"ca.pem"` | Secret key for the TLS CA |
| config.signer.tls.externalSecret.tlsSecretCertKey | string | `"certificate.pem"` | Secret key for the TLS certificate |
| config.signer.tls.externalSecret.tlsSecretKeyKey | string | `"key.pem"` | Secret key for the TLS key |
| config.signer.tls.externalSecret.tlsSecretName | string | `"test-secret"` | Secret name for the secret containing an already created TLS certificate |
| config.traceType | string | `"permissioned,cannon"` |  |
| enableServiceLinks | bool | `false` | Kubernetes enableServiceLinks |
| extraArgs | list | `[]` |  |
| fullnameOverride | string | `""` | Chart full name override |
| image.pullPolicy | string | `"IfNotPresent"` | Image pullpolicy |
| image.repository | string | `"us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-challenger"` | Image repository |
| image.tag | string | `"main"` | Image tag Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | Image pull secrets |
| init.contracts.enabled | bool | `true` |  |
| init.contracts.image.pullPolicy | string | `"IfNotPresent"` |  |
| init.contracts.image.repository | string | `"alpine"` |  |
| init.contracts.image.tag | float | `3.19` |  |
| init.contracts.urls."deployment-l1.json" | string | `""` |  |
| init.contracts.urls."genesis.json" | string | `""` |  |
| init.contracts.urls."prestate.bin.gz" | string | `""` |  |
| init.contracts.urls."rollup.json" | string | `""` |  |
| initContainers | object | `{}` |  |
| livenessProbe | object | `{}` | Liveness probe configuration |
| nameOverride | string | `""` | Chart name override |
| nodeSelector | object | `{}` | Kubernetes node selector |
| persistence.annotations | object | `{}` |  |
| persistence.size | string | `"1Gi"` |  |
| persistence.storageClass | string | `""` |  |
| podAnnotations | object | `{}` | Custom pod annotations |
| podLabels | object | `{}` | Custom pod labels |
| podSecurityContext | object | `{}` | Custom pod security context |
| readinessProbe | object | `{}` | Readiness probe configuration |
| replicaCount | int | `1` | Number of deployment replicas |
| resources | object | `{}` | Container resources |
| secrets.l1Url.secretKey | string | `""` |  |
| secrets.l1Url.secretName | string | `""` |  |
| secrets.l1Url.value | string | `""` |  |
| secrets.privateKey.secretKey | string | `""` |  |
| secrets.privateKey.secretName | string | `""` |  |
| secrets.privateKey.value | string | `""` |  |
| securityContext | object | `{}` | Custom container security context |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| services.metrics.annotations | object | `{}` |  |
| services.metrics.enabled | bool | `true` |  |
| services.metrics.port | int | `7300` |  |
| services.metrics.publishNotReadyAddresses | bool | `true` |  |
| services.metrics.type | string | `"ClusterIP"` |  |
| tolerations | list | `[]` | Kubernetes tolerations |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
