# prysm

![Version: 5.2.2](https://img.shields.io/badge/Version-5.2.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v5.2.0](https://img.shields.io/badge/AppVersion-v5.2.0-informational?style=flat-square)

Go implementation of Ethereum proof of stake.
Initially based on [stakewise/helm-charts/prysm](https://github.com/stakewise/helm-charts/tree/main/charts/prysm).

**Homepage:** <https://www.ethereum.org/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://github.com/prysmaticlabs/prysm>

## Requirements

Kubernetes: `^1.18.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://charts.stakewise.io/ | common | 1.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalLabels.client-type | string | `"consensus"` |  |
| affinity | object | `{}` |  |
| checkpointSyncUrl | string | `""` |  |
| eth1Endpoints | list | `[]` |  |
| extraFlags[0] | string | `"--p2p-max-peers=160"` |  |
| fullnameOverride | string | `""` |  |
| global.JWTSecret | string | `"test"` |  |
| global.executionEndpoints | list | `[]` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.livenessProbe.enabled | bool | `true` |  |
| global.metrics.enabled | bool | `true` |  |
| global.metrics.prometheusRule.enabled | bool | `false` |  |
| global.metrics.serviceMonitor.enabled | bool | `false` |  |
| global.network | string | `"mainnet"` |  |
| global.rbac.create | bool | `true` |  |
| global.readinessProbe.enabled | bool | `true` |  |
| global.secretNameOverride | string | `""` |  |
| global.serviceAccount.create | bool | `true` |  |
| http.enabled | bool | `true` |  |
| http.port | string | `"8080"` |  |
| httpMevRelay | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `"gcr.io"` |  |
| image.repository | string | `"prysmaticlabs/prysm/beacon-chain"` |  |
| image.tag | string | `"v5.2.0"` |  |
| imageGnosis.pullPolicy | string | `"IfNotPresent"` |  |
| imageGnosis.registry | string | `"ghcr.io"` |  |
| imageGnosis.repository | string | `"gnosischain/gbc-prysm-beacon-chain"` |  |
| imageGnosis.tag | string | `"v3.2.1-gbc"` |  |
| imagePullSecrets | list | `[]` |  |
| initChownData | bool | `true` |  |
| initImage.pullPolicy | string | `"IfNotPresent"` |  |
| initImage.registry | string | `"docker.io"` |  |
| initImage.repository | string | `"bitnami/kubectl"` |  |
| initImage.tag | string | `"1.24"` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.httpGet.path | string | `"/eth2/liveness"` |  |
| livenessProbe.httpGet.port | string | `"sidecar"` |  |
| livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| livenessProbe.initialDelaySeconds | int | `900` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `3` |  |
| metrics.port | int | `9090` |  |
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
| p2pNodePort.startAt | int | `31400` |  |
| p2pNodePort.type | string | `"NodePort"` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` |  |
| persistence.size | string | `"300Gi"` |  |
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
| readinessProbe.httpGet.path | string | `"/eth2/readiness"` |  |
| readinessProbe.httpGet.port | string | `"sidecar"` |  |
| readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| readinessProbe.initialDelaySeconds | int | `300` |  |
| readinessProbe.periodSeconds | int | `30` |  |
| readinessProbe.successThreshold | int | `2` |  |
| readinessProbe.timeoutSeconds | int | `3` |  |
| resources | object | `{}` |  |
| rpc.host | string | `"0.0.0.0"` |  |
| rpc.port | string | `"4000"` |  |
| rpc.portName | string | `"rpc"` |  |
| securityContext.fsGroup | int | `1001` |  |
| securityContext.runAsUser | int | `1001` |  |
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
| suggestedFeeRecipient | string | `""` |  |
| svcHeadless | bool | `true` |  |
| tolerations | object | `{}` |  |
| totalDifficultyOverride | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
