# op-proposer

![Version: 0.2.2](https://img.shields.io/badge/Version-0.2.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

Celo implementation for op-proposer client (Optimism Rollup)

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

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| config.activeSecuencerCheckDuration | string | `"2m0s"` |  |
| config.disputeGameFactoryProxy | string | `""` |  |
| config.gameType | int | `1` |  |
| config.l2OutputOracle | string | `""` |  |
| config.logs.color | bool | `false` |  |
| config.logs.format | string | `"json"` |  |
| config.logs.level | string | `"info"` |  |
| config.metrics.addr | string | `"0.0.0.0"` |  |
| config.metrics.enabled | bool | `false` |  |
| config.metrics.port | int | `7300` |  |
| config.numConfirmations | int | `5` |  |
| config.pollInterval | string | `"12s"` |  |
| config.proposalInterval | string | `"300s"` |  |
| config.rollupRpc | string | `"http://localhost:8547"` |  |
| config.rpc.addr | string | `"0.0.0.0"` |  |
| config.rpc.enabledAdmin | bool | `false` |  |
| config.rpc.port | int | `8545` |  |
| config.signer.address | string | `"0x000000000000"` |  |
| config.signer.enabled | bool | `false` |  |
| config.signer.endpoint | string | `"https://test.example.com"` |  |
| config.signer.tls.certManager.enabled | bool | `false` | Enable creating certificates through certmanager. This takes precedence over externalSecret. |
| config.signer.tls.certManager.issuerGroup | string | `""` | Issuer group |
| config.signer.tls.certManager.issuerKind | string | `"Issuer"` | Issuer kind |
| config.signer.tls.certManager.issuerName | string | `"test-issuer"` | Issuer name |
| config.signer.tls.enabled | bool | `false` | Enable TLS |
| config.signer.tls.externalSecret.tlsSecretCaKey | string | `"ca.pem"` | Secret key for the TLS CA |
| config.signer.tls.externalSecret.tlsSecretCertKey | string | `"certificate.pem"` | Secret key for the TLS certificate |
| config.signer.tls.externalSecret.tlsSecretKeyKey | string | `"key.pem"` | Secret key for the TLS key |
| config.signer.tls.externalSecret.tlsSecretName | string | `"test-secret"` | Secret name for the secret containing an already created TLS certificate |
| config.useFaultProofs | bool | `false` |  |
| extraArgs | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"us-docker.pkg.dev/oplabs-tools-artifacts/images/op-proposer"` |  |
| image.tag | string | `"v1.7.4"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| init.contracts.enabled | bool | `false` |  |
| init.contracts.image.pullPolicy | string | `"IfNotPresent"` |  |
| init.contracts.image.repository | string | `"alpine"` |  |
| init.contracts.image.tag | float | `3.19` |  |
| init.contracts.url | string | `""` |  |
| initContainers | list | `[]` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.httpGet.path | string | `"/healthz"` |  |
| livenessProbe.httpGet.port | string | `"rpc"` |  |
| livenessProbe.initialDelaySeconds | int | `60` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| readinessProbe.enabled | bool | `false` |  |
| resources | object | `{}` |  |
| secrets.l1Url.secretKey | string | `""` |  |
| secrets.l1Url.secretName | string | `""` |  |
| secrets.l1Url.value | string | `""` |  |
| secrets.privateKey.secretKey | string | `""` |  |
| secrets.privateKey.secretName | string | `""` |  |
| secrets.privateKey.value | string | `""` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.privileged | bool | `false` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.enabled | bool | `false` |  |
| services.metrics.annotations | object | `{}` |  |
| services.metrics.enabled | bool | `true` |  |
| services.metrics.port | int | `7300` |  |
| services.metrics.publishNotReadyAddresses | bool | `true` |  |
| services.metrics.type | string | `"ClusterIP"` |  |
| services.rpc.annotations | object | `{}` |  |
| services.rpc.enabled | bool | `true` |  |
| services.rpc.port | int | `8560` |  |
| services.rpc.type | string | `"ClusterIP"` |  |
| sidecarContainers | list | `[]` |  |
| statefulset.annotations | object | `{}` |  |
| statefulset.podAnnotations | object | `{}` |  |
| terminationGracePeriodSeconds | int | `300` |  |
| tolerations | list | `[]` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
