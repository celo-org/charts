# nethermind

![Version: 2.6.2](https://img.shields.io/badge/Version-2.6.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.26.0](https://img.shields.io/badge/AppVersion-v1.26.0-informational?style=flat-square)

.NET Core Ethereum client
Initially based on [stakewise/helm-charts/nethermind](https://github.com/stakewise/helm-charts/tree/main/charts/nethermind).

**Homepage:** <https://nethermind.io/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://github.com/NethermindEth/nethermind>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.stakewise.io/ | common | 1.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalLabels.client-type | string | `"execution"` |  |
| affinity | object | `{}` |  |
| extraFlags | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.JWTSecret | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.livenessProbe.enabled | bool | `true` |  |
| global.metrics.enabled | bool | `true` |  |
| global.metrics.prometheusRule.enabled | bool | `false` |  |
| global.metrics.serviceMonitor.enabled | bool | `false` |  |
| global.network | string | `"mainnet"` |  |
| global.rbac.create | bool | `true` |  |
| global.readinessProbe.enabled | bool | `true` |  |
| global.replicaCount | int | `1` |  |
| global.serviceAccount.create | bool | `true` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"nethermind/nethermind"` |  |
| image.tag | string | `"1.27.1"` |  |
| imagePullSecrets | list | `[]` |  |
| initChownData | bool | `true` |  |
| initImage.pullPolicy | string | `"IfNotPresent"` |  |
| initImage.registry | string | `"docker.io"` |  |
| initImage.repository | string | `"bitnami/kubectl"` |  |
| initImage.tag | string | `"1.24"` |  |
| jsonrpc.enabled | bool | `true` |  |
| jsonrpc.engine.host | string | `"0.0.0.0"` |  |
| jsonrpc.engine.modules[0] | string | `"Net"` |  |
| jsonrpc.engine.modules[1] | string | `"Eth"` |  |
| jsonrpc.engine.modules[2] | string | `"Subscribe"` |  |
| jsonrpc.engine.modules[3] | string | `"Web3"` |  |
| jsonrpc.engine.port | string | `"8551"` |  |
| jsonrpc.host | string | `"0.0.0.0"` |  |
| jsonrpc.modules[0] | string | `"Eth"` |  |
| jsonrpc.modules[1] | string | `"Subscribe"` |  |
| jsonrpc.modules[2] | string | `"Trace"` |  |
| jsonrpc.modules[3] | string | `"TxPool"` |  |
| jsonrpc.modules[4] | string | `"Web3"` |  |
| jsonrpc.modules[5] | string | `"Personal"` |  |
| jsonrpc.modules[6] | string | `"Proof"` |  |
| jsonrpc.modules[7] | string | `"Net"` |  |
| jsonrpc.modules[8] | string | `"Parity"` |  |
| jsonrpc.modules[9] | string | `"Health"` |  |
| jsonrpc.ports.rest | string | `"8545"` |  |
| jsonrpc.ports.websocket | string | `"8546"` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.httpGet.path | string | `"/eth1/liveness"` |  |
| livenessProbe.httpGet.port | string | `"sidecar"` |  |
| livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| livenessProbe.initialDelaySeconds | int | `900` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `3` |  |
| merge.builderRelayUrl | string | `""` |  |
| merge.enabled | bool | `false` |  |
| merge.feeRecipient | string | `""` |  |
| merge.finalTotalDifficulty | string | `""` |  |
| merge.terminalTotalDifficulty | string | `""` |  |
| metrics.port | int | `8008` |  |
| metrics.prometheusRule.additionalLabels | object | `{}` |  |
| metrics.prometheusRule.default | bool | `true` |  |
| metrics.prometheusRule.namespace | string | `""` |  |
| metrics.prometheusRule.rules | list | `[]` |  |
| metrics.serviceMonitor.additionalLabels | object | `{}` |  |
| metrics.serviceMonitor.honorLabels | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `"30s"` |  |
| metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.relabellings | list | `[]` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| p2pNodePort.annotations | object | `{}` |  |
| p2pNodePort.enabled | bool | `false` |  |
| p2pNodePort.replicaToNodePort | object | `{}` |  |
| p2pNodePort.startAt | int | `31200` |  |
| p2pNodePort.type | string | `"NodePort"` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` |  |
| persistence.size | string | `"250Gi"` |  |
| persistence.storageClassName | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `true` |  |
| podDisruptionBudget.maxUnavailable | int | `1` |  |
| priorityClassName | string | `""` |  |
| rbac.clusterRules[0].apiGroups[0] | string | `""` |  |
| rbac.clusterRules[0].resources[0] | string | `"nodes"` |  |
| rbac.clusterRules[0].verbs[0] | string | `"get"` |  |
| rbac.clusterRules[0].verbs[1] | string | `"list"` |  |
| rbac.clusterRules[0].verbs[2] | string | `"watch"` |  |
| rbac.name | string | `""` |  |
| rbac.rules[0].apiGroups[0] | string | `""` |  |
| rbac.rules[0].resources[0] | string | `"services"` |  |
| rbac.rules[0].verbs[0] | string | `"get"` |  |
| rbac.rules[0].verbs[1] | string | `"list"` |  |
| rbac.rules[0].verbs[2] | string | `"watch"` |  |
| readinessProbe.failureThreshold | int | `30` |  |
| readinessProbe.httpGet.path | string | `"/eth1/readiness"` |  |
| readinessProbe.httpGet.port | string | `"sidecar"` |  |
| readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| readinessProbe.initialDelaySeconds | int | `60` |  |
| readinessProbe.periodSeconds | int | `30` |  |
| readinessProbe.successThreshold | int | `2` |  |
| readinessProbe.timeoutSeconds | int | `3` |  |
| resources | object | `{}` |  |
| securityContext.fsGroup | int | `1000` |  |
| securityContext.runAsUser | int | `1000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `""` |  |
| sessionAffinity.enabled | bool | `false` |  |
| sessionAffinity.timeoutSeconds | int | `86400` |  |
| sidecar.bindAddr | string | `"0.0.0.0"` |  |
| sidecar.bindPort | int | `3000` |  |
| sidecar.pullPolicy | string | `"IfNotPresent"` |  |
| sidecar.registry | string | `"europe-west4-docker.pkg.dev"` |  |
| sidecar.repository | string | `"stakewiselabs/public/ethnode-sidecar"` |  |
| sidecar.tag | string | `"v1.0.6"` |  |
| svcHeadless | bool | `true` |  |
| terminationGracePeriodSeconds | int | `300` |  |
| tolerations | list | `[]` |  |
| verticalAutoscaler.containerPolicies | object | `{}` |  |
| verticalAutoscaler.enabled | bool | `false` |  |
| verticalAutoscaler.updateMode | string | `"Off"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
