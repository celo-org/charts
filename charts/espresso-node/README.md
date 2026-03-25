# espresso-node

![Version: 0.2.1](https://img.shields.io/badge/Version-0.2.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 20260302](https://img.shields.io/badge/AppVersion-20260302-informational?style=flat-square)

Helm chart for running an Espresso Network sequencer node

**Homepage:** <https://docs.espressosys.com/network/guides/node-operators/running-a-sequencer-node>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://github.com/EspressoSystems/espresso-network>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 16.4.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| commandOverride | string | `""` |  |
| espresso.api | object | `{"maxConnections":"","port":24000}` | ------------------------------------------------------------------------- |
| espresso.api.maxConnections | string | `""` | Maximum concurrent HTTP connections |
| espresso.api.port | int | `24000` | Port for the HTTP API |
| espresso.apiPeers | string | `""` | Comma-separated list of peer query service URLs (for DA/archival modes). Used by the query module to fetch missing data from peers. |
| espresso.cdnEndpoint | string | `"cdn.main.net.espresso.network:1737"` | CDN endpoint in host:port form (provided by Espresso for Mainnet) |
| espresso.configPeers | string | `"https://cache.main.net.espresso.network"` | Config peers URL for first-time network join. Used to fetch P2P configuration from a trusted node on first startup. After successful join, config is stored locally and this is not needed on restarts. |
| espresso.existingSecret | string | `""` | Use an existing Kubernetes Secret for private keys The secret must contain keys: ESPRESSO_SEQUENCER_PRIVATE_STAKING_KEY and ESPRESSO_SEQUENCER_PRIVATE_STATE_KEY |
| espresso.existingSecretRpc | string | `""` | Use an existing Kubernetes Secret for L1 RPC provider URLs The secret must contain key: ESPRESSO_SEQUENCER_L1_PROVIDER and optionally: ESPRESSO_SEQUENCER_L1_WS_PROVIDER When set, l1Provider and l1WsProvider values are ignored. |
| espresso.extraEnv | list | `[]` | ------------------------------------------------------------------------- |
| espresso.genesisFile | string | `"/genesis/mainnet.toml"` | Genesis file path inside the container (bundled with the Docker image) |
| espresso.identity | object | `{"companyName":"","companyWebsite":"","countryCode":"","latitude":"","longitude":"","networkType":"","nodeName":"","nodeType":"","operatingSystem":""}` | ------------------------------------------------------------------------- |
| espresso.isArchive | bool | `false` | Whether this is an archival node (stores all historical data) |
| espresso.isDA | bool | `false` | Whether to participate in the DA committee |
| espresso.l1 | object | `{"blocksCacheSize":"","consecutiveFailureTolerance":"","eventsChannelCapacity":"","eventsMaxBlockRange":"","finalizedSafetyMargin":"","frequentFailureTolerance":"","pollingInterval":"","rateLimitDelay":"","retryDelay":"20s","stakeTableUpdateInterval":"","subscriptionTimeout":""}` | ------------------------------------------------------------------------- |
| espresso.l1.retryDelay | string | `"20s"` | Delay after failed L1 requests. Espresso team recommends "20s" for Non-DA nodes. |
| espresso.l1Provider | string | `"https://change-me.example.com"` | L1 (Ethereum Mainnet) JSON-RPC provider URL REQUIRED unless existingSecretRpc is set. You must set this to your own Ethereum L1 HTTP RPC endpoint. |
| espresso.l1WsProvider | string | `""` | Optional but recommended: L1 WebSocket provider(s) for block streaming Comma-separated list of ws:// or wss:// endpoints. Decreases load on your HTTP provider. |
| espresso.libp2pAdvertiseAddress | string | `""` | Address advertised to other nodes (host:port, UDP) Set this to your node's externally reachable address. |
| espresso.libp2pBindAddress | string | `"0.0.0.0:31000"` | Address to bind libp2p to (host:port, UDP) |
| espresso.libp2pBootstrapNodes | string | `""` | Optional: comma-separated list of bootstrap nodes in multiaddress format |
| espresso.logging | object | `{"rustLog":"warn,libp2p=off","rustLogFormat":"json"}` | ------------------------------------------------------------------------- |
| espresso.logging.rustLog | string | `"warn,libp2p=off"` | Rust log level filter |
| espresso.logging.rustLogFormat | string | `"json"` | Log output format (json recommended for production) |
| espresso.privateStakingKey | string | `""` | Private staking key (BLS key for signing consensus messages) Only used if existingSecret is empty. Store in a Secret in production. |
| espresso.privateStateKey | string | `""` | Private state key (Schnorr key for signing finalized states) Only used if existingSecret is empty. Store in a Secret in production. |
| espresso.pruning | object | `{"batchSize":"","enabled":false,"interval":"","maxUsage":"","minimumRetention":"1d","pruningThreshold":"100000000000","targetRetention":"7d"}` | ------------------------------------------------------------------------- |
| espresso.pruning.batchSize | string | `""` | Batch size for pruning operations |
| espresso.pruning.enabled | bool | `false` | Enable pruning of historical data |
| espresso.pruning.interval | string | `""` | Interval between pruning runs |
| espresso.pruning.maxUsage | string | `""` | Maximum fraction of pruningThreshold to use (1-10000 scale) |
| espresso.pruning.minimumRetention | string | `"1d"` | Minimum data retention period |
| espresso.pruning.pruningThreshold | string | `"100000000000"` | Storage threshold in bytes to trigger pruning |
| espresso.pruning.targetRetention | string | `"7d"` | Target data retention period |
| espresso.query | object | `{"activeFetchDelay":"","chunkFetchDelay":"","fetchRateLimit":"","peers":""}` | ------------------------------------------------------------------------- |
| espresso.query.activeFetchDelay | string | `""` | Delay between active fetch requests |
| espresso.query.chunkFetchDelay | string | `""` | Delay between chunk fetch requests |
| espresso.query.fetchRateLimit | string | `""` | Fetch rate limit for missing data from peers |
| espresso.query.peers | string | `""` | Comma-separated list of peer query service URLs |
| espresso.statePeers | string | `"https://query.main.net.espresso.network"` | Comma-separated list of peer URLs for catchup (max ~5 URLs recommended). DA/archival modes should use /v1 suffix. The value is auto-suffixed with /v1 for da/archival modes in the deployment template. |
| espresso.stateRelayServerUrl | string | `"https://state-relay.main.net.espresso.network"` | State relay server URL (provided by Espresso for Mainnet) |
| espresso.storage | object | `{"embeddedDb":false,"postgresDatabase":"sequencer","postgresHost":"","postgresPassword":"","postgresPort":"5432","postgresUri":"","postgresUseTls":false,"postgresUser":"espresso","storagePath":"/data/sequencer/store"}` | ------------------------------------------------------------------------- |
| espresso.storage.embeddedDb | bool | `false` | Use embedded SQLite DB (for lightweight mode). Automatically set to true for lightweight mode in the deployment template. |
| espresso.storage.postgresDatabase | string | `"sequencer"` | Postgres database name |
| espresso.storage.postgresHost | string | `""` | Postgres host (used if postgresUri is empty, defaults to subchart) |
| espresso.storage.postgresPassword | string | `""` | Postgres password (use existingSecret in production) |
| espresso.storage.postgresPort | string | `"5432"` | Postgres port |
| espresso.storage.postgresUri | string | `""` | Postgres connection URI (alternative to individual fields below) |
| espresso.storage.postgresUseTls | bool | `false` | Use TLS for Postgres connection |
| espresso.storage.postgresUser | string | `"espresso"` | Postgres user |
| espresso.storage.storagePath | string | `"/data/sequencer/store"` | Path inside the container for embedded SQLite storage (lightweight mode) |
| fullnameOverride | string | `""` | Override the full release name |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"ghcr.io/espressosystems/espresso-sequencer/sequencer"` | Container image repository |
| image.tag | string | `""` | Image tag (defaults to appVersion in Chart.yaml) |
| imagePullSecrets | list | `[]` | Image pull secrets for private registries |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"espresso-node.example.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls | list | `[]` |  |
| libp2pService | object | `{"annotations":{},"enabled":true,"loadBalancerIP":"","port":31000,"type":"LoadBalancer"}` | Separate service for libp2p (UDP) |
| libp2pService.annotations | object | `{}` | Annotations for the libp2p service |
| libp2pService.enabled | bool | `true` | Enable a dedicated service for libp2p |
| libp2pService.loadBalancerIP | string | `""` | Pre-allocated static IP for the LoadBalancer (optional) |
| libp2pService.port | int | `31000` | libp2p service port (UDP) |
| libp2pService.type | string | `"LoadBalancer"` | Service type (LoadBalancer recommended for external reachability) |
| livenessProbe.failureThreshold | int | `5` |  |
| livenessProbe.httpGet.path | string | `"/healthcheck"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| mode | string | `"lightweight"` |  |
| nameOverride | string | `""` | Override the chart name |
| nodeSelector | object | `{}` |  |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Access modes |
| persistence.annotations | object | `{}` | Annotations for the PVC |
| persistence.enabled | bool | `true` | Enable persistent volume for embedded DB storage |
| persistence.size | string | `"10Gi"` | Storage size |
| persistence.storageClass | string | `""` | Storage class (empty = default) |
| podAnnotations | object | `{"prometheus.io/path":"/v1/status/metrics","prometheus.io/port":"24000","prometheus.io/scrape":"true"}` | Pod annotations |
| podLabels | object | `{}` | Pod labels |
| podSecurityContext | object | `{}` | Pod security context |
| postgresql.auth.database | string | `"sequencer"` | Database name to create |
| postgresql.auth.existingSecret | string | `""` | Use an existing secret for the password |
| postgresql.auth.password | string | `""` | Postgres admin password |
| postgresql.auth.username | string | `"espresso"` | Postgres admin username |
| postgresql.enabled | bool | `false` | Deploy a PostgreSQL instance via the Bitnami subchart |
| postgresql.primary.persistence.enabled | bool | `true` | Enable persistence for PostgreSQL |
| postgresql.primary.persistence.size | string | `"100Gi"` | Storage size for PostgreSQL |
| postgresql.primary.resources.limits.memory | string | `"4Gi"` |  |
| postgresql.primary.resources.requests.cpu | string | `"2"` |  |
| postgresql.primary.resources.requests.memory | string | `"4Gi"` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.httpGet.path | string | `"/healthcheck"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| readinessProbe.initialDelaySeconds | int | `15` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| replicaCount | int | `1` | Number of replicas (typically 1 per unique staking key) |
| resources.limits.memory | string | `"8Gi"` |  |
| resources.requests.cpu | string | `"1"` |  |
| resources.requests.memory | string | `"8Gi"` |  |
| securityContext | object | `{}` | Container security context |
| service.annotations | object | `{}` | Annotations for the HTTP API service |
| service.port | int | `24000` | HTTP API service port |
| service.type | string | `"ClusterIP"` | Service type for the HTTP API |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.automountServiceAccountToken | bool | `false` | Automount API credentials |
| serviceAccount.create | bool | `true` | Create a service account |
| serviceAccount.name | string | `""` | Service account name (auto-generated if empty) |
| startupProbe.failureThreshold | int | `30` |  |
| startupProbe.httpGet.path | string | `"/healthcheck"` |  |
| startupProbe.httpGet.port | string | `"http"` |  |
| startupProbe.initialDelaySeconds | int | `10` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.timeoutSeconds | int | `5` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
