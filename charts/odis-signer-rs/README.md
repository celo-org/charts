# odis-signer-rs

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: rs-e02f44d8f20ff4b339788ab6549ce47182d7a413](https://img.shields.io/badge/AppVersion-rs--e02f44d8f20ff4b339788ab6549ce47182d7a413-informational?style=flat-square)

Helm chart for deploying the Rust port of the Celo ODIS signer (phone number privacy endpoints)

**Homepage:** <https://celo.org>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://github.com/celo-org/social-connect/tree/main/rust/signer>
* <https://github.com/celo-org/charts>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Kubernetes pod affinity |
| blockchain.apiKey | string | `""` | Env. var BLOCKCHAIN_API_KEY (forno `apiKey` header). If set, the chart creates a secret for it. Ignored when apiKeyExistingSecret is set. |
| blockchain.apiKeyExistingSecret | string | `""` | Existing secret holding BLOCKCHAIN_API_KEY. |
| blockchain.apiKeyExistingSecretKey | string | `"forno-key"` | Key in apiKeyExistingSecret. `forno-key` matches the TS signer chart. |
| blockchain.fullNodeRetryCount | string | `""` | Env. var FULL_NODE_RETRY_COUNT. Retries after the first try (TS RETRY_COUNT counted all tries). Signer default: 5. |
| blockchain.fullNodeRetryDelayMs | string | `""` | Env. var FULL_NODE_RETRY_DELAY_MS. Signer default: 100. |
| blockchain.fullNodeTimeoutMs | string | `""` | Env. var FULL_NODE_TIMEOUT_MS. Limit for one lookup, retries included. Signer default: 1000. |
| blockchain.provider | string | `""` | Env. var BLOCKCHAIN_PROVIDER. Full node RPC URL. Required unless keystore.type is Mock. |
| config.accountsContractAddress | string | `""` | Env. var ACCOUNTS_CONTRACT_ADDRESS. Overrides the address selected by CHAIN_ID. |
| config.chainID | string | `""` | Required. Env. var CHAIN_ID. 42220 for Celo Mainnet, 11142220 for Celo Sepolia. The signer refuses to start if the full node reports a different chain ID. |
| config.odisPaymentsContractAddress | string | `""` | Env. var ODIS_PAYMENTS_CONTRACT_ADDRESS. Overrides the address selected by CHAIN_ID. |
| config.odisSignerTimeout | string | `""` | Env. var ODIS_SIGNER_TIMEOUT. Limit in milliseconds for one request. Signer default: 5000. |
| config.pnpAPIEnabled | bool | `true` | Env. var PHONE_NUMBER_PRIVACY_API_ENABLED. Serve `/sign` and `/quotaStatus`. |
| config.queryPricePerCusd | string | `""` | Env. var QUERY_PRICE_PER_CUSD. Signer default: 0.001. |
| database.host | string | `""` | Postgres host. The Bitnami release next to the TS signer is `<release>-db-postgresql-hl`. |
| database.migrateLegacyData | bool | `false` | Env. var MIGRATE_LEGACY_DATA. Set to true for the first start on a TS signer's Postgres database: it imports the TS tables once. Stop the TS signer first. Without it the signer refuses to start on a database that holds unimported TS tables. Can be set back to false after the import. |
| database.name | string | `"phoneNumberPrivacy"` | Postgres database name |
| database.password | string | `""` | Postgres password. If set, the chart creates a secret for it. Ignored when passwordExistingSecret is set. |
| database.passwordExistingSecret | string | `""` | Existing secret holding the Postgres password. |
| database.passwordExistingSecretKey | string | `"db-password"` | Key in passwordExistingSecret. `db-password` matches the TS signer chart. |
| database.port | int | `5432` | Postgres port |
| database.sslMode | string | `""` | `sslmode` added to the built URL (`disable`, `prefer`, `require`, `verify-full`). Empty leaves it out, which uses TLS only if the server offers it, without verifying the certificate. |
| database.timeoutMs | string | `""` | Env. var DB_TIMEOUT. Limit in milliseconds for one statement and for the wait for a connection. Signer default: 1000. |
| database.url | string | `""` | Full DATABASE_URL (`postgres://...` or `sqlite:/tmp/signer.db`). Stored in a secret the chart creates. |
| database.urlExistingSecret | string | `""` | Existing secret holding the full DATABASE_URL. |
| database.urlExistingSecretKey | string | `"database-url"` | Key in urlExistingSecret. |
| database.username | string | `""` | Postgres user |
| extraEnv | list | `[]` | Extra environment variables for the signer container |
| fullnameOverride | string | `""` | Chart full name override |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"us-west1-docker.pkg.dev/devopsre/dev-images/odis-signer"` | Image repository. Images built from `main` and from `odis-rs-signer-*` release tags are pushed to `us-west1-docker.pkg.dev/devopsre/social-connect/odis-signer` with an `rs-` or `odis-rs-signer-` tag. |
| image.tag | string | `""` | Image tag. Defaults to the chart appVersion. Can include a digest (`tag@sha256:...`). |
| imagePullSecrets | list | `[]` | Image pull secrets |
| keystore.gcpProjectID | string | `""` | Env. var KEYSTORE_GOOGLE_PROJECT_ID. Required for GoogleSecretManager. |
| keystore.pnpKeyLatestVersion | string | `""` | Env. var PHONE_NUMBER_PRIVACY_LATEST_KEY_VERSION. Signer default: 1. |
| keystore.pnpKeyNameBase | string | `""` | Env. var PHONE_NUMBER_PRIVACY_KEY_NAME_BASE. Secret name without the `-<version>` suffix. Signer default: phoneNumberPrivacy. |
| keystore.type | string | `"GoogleSecretManager"` | Env. var KEYSTORE_TYPE. `GoogleSecretManager`, or `Mock` for development (built-in keys). |
| livenessProbe | object | `{"failureThreshold":3,"httpGet":{"path":"/status","port":"http"},"periodSeconds":10,"timeoutSeconds":5}` | Liveness probe |
| log.format | string | `"json"` | Env. var LOG_FORMAT. `json` or `text`. The TS signer's `stackdriver` and `human` stop the signer. |
| log.level | string | `"info"` | Env. var RUST_LOG. A tracing EnvFilter directive, for example `info` or `odis_signer=debug,info`. |
| nameOverride | string | `""` | Chart name override |
| nodeSelector | object | `{}` | Kubernetes node selector |
| podAnnotations | object | `{}` | Custom pod annotations |
| podLabels | object | `{}` | Custom pod labels |
| podSecurityContext | object | `{"fsGroup":65534,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod security context. The image runs as `nobody` (65534). |
| port | int | `3000` | Port the signer listens on (env. var SERVER_PORT). 3000 matches the TS signer chart. |
| readinessProbe | object | `{"failureThreshold":3,"httpGet":{"path":"/status","port":"http"},"periodSeconds":10,"timeoutSeconds":5}` | Readiness probe |
| replicaCount | int | `1` | Number of deployment replicas |
| requestPruning.days | string | `""` | Env. var REQUEST_PRUNING_DAYS. Signer default: 7. |
| requestPruning.intervalSecs | string | `""` | Env. var REQUEST_PRUNING_INTERVAL_SECS. The signer prunes at start, then on this interval. 0 disables pruning. Signer default: 86400. |
| resources | object | `{}` | Container resources |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Container security context. `/tmp` is a writable emptyDir. |
| service.port | int | `3000` | Service port |
| service.type | string | `"ClusterIP"` | Service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account. Use `iam.gke.io/gcp-service-account` to give the signer access to its key in Google Secret Manager through Workload Identity. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| startupProbe | object | `{"failureThreshold":60,"httpGet":{"path":"/status","port":"http"},"periodSeconds":10}` | Startup probe. The signer binds its port only after it has fetched its key, checked the chain ID and prepared the database, which includes the one-time legacy import. The default allows 10 minutes. |
| strategy | object | `{}` | Deployment update strategy |
| tolerations | list | `[]` | Kubernetes tolerations |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
