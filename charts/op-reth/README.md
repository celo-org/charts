# op-reth

![Version: 0.0.2](https://img.shields.io/badge/Version-0.0.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

Celo implementation for op-reth execution engine (Optimism Rollup)
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
| command | list | `["/bin/sh","-c"]` | Override the celo-reth container command (can be templated) |
| config.authrpc.port | int | `8551` |  |
| config.bootnodes | list | `[]` | P2P discovery bootnodes. Built-in bootnodes are used when this list is empty. |
| config.chain | string | `"celo"` | Built-in chain name (e.g. celo, optimism, base) OR a path to a chain spec file. If empty, falls back to `$datadir/genesis.json`. |
| config.datadir | string | `"/celo"` | Data directory inside the container. |
| config.disableDiscovery | bool | `false` | Disable the peer discovery service entirely. |
| config.full | bool | `true` | Run as full node (true) or archive node (false / ""). |
| config.http.api[0] | string | `"eth"` |  |
| config.http.api[1] | string | `"net"` |  |
| config.http.api[2] | string | `"web3"` |  |
| config.http.corsdomain[0] | string | `"*"` |  |
| config.http.port | int | `8545` |  |
| config.logFilter | string | `""` | RUST_LOG-style filter for stdout logs (e.g. "info,reth=debug"). |
| config.logFormat | string | `"json"` | Log format: json, log-fmt, or terminal. |
| config.maxpeers | int | `50` | Maximum total peers (inbound + outbound). |
| config.metrics.enabled | bool | `false` |  |
| config.nat | string | `""` | NAT resolution method. Format: any|none|upnp|publicip|extip:<IP>. |
| config.netrestrict | list | `[]` | Restrict network access to specific CIDR ranges. |
| config.networkId | string | `""` | Optional override of the chain spec network ID for P2P. Empty string for default. |
| config.port | int | `30303` | TCP port for P2P communication. |
| config.rollup.disabletxpoolgossip | bool | `true` | Disable txpool gossip on the rollup network. OP-stack rollups typically forward txs via `--rollup.sequencer` over HTTP, so P2P gossip is unwanted. |
| config.rollup.halt | string | `"major"` | Halt node on op-node version mismatch. Possible values: "major", "minor", "patch", "none". |
| config.rollup.sequencerhttp | string | `"https://mainnet-sequencer.optimism.io/"` | URL of the sequencer to forward `eth_sendRawTransaction` to. Leave empty to validate locally without forwarding. |
| config.trustedOnly | bool | `false` | If true (`--trusted-only`), reject any inbound or outbound peer not in `trustedPeers` — hard accept-list. |
| config.trustedPeers | list | `[]` | List of enode URLs (`enode://<hex-pubkey>@host:port`) that are always-allowed and pinned against eviction. Joined with commas into `--trusted-peers`. |
| config.useHostPort | bool | `false` | Allocate hostPorts for P2P communication instead of using a Kubernetes Service. |
| config.ws.api[0] | string | `"eth"` |  |
| config.ws.api[1] | string | `"net"` |  |
| config.ws.api[2] | string | `"web3"` |  |
| config.ws.enabled | bool | `false` |  |
| config.ws.origins[0] | string | `"*"` |  |
| config.ws.port | int | `8545` |  |
| enableServiceLinks | bool | `false` | Disabled by default to avoid pod env vars leaking into celo-reth's CLI parsing. Enable only if your workload depends on Kubernetes service-link env vars. |
| extraArgs | list | `[]` | Extra celo-reth CLI arguments (can be templated) |
| extraEnv | list | `[]` | Extra celo-reth env vars (can be templated) |
| extraInitContainers | list | `[]` | Extra init containers, can be templated |
| extraVolumeMounts | list | `[]` | Extra volumeMounts for the celo-reth container, can be templated |
| extraVolumes | list | `[]` | Extra volumes, can be templated |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"us-west1-docker.pkg.dev/devopsre/dev-images/celo-kona-reth"` |  |
| image.tag | string | `"pr-144"` |  |
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
| init.chownData.image.tag | float | `3.19` |  |
| init.extraArgs | list | `[]` | Extra arguments for the celo-reth init-genesis container (can be templated). |
| init.genesis.enabled | bool | `false` |  |
| init.genesis.url | string | `""` |  |
| init.parameters.image.pullPolicy | string | `"IfNotPresent"` |  |
| init.parameters.image.repository | string | `"alpine"` |  |
| init.parameters.image.tag | float | `3.19` |  |
| init.rollup.enabled | bool | `false` |  |
| init.rollup.url | string | `""` |  |
| initFromS3.enabled | bool | `false` | Enable the init-from-S3 initContainer. |
| initFromS3.force | bool | `false` | Re-download the snapshot from S3 on every pod start. |
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
| persistence.hostPath.path | string | `"/blockchain/optimism"` | Host volume mount point. Assumes /blockchain is your host volume mount point. |
| persistence.hostPath.type | string | `"DirectoryOrCreate"` | Automatically create the directory if it does not exist. |
| persistence.mountPath | string | `""` | Mount path inside the container. Leave blank to use the value from `.Values.config.datadir`. |
| persistence.pvc.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.pvc.annotations | object | `{}` |  |
| persistence.pvc.size | string | `"5Gi"` | Recommended disk size for op-mainnet full node. |
| persistence.pvc.storageClass | string | `""` | Set to "-" to manually create the persistent volume. |
| persistence.type | string | `"pvc"` | Backing storage type. Possible values: "pvc", "hostPath". |
| podAnnotations | object | `{}` | Extra pod annotations |
| podLabels | object | `{}` | Extra pod labels |
| podSecurityContext.fsGroup | int | `10001` |  |
| podStatusLabels | object | `{}` | Labels marking the node as ready to serve traffic. Used as selector for the RPC service together with `.Values.podLabels` and default labels. |
| readinessProbe.enabled | bool | `false` |  |
| readinessProbe.exec.command[0] | string | `"sh"` |  |
| readinessProbe.exec.command[1] | string | `"/scripts/readiness.sh"` |  |
| readinessProbe.exec.command[2] | string | `"60"` |  |
| readinessProbe.failureThreshold | int | `2` |  |
| readinessProbe.initialDelaySeconds | int | `60` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| replicaCount | int | `1` |  |
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
| secrets.jwt.secretKey | string | `""` | Key inside `secretName` that holds the JWT. |
| secrets.jwt.secretName | string | `""` | Name of an existing Secret holding the JWT, used when `value` is empty. |
| secrets.jwt.value | string | `""` | REQUIRED. JWT (hex) for engine-API auth with op-node. Comma-separated list for multi-replica. Takes precedence over `secretName` if non-empty. |
| secrets.nodeKey.secretKey | string | `""` | Key inside `secretName` that holds the node key. |
| secrets.nodeKey.secretName | string | `""` | Name of an existing Secret holding the node key, used when `value` is empty. |
| secrets.nodeKey.value | string | `""` | REQUIRED. P2P node private key (hex). Comma-separated list for multi-replica. Takes precedence over `secretName` if non-empty. |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.privileged | bool | `false` |  |
| securityContext.runAsGroup | int | `10001` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `10001` |  |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| serviceMonitor | object | `{"enabled":false}` | Create a Prometheus Operator ServiceMonitor |
| services.authrpc.clusterIPs | list | `[]` |  |
| services.authrpc.enabled | bool | `true` |  |
| services.authrpc.loadBalancerIPs | list | `[]` |  |
| services.authrpc.port | int | `8551` |  |
| services.authrpc.publishNotReadyAddresses | bool | `true` |  |
| services.authrpc.type | string | `"ClusterIP"` |  |
| services.metrics.enabled | bool | `true` |  |
| services.metrics.port | int | `6060` |  |
| services.metrics.publishNotReadyAddresses | bool | `true` |  |
| services.metrics.type | string | `"ClusterIP"` |  |
| services.p2p.annotations | object | `{}` |  |
| services.p2p.clusterIPs | list | `[]` |  |
| services.p2p.enabled | bool | `true` | Disable if no inbound P2P exposure is needed (e.g. outbound-only nodes that dial a fixed trusted-peer set). |
| services.p2p.loadBalancerIPs | list | `[]` |  |
| services.p2p.port | int | `30303` |  |
| services.p2p.publishNotReadyAddresses | bool | `true` |  |
| services.p2p.skipUDPService | bool | `false` |  |
| services.p2p.type | string | `"ClusterIP"` |  |
| services.rpc.httpPort | int | `8545` |  |
| services.rpc.individualServiceEnabled | bool | `true` |  |
| services.rpc.publishNotReadyAddresses | bool | `false` |  |
| services.rpc.sharedServiceEnabled | bool | `true` |  |
| services.rpc.type | string | `"ClusterIP"` |  |
| services.rpc.wsPort | int | `8545` |  |
| sidecarContainers | list | `[]` | Sidecar containers, can be templated |
| startupProbe.enabled | bool | `false` |  |
| startupProbe.exec.command[0] | string | `"sh"` |  |
| startupProbe.exec.command[1] | string | `"/scripts/wait-for-sync.sh"` |  |
| startupProbe.failureThreshold | int | `120960` |  |
| startupProbe.initialDelaySeconds | int | `10` |  |
| startupProbe.periodSeconds | int | `5` |  |
| startupProbe.timeoutSeconds | int | `10` |  |
| syncToS3.cronjob.enabled | bool | `false` | Restart the pod and trigger sync to S3 inside the initContainer on a schedule. |
| syncToS3.cronjob.image.pullPolicy | string | `"IfNotPresent"` |  |
| syncToS3.cronjob.image.repository | string | `"dysnix/kubectl"` |  |
| syncToS3.cronjob.image.tag | string | `"v1.29"` |  |
| syncToS3.cronjob.schedule | string | `"0 2 * * *"` |  |
| syncToS3.enabled | bool | `false` | Enable the sync-to-S3 initContainer (this alone does not trigger a sync — see `cronjob`). |
| terminationGracePeriodSeconds | int | `300` | Grace period for the node to flush its DB and shut down cleanly. |
| tolerations | list | `[]` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
