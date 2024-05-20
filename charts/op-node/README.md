# op-node

![Version: 0.0.7](https://img.shields.io/badge/Version-0.0.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

Celo implementation for op-node consensus engine (Optimism Rollup)
Initially based on [dysnix/charts/op-node](https://github.com/dysnix/charts/tree/main/dysnix/op-node).

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
| command | list | `[]` |  |
| config.enableAdmin | bool | `false` |  |
| config.jwt | string | `""` |  |
| config.l1.beacon | string | `"https://ethereum-beacon-api.publicnode.com"` |  |
| config.l1.rpckind | string | `"any"` |  |
| config.l1.trustrpc | bool | `false` |  |
| config.l1.url | string | `"https://1rpc.io/eth"` |  |
| config.l2.namePattern | string | `""` |  |
| config.l2.port | string | `""` |  |
| config.l2.protocol | string | `""` |  |
| config.l2.url | string | `"http://op-geth-authrpc:8551"` |  |
| config.logLevel | string | `"INFO"` |  |
| config.metrics.enabled | bool | `false` |  |
| config.metrics.port | int | `7300` |  |
| config.network | string | `"op-mainnet"` |  |
| config.p2p.advertiseIP | string | `""` |  |
| config.p2p.bootnodes | list | `[]` |  |
| config.p2p.keys | string | `""` |  |
| config.p2p.nat | bool | `false` |  |
| config.p2p.port | int | `9222` |  |
| config.p2p.sequencer.key | string | `""` |  |
| config.p2p.static | list | `[]` |  |
| config.p2p.useHostPort | bool | `false` |  |
| config.port | int | `9545` |  |
| config.rollup.config | string | `"/celo"` |  |
| config.rollup.halt | string | `""` |  |
| config.rollup.loadProtocolVersions | bool | `true` |  |
| config.sequencer.enabled | bool | `false` |  |
| config.sequencer.l1Confs | int | `5` |  |
| config.sequencer.maxSafeLag | int | `0` |  |
| config.sequencer.stopped | bool | `false` |  |
| config.syncmode | string | `""` |  |
| config.verifier.l1Confs | int | `0` |  |
| extraArgs | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| gcsConfig.image.pullPolicy | string | `"IfNotPresent"` |  |
| gcsConfig.image.repository | string | `"gcr.io/google.com/cloudsdktool/google-cloud-cli"` |  |
| gcsConfig.image.tag | string | `"latest"` |  |
| gcsConfig.local.datadir | string | `"{{ .Values.config.datadir }}"` |  |
| gcsConfig.local.initializedFile | string | `"{{ .Values.config.datadir }}/.initialized"` |  |
| gcsConfig.remote.baseUrl | string | `"my-snapshot-bucket/{{ .Release.Name }}"` |  |
| gcsConfig.remote.endpointUrl | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"us-docker.pkg.dev/oplabs-tools-artifacts/images/op-node"` |  |
| image.tag | string | `"v1.7.4"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| init.genesis.enabled | bool | `false` |  |
| init.genesis.url | string | `""` |  |
| init.image.pullPolicy | string | `"IfNotPresent"` |  |
| init.image.repository | string | `"alpine"` |  |
| init.image.tag | float | `3.19` |  |
| init.rollup.url | string | `""` |  |
| initContainers | list | `[]` |  |
| initFromGCS.enabled | bool | `false` |  |
| initFromGCS.force | bool | `false` |  |
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
| persistence.mountPath | string | `""` |  |
| persistence.pvc.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.pvc.annotations | string | `nil` |  |
| persistence.pvc.size | string | `"1Gi"` |  |
| persistence.pvc.storageClass | string | `""` |  |
| persistence.type | string | `"pvc"` |  |
| podSecurityContext | object | `{}` |  |
| readinessProbe.enabled | bool | `false` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
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
| services.p2p.annotations | object | `{}` |  |
| services.p2p.clusterIPs | list | `[]` |  |
| services.p2p.enabled | bool | `true` |  |
| services.p2p.loadBalancerIPs | list | `[]` |  |
| services.p2p.nodePorts | list | `[]` |  |
| services.p2p.port | int | `9222` |  |
| services.p2p.publishNotReadyAddresses | bool | `true` |  |
| services.p2p.type | string | `"NodePort"` |  |
| services.rpc.annotations | object | `{}` |  |
| services.rpc.enabled | bool | `true` |  |
| services.rpc.port | int | `9545` |  |
| services.rpc.type | string | `"ClusterIP"` |  |
| sidecarContainers | list | `[]` |  |
| statefulset.annotations | object | `{}` |  |
| statefulset.podAnnotations | object | `{}` |  |
| terminationGracePeriodSeconds | int | `300` |  |
| tolerations | list | `[]` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
