# odis-combiner

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 4c00727348979093a76a7aa5b1ba7ea7bf5ac9cf](https://img.shields.io/badge/AppVersion-4c00727348979093a76a7aa5b1ba7ea7bf5ac9cf-informational?style=flat-square)

Helm chart for deploying Celo ODIS signer in AKS

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
| akeyless.enabled | bool | `false` | Enable Akeyless secret injector for Env. Var BLOCKCHAIN_API_KEY |
| akeyless.path | string | `"/static-secrets/identity-circle/ODIS-Combiner/Staging/Forno-API-Key"` | Akeyless path to Forno API key |
| autoscaling.enabled | bool | `false` | Enable autoscaling |
| autoscaling.maxReplicas | int | `3` | Maximum replicas |
| autoscaling.minReplicas | int | `1` | Minimum replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | CPU target utilization |
| env.blockchain.blockchainApiKey | string | `"kong-api-key"` | Env. Var BLOCKCHAIN_API_KEY. |
| env.blockchain.blockchainProvider | string | `"https://alfajores-forno.celo-testnet.org"` | Env. Var BLOCKCHAIN_PROVIDER. |
| env.domain.domainEnabled | bool | `true` | Env. Var DOMAINS_API_ENABLED. |
| env.domain.domainFullNodeDelayMs | string | `"100"` | Env. Var DOMAIN_FULL_NODE_DELAY_MS |
| env.domain.domainFullNodeRetryCount | string | `"5"` | Env. Var DOMAIN_FULL_NODE_RETRY_COUNT |
| env.domain.domainFullNodeTimeoutMs | string | `"1000"` | Env. Var DOMAIN_FULL_NODE_TIMEOUT_MS |
| env.domain.domainKeysCurrentVersion | string | `"1"` | Env. Var DOMAIN_KEYS_CURRENT_VERSION |
| env.domain.domainKeysVersions | string | `"[{\"keyVersion\":1,\"threshold\":2,\"polynomial\":\"0200000000000000ec5b161ac167995bd17cc0e9cf3f79369efac1fff5b0f68ad0e83dca207e3fc41b8e20bc155ebb3416a7b3d87364490169032189aa7380c47a0a464864fbe0c106e803197ae4959165e7067b95775cee2c74a78d7a67406764f342e5a4b99a003a510287524c9437b12ebb0bfdc7ea46078b807d1b665966961784bd71c4227c272b01c0fcd19c5b92226c1aac324b010abef36192e8ff3abb25686b3e6707bc747b129c32e572b5850db8446bd8f0af9a3fbf6b579793002b1b68528ca4ac00\",\"pubKey\":\"7FsWGsFnmVvRfMDpzz95Np76wf/1sPaK0Og9yiB+P8QbjiC8FV67NBans9hzZEkBaQMhiapzgMR6CkZIZPvgwQboAxl65JWRZecGe5V3XO4sdKeNemdAZ2TzQuWkuZoA\"},{\"keyVersion\":2,\"threshold\":2,\"polynomial\":\"0200000000000000ec5b161ac167995bd17cc0e9cf3f79369efac1fff5b0f68ad0e83dca207e3fc41b8e20bc155ebb3416a7b3d87364490169032189aa7380c47a0a464864fbe0c106e803197ae4959165e7067b95775cee2c74a78d7a67406764f342e5a4b99a003a510287524c9437b12ebb0bfdc7ea46078b807d1b665966961784bd71c4227c272b01c0fcd19c5b92226c1aac324b010abef36192e8ff3abb25686b3e6707bc747b129c32e572b5850db8446bd8f0af9a3fbf6b579793002b1b68528ca4ac00\",\"pubKey\":\"7FsWGsFnmVvRfMDpzz95Np76wf/1sPaK0Og9yiB+P8QbjiC8FV67NBans9hzZEkBaQMhiapzgMR6CkZIZPvgwQboAxl65JWRZecGe5V3XO4sdKeNemdAZ2TzQuWkuZoA\"},{\"keyVersion\":3,\"threshold\":2,\"polynomial\":\"0200000000000000ec5b161ac167995bd17cc0e9cf3f79369efac1fff5b0f68ad0e83dca207e3fc41b8e20bc155ebb3416a7b3d87364490169032189aa7380c47a0a464864fbe0c106e803197ae4959165e7067b95775cee2c74a78d7a67406764f342e5a4b99a003a510287524c9437b12ebb0bfdc7ea46078b807d1b665966961784bd71c4227c272b01c0fcd19c5b92226c1aac324b010abef36192e8ff3abb25686b3e6707bc747b129c32e572b5850db8446bd8f0af9a3fbf6b579793002b1b68528ca4ac00\",\"pubKey\":\"7FsWGsFnmVvRfMDpzz95Np76wf/1sPaK0Og9yiB+P8QbjiC8FV67NBans9hzZEkBaQMhiapzgMR6CkZIZPvgwQboAxl65JWRZecGe5V3XO4sdKeNemdAZ2TzQuWkuZoA\"}]"` | Env. Var DOMAIN_KEYS_VERSIONS |
| env.domain.domainOdisServicesSigners | string | `"[{\"url\": \"https://staging-pgpnp-signer0.azurefd.net\", \"fallbackUrl\": \"http://52.154.55.35\"},{\"url\": \"https://staging-pgpnp-signer1.azurefd.net\", \"fallbackUrl\": \"http://13.89.116.218\"},{\"url\": \"https://staging-pgpnp-signer2.azurefd.net\", \"fallbackUrl\": \"http://20.84.128.169\"}]"` | Env. Var DOMAIN_ODIS_SERVICES_SIGNERS |
| env.domain.domainOdisServicesTimeoutMillisecond | string | `"5000"` | Env. Var DOMAIN_ODIS_SERVICES_TIMEOUT_MILLISECONDS |
| env.domain.domainServiceName | string | `"odis_combiner"` | Env. Var DOMAIN_SERVICE_NAME |
| env.domain.domainShouldAuthenticate | bool | `false` | Env. Var DOMAIN_SHOULD_AUTHENTICATE |
| env.domain.domainShouldCheckQuota | bool | `false` | Env. Var DOMAIN_SHOULD_CHECK_QUOTA |
| env.log.format | string | `"stackdriver"` | Env. Var LOG_FORMAT. |
| env.log.level | string | `"trace"` | Env. Var LOG_LEVEL. |
| env.pnp.pnpEnabled | bool | `true` | Env. Var PHONE_NUMBER_PRIVACY_API_ENABLED. |
| env.pnp.pnpFullNodeDelayMs | string | `"100"` | Env. Var PNP_FULL_NODE_DELAY_MS |
| env.pnp.pnpFullNodeRetryCount | string | `"5"` | Env. Var PNP_FULL_NODE_RETRY_COUNT |
| env.pnp.pnpFullNodeTimeoutMs | string | `"1000"` | Env. Var PNP_FULL_NODE_TIMEOUT_MS |
| env.pnp.pnpKeysCurrentVersion | string | `"1"` | Env. Var PNP_KEYS_CURRENT_VERSION |
| env.pnp.pnpKeysVersions | string | `"[{\"keyVersion\":1,\"threshold\":2,\"polynomial\":\"0200000000000000ec5b161ac167995bd17cc0e9cf3f79369efac1fff5b0f68ad0e83dca207e3fc41b8e20bc155ebb3416a7b3d87364490169032189aa7380c47a0a464864fbe0c106e803197ae4959165e7067b95775cee2c74a78d7a67406764f342e5a4b99a003a510287524c9437b12ebb0bfdc7ea46078b807d1b665966961784bd71c4227c272b01c0fcd19c5b92226c1aac324b010abef36192e8ff3abb25686b3e6707bc747b129c32e572b5850db8446bd8f0af9a3fbf6b579793002b1b68528ca4ac00\",\"pubKey\":\"7FsWGsFnmVvRfMDpzz95Np76wf/1sPaK0Og9yiB+P8QbjiC8FV67NBans9hzZEkBaQMhiapzgMR6CkZIZPvgwQboAxl65JWRZecGe5V3XO4sdKeNemdAZ2TzQuWkuZoA\"},{\"keyVersion\":2,\"threshold\":2,\"polynomial\":\"0200000000000000ec5b161ac167995bd17cc0e9cf3f79369efac1fff5b0f68ad0e83dca207e3fc41b8e20bc155ebb3416a7b3d87364490169032189aa7380c47a0a464864fbe0c106e803197ae4959165e7067b95775cee2c74a78d7a67406764f342e5a4b99a003a510287524c9437b12ebb0bfdc7ea46078b807d1b665966961784bd71c4227c272b01c0fcd19c5b92226c1aac324b010abef36192e8ff3abb25686b3e6707bc747b129c32e572b5850db8446bd8f0af9a3fbf6b579793002b1b68528ca4ac00\",\"pubKey\":\"7FsWGsFnmVvRfMDpzz95Np76wf/1sPaK0Og9yiB+P8QbjiC8FV67NBans9hzZEkBaQMhiapzgMR6CkZIZPvgwQboAxl65JWRZecGe5V3XO4sdKeNemdAZ2TzQuWkuZoA\"},{\"keyVersion\":3,\"threshold\":2,\"polynomial\":\"0200000000000000ec5b161ac167995bd17cc0e9cf3f79369efac1fff5b0f68ad0e83dca207e3fc41b8e20bc155ebb3416a7b3d87364490169032189aa7380c47a0a464864fbe0c106e803197ae4959165e7067b95775cee2c74a78d7a67406764f342e5a4b99a003a510287524c9437b12ebb0bfdc7ea46078b807d1b665966961784bd71c4227c272b01c0fcd19c5b92226c1aac324b010abef36192e8ff3abb25686b3e6707bc747b129c32e572b5850db8446bd8f0af9a3fbf6b579793002b1b68528ca4ac00\",\"pubKey\":\"7FsWGsFnmVvRfMDpzz95Np76wf/1sPaK0Og9yiB+P8QbjiC8FV67NBans9hzZEkBaQMhiapzgMR6CkZIZPvgwQboAxl65JWRZecGe5V3XO4sdKeNemdAZ2TzQuWkuZoA\"}]"` | Env. Var PNP_KEYS_VERSIONS |
| env.pnp.pnpMockDeck | string | `"0xbf8a2b73baf8402f8fe906ad3f42b560bf14b39f7df7797ece9e293d6f162188"` | Env. Var PNP_MOCK_DECK |
| env.pnp.pnpOdisServicesSigners | string | `"[{\"url\": \"https://staging-pgpnp-signer0.azurefd.net\", \"fallbackUrl\": \"http://52.154.55.35\"},{\"url\": \"https://staging-pgpnp-signer1.azurefd.net\", \"fallbackUrl\": \"http://13.89.116.218\"},{\"url\": \"https://staging-pgpnp-signer2.azurefd.net\", \"fallbackUrl\": \"http://20.84.128.169\"}]"` | Env. Var PNP_ODIS_SERVICES_SIGNERS |
| env.pnp.pnpOdisServicesTimeoutMilliseconds | string | `"5000"` | Env. Var PNP_ODIS_SERVICES_TIMEOUT_MILLISECONDS |
| env.pnp.pnpServiceName | string | `"odis_combiner"` | Env. Var PNP_SERVICE_NAME |
| env.pnp.pnpShouldAuthenticate | bool | `false` | Env. Var PNP_SHOULD_AUTHENTICATE |
| env.pnp.pnpShouldMockAccountService | bool | `false` |  |
| env.pnp.pnpShoulñdCheckQuota | bool | `false` | Env. Var PNP_SHOULD_CHECK_QUOTA |
| env.service.serviceName | string | `"odis-combiner"` | Env. Var SERVICE_NAME |
| env.tracing.enabled | bool | `false` | Enable tracing |
| env.tracing.endpoint | string | `"https://<GRAFANA_AGENT_URL>/api/traces"` | Env. Var TRACER_ENDPOINT. If enabled is false, will not be added to the deployment. |
| env.tracing.serviceName | string | `"odis-combiner-env-cluster"` | Env. Var TRACING_SERVICE_NAME. If enabled is false, will not be added to the deployment. |
| fullnameOverride | string | `""` | Chart full name override |
| image.pullPolicy | string | `"Always"` | Image pullpolicy |
| image.repository | string | `"us-west1-docker.pkg.dev/devopsre/dev-images/odis-combiner"` | Image repository |
| image.tag | string | `"4c00727348979093a76a7aa5b1ba7ea7bf5ac9cf"` | Image tag Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | Image pull secrets |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.className | string | `"nginx"` | Ingress class name |
| ingress.enabled | bool | `false` | Enable ingress resource |
| ingress.hosts | list | `[]` | Ingress hostnames |
| ingress.tls | list | `[]` | Ingress TLS configuration |
| livenessProbe | object | `{}` | Liveness probe configuration |
| nameOverride | string | `""` | Chart name override |
| nodeSelector | object | `{}` | Kubernetes node selector |
| podAnnotations | object | `{"prometheus.io/path":"/metrics","prometheus.io/port":"8080","prometheus.io/scrape":"true"}` | Custom pod annotations |
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
