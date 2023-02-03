# safe-transaction-service

Helm chart for deploying Celo Safe Transaction Service

![Version: 1.1.4](https://img.shields.io/badge/Version-1.1.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

- [celo-safe-transaction-service](#celo-safe-transaction-service)
  - [Chart requirements](#chart-requirements)
    - [Required sub-charts](#required-sub-charts)
  - [Chart releases](#chart-releases)
  - [Values](#values)

## Chart requirements

- Tested with Kubernetes 1.23
- Tested with Helm v3.9.4

### Required sub-charts

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 11.9.11 |
| https://charts.bitnami.com/bitnami | rabbitmq | 11.0.4 |
| https://charts.bitnami.com/bitnami | redis | 17.3.7 |

## Chart releases

Chart is released to oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci/celo-safe-transaction-service repository automatically every commit to `master` branch.
Just remind yourself to bump the version of the chart in the [Chart.yaml](./Chart.yaml) file.
This process is configured using GitHub Actions in the [helm_release.yml](../../.github/workflows/helm_release.yml)
and [helm_test.yml](../../.github/workflows/helm_test.yml) files.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Kubernetes pod affinity |
| contractsTokenWorker | object | `{}` | Contracts-token-worker especific values. Has priority over common values. |
| env.clientGatewayUri | string | `"test"` | Client Gateway URL |
| env.djangoSecretKey | string | `""` | Django Secret Key |
| env.djangoSettingsModule | string | `"config.settings.local"` | Django settings module |
| env.ethereumNodeUrl | string | `"https://forno.celo.org"` | Ethereum Node enviromental variable |
| env.webhookToken | string | `"test"` | Token for the webhook to flush the cache |
| flower | object | `{"ingress":{"annotations":{},"className":"nginx","enabled":false,"hosts":[],"tls":[]},"service":{"port":5555,"type":"ClusterIP"}}` | Flower especific values. Has priority over common values. |
| flower.ingress.annotations | object | `{}` | Flower custom Ingress annotations  |
| flower.ingress.className | string | `"nginx"` | Flower Ingress class name |
| flower.ingress.enabled | bool | `false` | Flower Ingress enabled |
| flower.ingress.hosts | list | `[]` | Flower list of hosts to expose flower component. See values.yaml for an example. |
| flower.ingress.tls | list | `[]` | Flower TLS secret for exposing flower component with https. See values.yaml for an example. |
| flower.service.port | int | `5555` | Port for flower service |
| flower.service.type | string | `"ClusterIP"` | Flower Kubernetes Service Type |
| fullnameOverride | string | `""` | Chart full name override |
| global.postgresql.auth.database | string | `""` | Postgresql depencency chart database for storing data |
| global.postgresql.auth.postgresPassword | string | `"test"` | Postgresql depencency chart password |
| global.postgresql.service.ports.postgresql | int | `5432` | Postgresql depencency chart service port |
| global.redis.password | string | `"test"` | Redis depencency chart password |
| image.pullPolicy | string | `"IfNotPresent"` | Image pullpolicy |
| image.repository | string | `"us-central1-docker.pkg.dev/clabs-gnosis-safe/safe-transaction-service"` | Image repository |
| image.tag | string | `"61ee03ee2f712941c2b319d1cf2240c414a2177c"` | Image tag Please override in terraform via celo-org/infrastructure/terraform-modules/clabs-gnosis-safe-staging/files/transaction-service-values.yaml |
| imagePullSecrets | list | `[]` | Image pull secrets |
| indexerWorker | object | `{}` | Indexer-worker deployment especific values. Has priority over common values. |
| livenessProbe | object | `{"httpGet":{"path":"/","port":"http"},"timeoutSeconds":60}` | Liveness probe configuration |
| nameOverride | string | `""` | Chart name override |
| nodeSelector | object | `{}` | Kubernetes node selector |
| notificationsWebhooksWorker | object | `{}` | Notifications-webhook-worker especific values. Has priority over common values. |
| podAnnotations | object | `{}` | Custom pod annotations |
| podSecurityContext | object | `{}` | Custom pod security context |
| postgresql.image.tag | string | `"13.8.0"` | Postgresql depencency chart image tag (version) |
| rabbitmq.auth.password | string | `"test"` | RabbitMQ depencency chart password |
| readinessProbe | object | `{"httpGet":{"path":"/","port":"http"},"timeoutSeconds":60}` | Readiness probe configuration |
| redis.image.tag | string | `"6.2.7"` | Redis depencency chart image tag (version) |
| redis.replica.replicaCount | int | `1` | Redis depencency chart replicas |
| replicaCount | int | `1` | Common number of deployment replicas (applied to all deployments) |
| resources | object | `{}` | Common container resources (applied to all deployments) |
| scheduler | object | `{}` | Scheduler especific values. Has priority over common values. |
| securityContext | object | `{}` | Custom container security context |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Kubernetes tolerations |
| web | object | `{"ingress":{"annotations":{},"className":"nginx","enabled":false,"hosts":[],"tls":[]},"service":{"port":80,"type":"ClusterIP"}}` | Web especific values. Has priority over common values. |
| web.ingress.annotations | object | `{}` | Web custom Ingress annotations  |
| web.ingress.className | string | `"nginx"` | Web Ingress class name |
| web.ingress.enabled | bool | `false` | Web Ingress enabled |
| web.ingress.hosts | list | `[]` | Web list of hosts to expose web component. See values.yaml for an example. |
| web.ingress.tls | list | `[]` | Web TLS secret for exposing web component with https. See values.yaml for an example. |
| web.service.port | int | `80` | Port for web service |
| web.service.type | string | `"ClusterIP"` | Web Kubernetes Service Type |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0). To regenerate run `helm-docs` command at this folder.
