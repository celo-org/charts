# dshackle

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.15.1](https://img.shields.io/badge/AppVersion-0.15.1-informational?style=flat-square)

A Helm chart for dshackle - A Fault Tolerant Load Balancer for Blockchain API.

Based on [Emerald Dshackle](https://github.com/emeraldpay/dshackle).

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Kubernetes pod affinity |
| config | string | `""` |  |
| env | object | `{}` | Env. vars. from secrets as <ENV_VAR_NAME>.secretName and <ENV_VAR_NAME>.secretKey |
| fullnameOverride | string | `""` | Chart full name override |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"emeraldpay/dshackle"` |  |
| image.tag | string | `"0.15.1"` |  |
| imagePullSecrets | list | `[]` | Image pull secrets |
| ingress.annotations | object | `{}` | Custom Ingress annotations |
| ingress.className | string | `"nginx"` | Ingress class name |
| ingress.enabled | bool | `false` | Ingress enabled |
| ingress.hosts | list | `[]` | List of hosts to expose safe-config-service. See values.yaml for an example. |
| ingress.tls | list | `[]` | TLS secret for exposing safe-config-service with https. See values.yaml for an example. |
| livenessProbe | object | `{}` | Liveness probe configuration |
| nameOverride | string | `""` | Chart name override |
| nodeSelector | object | `{}` | Kubernetes node selector |
| podAnnotations | string | `nil` | Custom pod annotations |
| podLabels | object | `{}` | Custom pod labels |
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
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
