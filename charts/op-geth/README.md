# op-geth

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

Celo implementation for op-geth execution engine (Optimism Rollup)
Initially based on [dysnix/charts/op-geth](https://github.com/dysnix/charts/tree/main/dysnix/op-geth).

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
| command[0] | string | `"/bin/sh"` |  |
| command[1] | string | `"-c"` |  |
| config.authrpc.port | int | `8551` |  |
| config.authrpc.vhosts[0] | string | `"*"` |  |
| config.bootnodes | list | `[]` |  |
| config.cache | int | `0` |  |
| config.datadir | string | `"/celo"` |  |
| config.discovery.port | int | `30301` |  |
| config.gcmode | string | `"full"` |  |
| config.http.api[0] | string | `"eth"` |  |
| config.http.api[1] | string | `"net"` |  |
| config.http.api[2] | string | `"web3"` |  |
| config.http.corsdomain[0] | string | `"*"` |  |
| config.http.port | int | `8545` |  |
| config.http.vhosts[0] | string | `"*"` |  |
| config.jwt | string | `""` |  |
| config.maxpeers | int | `50` |  |
| config.metrics.enabled | bool | `false` |  |
| config.metrics.expensive | bool | `false` |  |
| config.nat | string | `"any"` |  |
| config.networkid | string | `""` |  |
| config.nodiscover | bool | `false` |  |
| config.op-network | string | `"op-mainnet"` |  |
| config.port | int | `30303` |  |
| config.rollup.disabletxpoolgossip | bool | `true` |  |
| config.rollup.halt | string | `"major"` |  |
| config.rollup.sequencerhttp | string | `"https://mainnet-sequencer.optimism.io/"` |  |
| config.snapshot | bool | `true` |  |
| config.state.scheme | string | `"path"` |  |
| config.syncmode | string | `"snap"` |  |
| config.useHostPort | bool | `false` |  |
| config.verbosity | int | `3` |  |
| config.vmodule | list | `[]` |  |
| config.ws.api[0] | string | `"eth"` |  |
| config.ws.api[1] | string | `"net"` |  |
| config.ws.api[2] | string | `"web3"` |  |
| config.ws.enabled | bool | `false` |  |
| config.ws.origins[0] | string | `"*"` |  |
| config.ws.port | int | `8546` |  |
| enableServiceLinks | bool | `false` |  |
| extraArgs | list | `[]` |  |
| extraInitContainers | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"us-docker.pkg.dev/oplabs-tools-artifacts/images/op-geth"` |  |
| image.tag | string | `"latest"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.http.annotations | object | `{}` |  |
| ingress.http.className | string | `""` |  |
| ingress.http.enabled | bool | `false` |  |
| ingress.http.hosts | list | `[]` |  |
| ingress.http.tls | list | `[]` |  |
| ingress.ws.annotations | object | `{}` |  |
| ingress.ws.className | string | `""` |  |
| ingress.ws.enabled | bool | `false` |  |
| ingress.ws.hosts | string | `nil` |  |
| ingress.ws.tls | list | `[]` |  |
| init.chownData.enabled | bool | `false` |  |
| init.chownData.image.pullPolicy | string | `"IfNotPresent"` |  |
| init.chownData.image.repository | string | `"alpine"` |  |
| init.chownData.image.tag | float | `3.18` |  |
| init.genesis.enabled | bool | `false` |  |
| init.genesis.url | string | `""` |  |
| init.rollup.url | string | `""` |  |
| initFromS3.enabled | bool | `false` |  |
| initFromS3.force | bool | `false` |  |
| livenessProbe.enabled | bool | `false` |  |
| livenessProbe.exec.command[0] | string | `"sh"` |  |
| livenessProbe.exec.command[1] | string | `"/scripts/liveness.sh"` |  |
| livenessProbe.exec.command[2] | string | `"300"` |  |
| livenessProbe.failureThreshold | int | `10` |  |
| livenessProbe.initialDelaySeconds | int | `120` |  |
| livenessProbe.periodSeconds | int | `60` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `10` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.hostPath.path | string | `"/blockchain/optimism"` |  |
| persistence.hostPath.type | string | `"DirectoryOrCreate"` |  |
| persistence.mountPath | string | `""` |  |
| persistence.pvc.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.pvc.annotations | object | `{}` |  |
| persistence.pvc.size | string | `"5Gi"` |  |
| persistence.pvc.storageClass | string | `""` |  |
| persistence.type | string | `"pvc"` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `10001` |  |
| podStatusLabels | object | `{}` |  |
| readinessProbe.enabled | bool | `false` |  |
| readinessProbe.exec.command[0] | string | `"sh"` |  |
| readinessProbe.exec.command[1] | string | `"/scripts/readiness.sh"` |  |
| readinessProbe.exec.command[2] | string | `"60"` |  |
| readinessProbe.failureThreshold | int | `2` |  |
| readinessProbe.initialDelaySeconds | int | `60` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| resources | object | `{}` |  |
| s3config.image.pullPolicy | string | `"IfNotPresent"` |  |
| s3config.image.repository | string | `"peakcom/s5cmd"` |  |
| s3config.image.tag | string | `"v2.2.2"` |  |
| s3config.local.datadir | string | `"{{ .Values.config.datadir }}/geth/chaindata"` |  |
| s3config.local.initializedFile | string | `"{{ .Values.config.datadir }}/.initialized"` |  |
| s3config.remote.accessKeyId | string | `"REPLACEME"` |  |
| s3config.remote.baseUrl | string | `"my-snapshot-bucket/{{ .Release.Name }}"` |  |
| s3config.remote.endpointUrl | string | `""` |  |
| s3config.remote.secretAccessKey | string | `"REPLACEME"` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.privileged | bool | `false` |  |
| securityContext.runAsGroup | int | `10001` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `10001` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.enabled | bool | `false` |  |
| services.authrpc.enabled | bool | `true` |  |
| services.authrpc.port | int | `8551` |  |
| services.authrpc.publishNotReadyAddresses | bool | `true` |  |
| services.authrpc.type | string | `"ClusterIP"` |  |
| services.metrics.enabled | bool | `true` |  |
| services.metrics.port | int | `6060` |  |
| services.metrics.publishNotReadyAddresses | bool | `true` |  |
| services.metrics.type | string | `"ClusterIP"` |  |
| services.p2p.annotations | object | `{}` |  |
| services.p2p.enabled | bool | `true` |  |
| services.p2p.loadBalancerIP | string | `""` |  |
| services.p2p.port | int | `30303` |  |
| services.p2p.publishNotReadyAddresses | bool | `true` |  |
| services.p2p.type | string | `"NodePort"` |  |
| services.p2pDiscovery.annotations | object | `{}` |  |
| services.p2pDiscovery.enabled | bool | `true` |  |
| services.p2pDiscovery.loadBalancerIP | string | `""` |  |
| services.p2pDiscovery.port | int | `30301` |  |
| services.p2pDiscovery.publishNotReadyAddresses | bool | `true` |  |
| services.p2pDiscovery.type | string | `"NodePort"` |  |
| services.rpc.enabled | bool | `true` |  |
| services.rpc.httpPort | int | `8545` |  |
| services.rpc.type | string | `"ClusterIP"` |  |
| services.rpc.wsPort | int | `8546` |  |
| sidecarContainers | list | `[]` |  |
| startupProbe.enabled | bool | `false` |  |
| startupProbe.exec.command[0] | string | `"sh"` |  |
| startupProbe.exec.command[1] | string | `"/scripts/wait-for-sync.sh"` |  |
| startupProbe.failureThreshold | int | `120960` |  |
| startupProbe.initialDelaySeconds | int | `10` |  |
| startupProbe.periodSeconds | int | `5` |  |
| startupProbe.timeoutSeconds | int | `10` |  |
| syncToS3.cronjob.enabled | bool | `false` |  |
| syncToS3.cronjob.image.pullPolicy | string | `"IfNotPresent"` |  |
| syncToS3.cronjob.image.repository | string | `"dysnix/kubectl"` |  |
| syncToS3.cronjob.image.tag | string | `"v1.27"` |  |
| syncToS3.cronjob.schedule | string | `"0 2 * * *"` |  |
| syncToS3.enabled | bool | `false` |  |
| terminationGracePeriodSeconds | int | `300` |  |
| tolerations | list | `[]` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.