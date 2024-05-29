# op-tx-overload

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: test](https://img.shields.io/badge/AppVersion-test-informational?style=flat-square)

A Helm chart for Kubernetes

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Kubernetes pod affinity |
| args | list | `[]` | Args for the deployment. |
| command | list | `[]` | Command for the deployment. "./tx-overload" if empty. |
| fullnameOverride | string | `""` | Chart full name override |
| image.pullPolicy | string | `"IfNotPresent"` | Image pullpolicy |
| image.repository | string | `"us-west1-docker.pkg.dev/devopsre/dev-images/tx-overload"` | Image repository |
| image.tag | string | `"test"` | Image tag Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | Image pull secrets |
| metrics.enabled | bool | `true` | Enable metrics |
| nameOverride | string | `""` | Chart name override |
| nodeSelector | object | `{}` | Kubernetes node selector |
| podAnnotations | object | `{}` | Custom pod annotations |
| podLabels | object | `{}` | Custom pod labels |
| podSecurityContext | object | `{}` | Custom pod security context |
| replicaCount | int | `1` | Number of deployment replicas |
| resources | object | `{}` | Container resources |
| secretEnv | object | `{}` | Env Vars. mounted from a secret |
| securityContext | object | `{}` | Custom container security context |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Kubernetes tolerations |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)