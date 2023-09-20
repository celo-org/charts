# odis-signer

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: oblivious-decentralized-identifier-service-3.0.1](https://img.shields.io/badge/AppVersion-oblivious--decentralized--identifier--service--3.0.1-informational?style=flat-square)

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
| env.api.domainsAPIEnabled | bool | `false` | Env. Var DOMAINS_API_ENABLED. |
| env.api.pnpAPIEnabled | bool | `true` | Env. Var PHONE_NUMBER_PRIVACY_API_ENABLED. |
| env.blockchain.blockchainApiKey | string | `"kong-api-key"` | Env. Var BLOCKCHAIN_API_KEY. |
| env.blockchain.blockchainProvider | string | `"https://forno.celo.org"` | Env. Var BLOCKCHAIN_PROVIDER. |
| env.db.database | string | `"database"` | Env. Var DB_DATABASE. |
| env.db.host | string | `"db.host"` | Env. Var DB_HOST. |
| env.db.password | string | `nil` | Database password. If set, it creates a secret and env. var DB_PASSWORD referencing that secret. |
| env.db.port | int | `5432` | Env. Var DB_PORT. |
| env.db.type | string | `"postgres"` | Env. Var DB_TYPE. |
| env.db.username | string | `"db-user"` | Env. Var DB_USERNAME. |
| env.keystore.domainsKeyLatestVersion | string | `""` | Env. Var DOMAINS_LATEST_KEY_VERSION. If not set, it won't be added to the deployment. |
| env.keystore.domainsKeyNameBase | string | `""` | Env. Var DOMAINS_KEY_NAME_BASE. If not set, it won't be added to the deployment. |
| env.keystore.pnpKeyLatestVersion | string | `""` | Env. Var PHONE_NUMBER_PRIVACY_LATEST_KEY_VERSION. If not set, it won't be added to the deployment. |
| env.keystore.pnpKeyNameBase | string | `""` | Env. Var PHONE_NUMBER_PRIVACY_KEY_NAME_BASE. If not set, it won't be added to the deployment. |
| env.keystore.secretName | string | `"secret-name"` | Env. Var KEYSTORE_AZURE_SECRET_NAME. |
| env.keystore.type | string | `"AzureKeyVault"` | Env. Var KEYSTORE_TYPE. |
| env.keystore.vaultName | string | `"vault-name"` | Env. Var KEYSTORE_AZURE_VAULT_NAME. |
| env.log.format | string | `"stackdriver"` | Env. Var LOG_FORMAT. |
| env.log.level | string | `"trace"` | Env. Var LOG_LEVEL. |
| env.tracing.enabled | bool | `true` | Enable tracing |
| env.tracing.endpoint | string | `"https://<GRAFANA_AGENT_URL>/api/traces"` | Env. Var TRACER_ENDPOINT. If enabled is false, will not be added to the deployment. |
| env.tracing.serviceName | string | `"odis-signer-env-cluster"` | Env. Var TRACING_SERVICE_NAME. If enabled is false, will not be added to the deployment. |
| fullnameOverride | string | `""` | Chart full name override |
| image.pullPolicy | string | `"Always"` | Image pullpolicy |
| image.repository | string | `"us.gcr.io/celo-testnet/celo-monorepo"` | Image repository |
| image.tag | string | `"oblivious-decentralized-identifier-service-3.0.1"` | Image tag Overrides the image tag whose default is the chart appVersion. |
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
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Kubernetes tolerations |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
