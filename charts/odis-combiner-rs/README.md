# odis-combiner-rs

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: rs-dd24fdaf9d3129e74901aac43e06c7370cf78600](https://img.shields.io/badge/AppVersion-rs--dd24fdaf9d3129e74901aac43e06c7370cf78600-informational?style=flat-square)

Helm chart for deploying the Rust port of the Celo ODIS combiner (phone number privacy endpoints)

**Homepage:** <https://celo.org>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://github.com/celo-org/social-connect/tree/main/rust/combiner>
* <https://github.com/celo-org/charts>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Kubernetes pod affinity |
| blockchain.apiKey | string | `""` | Env. var BLOCKCHAIN_API_KEY (forno `apiKey` header). If set, the chart creates a secret for it. Ignored when apiKeyExistingSecret is set. |
| blockchain.apiKeyExistingSecret | string | `""` | Existing secret holding BLOCKCHAIN_API_KEY. |
| blockchain.apiKeyExistingSecretKey | string | `"forno-key"` | Key in apiKeyExistingSecret. `forno-key` matches the TS combiner chart. |
| blockchain.fullNodeRetryCount | string | `""` | Env. var PNP_FULL_NODE_RETRY_COUNT. Retries after the first try (the TS combiner counts all tries). Combiner default: 5. |
| blockchain.fullNodeRetryDelayMs | string | `""` | Env. var PNP_FULL_NODE_DELAY_MS. Pause between tries. Combiner default: 100. |
| blockchain.fullNodeTimeoutMs | string | `""` | Env. var PNP_FULL_NODE_TIMEOUT_MS. Limit for one DEK lookup, retries included. Combiner default: 1000. |
| blockchain.provider | string | `""` | Required. Env. var BLOCKCHAIN_PROVIDER. Full node RPC URL, for the chain ID check at startup and the DEK lookups. |
| config.chainID | string | `""` | Required. Env. var CHAIN_ID. 42220 for Celo Mainnet, 11142220 for Celo Sepolia. The combiner refuses to start on any other chain, and when the full node reports a different chain ID. |
| config.serviceName | string | `""` | Env. var SERVICE_NAME, the `app` label on every metric. Combiner default: odis-combiner. |
| extraEnv | list | `[]` | Extra environment variables for the combiner container, for example HTTPS_PROXY and NO_PROXY |
| fullnameOverride | string | `""` | Chart full name override |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"us-west1-docker.pkg.dev/devopsre/dev-images/odis-combiner"` | Image repository. Images built from `main` and from `odis-rs-combiner-*` release tags are pushed to `us-west1-docker.pkg.dev/devopsre/social-connect/odis-combiner` with an `rs-` or `odis-rs-combiner-` tag. |
| image.tag | string | `""` | Image tag. Defaults to the chart appVersion. Can include a digest (`tag@sha256:...`). |
| imagePullSecrets | list | `[]` | Image pull secrets |
| livenessProbe | object | `{"failureThreshold":3,"httpGet":{"path":"/status","port":"http"},"periodSeconds":10,"timeoutSeconds":5}` | Liveness probe |
| log.format | string | `"json"` | Env. var LOG_FORMAT. `json` or `text`. The TS combiner's `stackdriver` and `human` stop the combiner. |
| log.level | string | `"info"` | Env. var RUST_LOG. A tracing EnvFilter directive, for example `info` or `odis_combiner=debug,info`. |
| nameOverride | string | `""` | Chart name override |
| nodeSelector | object | `{}` | Kubernetes node selector |
| pnp.currentKeyVersion | string | `""` | Env. var PNP_KEYS_CURRENT_VERSION. Must be the `keyVersion` of an entry in keyVersions. Combiner default: 1. Required when keyVersions lists more than one entry, so that the default cannot pick an old key unnoticed. |
| pnp.keyVersions | list | `[]` | Required. Env. var PNP_KEYS_VERSIONS, written as JSON. The combiner refuses to start unless each `threshold` is the polynomial's degree plus one, at most the number of signers, and each `pubKey` is the polynomial's constant term. Quote `polynomial` and `pubKey` so YAML reads them as strings. |
| pnp.signerTimeoutMs | string | `""` | Env. var PNP_ODIS_SERVICES_TIMEOUT_MILLISECONDS. Deadline for the signer calls of one request. Combiner default: 5000. |
| pnp.signers | list | `[]` | Required. Env. var PNP_ODIS_SERVICES_SIGNERS, written as JSON. Each entry needs a `url` and may carry a `shareIndex`, which the combiner checks every partial signature against. Read "Share indices" in the changelog before setting one: a wrong index makes the signer charge for requests whose partial signature the combiner then drops. |
| podAnnotations | object | `{}` | Custom pod annotations |
| podLabels | object | `{}` | Custom pod labels |
| podSecurityContext | object | `{"fsGroup":65534,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod security context. The image runs as `nobody` (65534). |
| port | int | `8081` | Port the combiner listens on (env. var SERVER_PORT). 8081 matches the TS combiner chart. |
| readinessProbe | object | `{"failureThreshold":3,"httpGet":{"path":"/status","port":"http"},"periodSeconds":10,"timeoutSeconds":5}` | Readiness probe |
| replicaCount | int | `1` | Number of deployment replicas. Replicas share no state, so more can be added at any time. |
| resources | object | `{}` | Container resources |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Container security context. The combiner writes no files. |
| service.port | int | `8081` | Service port |
| service.type | string | `"ClusterIP"` | Service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| startupProbe | object | `{"failureThreshold":12,"httpGet":{"path":"/status","port":"http"},"periodSeconds":5}` | Startup probe. The combiner binds its port only after it has checked its configuration and the full node's chain ID. The default allows 1 minute. |
| strategy | object | `{}` | Deployment update strategy |
| tolerations | list | `[]` | Kubernetes tolerations |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
