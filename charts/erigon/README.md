# erigon

![Version: 2.61.2](https://img.shields.io/badge/Version-2.61.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.61.2](https://img.shields.io/badge/AppVersion-2.61.2-informational?style=flat-square)

Ethereum implementation on the efficiency frontier

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://github.com/ledgerwatch/erigon>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.stakewise.io/ | common | 1.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalLabels.client-type | string | `"execution"` |  |
| affinity | object | `{}` |  |
| authRpc.addr | string | `"0.0.0.0"` |  |
| authRpc.port | string | `"8551"` |  |
| authRpc.vhosts | string | `"*"` |  |
| extraFlags[0] | string | `"--prune.mode=full"` |  |
| extraFlags[1] | string | `"--prune.mode=minimal"` |  |
| extraFlags[2] | string | `"--torrent.download.rate=512mb"` |  |
| extraFlags[3] | string | `"--sync.loop.block.limit=10_000"` |  |
| extraFlags[4] | string | `"--batchSize=2g"` |  |
| extraFlags[5] | string | `"--db.pagesize=64kb"` |  |
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
| global.secretNameOverride | string | `""` |  |
| global.serviceAccount.create | bool | `true` |  |
| grpcPort | string | `"9090"` |  |
| http.addr | string | `"0.0.0.0"` |  |
| http.api | string | `"eth,erigon,web3,net,txpool,engine,debug,trace"` |  |
| http.corsDomain | string | `"*"` |  |
| http.enabled | bool | `true` |  |
| http.port | string | `"8545"` |  |
| http.vhosts | string | `"*"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"erigontech/erigon"` |  |
| image.tag | string | `"v3.3.3"` |  |
| imagePullSecrets | list | `[]` |  |
| initChownData | bool | `true` |  |
| initImage.pullPolicy | string | `"IfNotPresent"` |  |
| initImage.registry | string | `"docker.io"` |  |
| initImage.repository | string | `"bitnami/kubectl"` |  |
| initImage.tag | string | `"latest"` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.httpGet.path | string | `"/eth1/liveness"` |  |
| livenessProbe.httpGet.port | string | `"sidecar"` |  |
| livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| livenessProbe.initialDelaySeconds | int | `900` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `3` |  |
| metrics.addr | string | `"0.0.0.0"` |  |
| metrics.port | string | `"6060"` |  |
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
| p2pNodePort.startAt | int | `31000` |  |
| p2pNodePort.type | string | `"NodePort"` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.annotations."resize.topolvm.io/increase" | string | `"10%"` |  |
| persistence.annotations."resize.topolvm.io/inodes-threshold" | string | `"10%"` |  |
| persistence.annotations."resize.topolvm.io/storage_limit" | string | `"500Gi"` |  |
| persistence.annotations."resize.topolvm.io/threshold" | string | `"10%"` |  |
| persistence.enabled | bool | `true` |  |
| persistence.size | string | `"100Gi"` |  |
| persistence.storageClassName | string | `"standard-rwo"` |  |
| podAnnotations."prometheus.io/path" | string | `"/metrics"` |  |
| podAnnotations."prometheus.io/port" | string | `"6060"` |  |
| podAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| podSecurityContext.fsGroup | int | `1001` |  |
| podSecurityContext.runAsUser | int | `1001` |  |
| priorityClassName | string | `""` |  |
| privateApiAddr | string | `"127.0.0.1:9090"` |  |
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
| readinessProbe.initialDelaySeconds | int | `30` |  |
| readinessProbe.periodSeconds | int | `30` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `3` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
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
| terminalTotalDifficulty | string | `""` |  |
| terminationGracePeriodSeconds | int | `300` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
