# odis-signer

![Version: 0.2.4](https://img.shields.io/badge/Version-0.2.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: odis-signer-3.1.1](https://img.shields.io/badge/AppVersion-odis--signer--3.1.1-informational?style=flat-square)

Helm chart for deploying Celo ODIS signer

**Homepage:** <https://celo.org>

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
| affinity | object | `{}` | Kubernetes pod affinity |
| autoscaling.enabled | bool | `false` | Enable autoscaling |
| autoscaling.maxReplicas | int | `3` | Maximum replicas |
| autoscaling.minReplicas | int | `1` | Minimum replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | CPU target utilization |
| azureKVIdentity.clientId | string | `"clientid"` | Azure aadpodidentity clientId |
| azureKVIdentity.enabled | bool | `false` | Enable Azure aadpodidentity. |
| azureKVIdentity.id | string | `"/subscriptions/7a6f5f20-bd43-4267-8c35-a734efca140c/resourcegroups/mainnet-pgpnp-eastasia/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ODISSIGNERID-mainnet-pgpnp-eastasia-AZURE_ODIS_EASTASIA_A"` | Azure aadpodidentity identity id |
| command | string | `nil` | Optional command to execute |
| env.api.domainsAPIEnabled | bool | `true` | Env. Var DOMAINS_API_ENABLED. |
| env.api.pnpAPIEnabled | bool | `true` | Env. Var PHONE_NUMBER_PRIVACY_API_ENABLED. |
| env.blockchain.blockchainApiKey | string | `nil` | Env. Var BLOCKCHAIN_API_KEY. Won't be used if blockchainApiKeyExistingSecret is defined. |
| env.blockchain.blockchainApiKeyExistingSecret | string | `"odis-signer-forno-key"` | Existing secret for forno API key. |
| env.blockchain.blockchainProvider | string | `"https://alfajores-forno.celo-testnet.org"` | Env. Var BLOCKCHAIN_PROVIDER. |
| env.db.cloudSqlProxy | bool | `true` | Enable Cloud SQL proxy for GCP |
| env.db.database | string | `"phoneNumberPrivacy"` | Env. Var DB_DATABASE. |
| env.db.host | string | `"celo-testnet:us-central1:staging-pgpnp-centralus"` | Env. Var DB_HOST. If cloudSqlProxy is enabled, will be converted to 127.0.0.1 for odis-signer container |
| env.db.password | string | `nil` | Database password. If set, it creates a secret and env. var DB_PASSWORD referencing that secret. Won't be used if passwordExistingSecret is defined. |
| env.db.passwordExistingSecret | string | `"odis-signer-db-password"` | Existing secret for DB password. |
| env.db.poolMaxSize | int | `50` | Env. Var DB_POOL_MAX_SIZE. If not set, it won't be added to the deployment. |
| env.db.port | int | `5432` | Env. Var DB_PORT. |
| env.db.timeout | int | `1000` | Env. Var DB_TIMEOUT. If not set, it won't be added to the deployment. |
| env.db.type | string | `"postgres"` | Env. Var DB_TYPE. |
| env.db.useSsl | bool | `false` | Env. Var DB_USE_SSL. If cloudSqlProxy is enabled, this must be false. |
| env.db.username | string | `"pgpnp"` | Env. Var DB_USERNAME. |
| env.keystore.azure | object | `{}` |  |
| env.keystore.domainsKeyLatestVersion | string | `nil` | Env. Var DOMAINS_LATEST_KEY_VERSION. For GCP, this is the secret version. If not set, it won't be added to the deployment. |
| env.keystore.domainsKeyNameBase | string | `"test-odis-signer-domains0-1"` | Env. Var DOMAINS_KEY_NAME_BASE. For GCP, this is the secret name. If not set, it won't be added to the deployment. |
| env.keystore.gcp | object | `{"projectID":"celo-testnet"}` | Env. Var KEYSTORE_AZURE_SECRET_NAME. secretName: secret-name |
| env.keystore.gcp.projectID | string | `"celo-testnet"` | Env. Var. KEYSTORE_GOOGLE_PROJECT_ID. If not set, it won't be added to the deployment. |
| env.keystore.pnpKeyLatestVersion | string | `nil` | Env. Var PHONE_NUMBER_PRIVACY_LATEST_KEY_VERSION. For GCP, this is the secret version. If not set, it won't be added to the deployment. |
| env.keystore.pnpKeyNameBase | string | `"test-odis-signer-phoneNumberPrivacy0-1"` | Env. Var PHONE_NUMBER_PRIVACY_KEY_NAME_BASE. For GCP, this is the secret name. If not set, it won't be added to the deployment. |
| env.keystore.type | string | `"GoogleSecretManager"` | Env. Var KEYSTORE_TYPE. Options are "GoogleSecretManager" (GCP) or "AzureKeyVault" (Azure) |
| env.log.format | string | `"stackdriver"` | Env. Var LOG_FORMAT. |
| env.log.level | string | `"trace"` | Env. Var LOG_LEVEL. |
| env.odis.fullNodeRetryCount | int | `5` | Env. Var RETRY_COUNT. If not set, it won't be added to the deployment. |
| env.odis.fullNodeRetryDelayMs | int | `100` | Env. Var RETRY_DELAY_IN_MS. If not set, it won't be added to the deployment. |
| env.odis.fullNodeTimeoutMs | int | `1000` | Env. Var TIMEOUT_MS. If not set, it won't be added to the deployment. |
| env.odis.mockDek | string | `"0x034846bc781cacdafc66f3a77aa9fc3c56a9dadcd683c72be3c446fee8da041070"` | Env. Var MOCK_DEK. If not set, it won't be added to the deployment. |
| env.odis.mockTotalQuota | string | `"10"` | Env. Var MOCK_TOTAL_QUOTA. If not set, it won't be added to the deployment. |
| env.odis.odisSignerTimeout | string | `"6000"` | Env. Var ODIS_SIGNER_TIMEOUT. If not set, it won't be added to the deployment. |
| env.odis.requestPrunningAtServerStart | string | `"false"` | Env. Var REQUEST_PRUNNING_AT_SERVER_START. If not set, it won't be added to the deployment. |
| env.odis.requestPrunningDays | string | `"7"` | Env. Var REQUEST_PRUNNING_DAYS. If not set, it won't be added to the deployment. |
| env.odis.requestPrunningJobCronPattern | string | `"0 0 3 * * *"` | Env. Var REQUEST_PRUNNING_JOB_CRON_PATTERN. If not set, it won't be added to the deployment. |
| env.odis.shouldMockAccountService | string | `"false"` | Env. Var SHOULD_MOCK_ACCOUNT_SERVICE. If not set, it won't be added to the deployment. |
| env.odis.shouldMockRequestService | string | `"false"` | Env. Var SHOULD_MOCK_REQUEST_SERVICE. If not set, it won't be added to the deployment. |
| env.tracing.enabled | bool | `false` | Enable tracing |
| env.tracing.endpoint | string | `"https://<GRAFANA_AGENT_URL>/api/traces"` | Env. Var TRACER_ENDPOINT. If enabled is false, will not be added to the deployment. |
| env.tracing.serviceName | string | `"odis-signer-env-cluster"` | Env. Var TRACING_SERVICE_NAME. If enabled is false, will not be added to the deployment. |
| fullnameOverride | string | `""` | Chart full name override |
| image.pullPolicy | string | `"Always"` | Image pullpolicy |
| image.repository | string | `"us-west1-docker.pkg.dev/devopsre/social-connect/odis-signer"` | Image repository |
| image.tag | string | `"odis-signer-3.1.1"` | Image tag Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | Image pull secrets |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.className | string | `"nginx"` | Ingress class name |
| ingress.enabled | bool | `false` | Enable ingress resource |
| ingress.hosts | list | `[]` | Ingress hostnames |
| ingress.tls | list | `[]` | Ingress TLS configuration |
| livenessProbe | object | `{}` | Liveness probe configuration |
| nameOverride | string | `""` | Chart name override |
| nodeSelector | object | `{}` | Kubernetes node selector |
| podAnnotations | object | `{}` | Custom pod annotations |
| podSecurityContext | object | `{}` | Custom pod security context |
| readinessProbe | object | `{}` | Readiness probe configuration |
| replicaCount | int | `1` | Number of deployment replicas |
| resources | object | `{}` | Container resources |
| securityContext | object | `{}` | Custom container security context |
| serviceAccount.annotations | object | `{"iam.gke.io/gcp-service-account":"odis-signer0-staging@celo-testnet.iam.gserviceaccount.com"}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Kubernetes tolerations |

Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
