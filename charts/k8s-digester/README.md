# k8s-digester

![Version: 0.1.4](https://img.shields.io/badge/Version-0.1.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.10](https://img.shields.io/badge/AppVersion-v0.1.10-informational?style=flat-square)

K8S Digester translates images tags to shas

**Homepage:** <https://github.com/google/k8s-digester>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://github.com/google/k8s-digester/tree/main/manifests>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | string | `"podAntiAffinity:\n  preferredDuringSchedulingIgnoredDuringExecution:\n  - weight: 100\n    podAffinityTerm:\n      topologyKey: kubernetes.io/hostname\n      labelSelector:\n        matchLabels:\n          app.kubernetes.io/name: {{ include \"digester-system.name\" . }}\n          app.kubernetes.io/instance: {{ .Release.Name }}\n"` | Kubernetes pod affinity |
| fullnameOverride | string | `""` | Chart full name override |
| image.pullPolicy | string | `"IfNotPresent"` | Image pullpolicy |
| image.repository | string | `"ghcr.io/google/k8s-digester"` | Image repository |
| image.tag | string | `"v0.1.15@sha256:52740b9bdf2d334580749e5d2f8c6a6c16bba996319c89f0bdea9cdaa98a3efc"` | Image tag |
| imagePullSecrets | list | `[]` | Image pull secrets |
| nameOverride | string | `""` | Chart name override trigger |
| nodeSelector | object | `{}` | Kubernetes node selector |
| podAnnotations | object | `{}` | Custom pod annotations |
| podSecurityContext | object | `{}` | Custom pod security context |
| rbac.create | bool | `true` | Specifies whether RBAC resources should be created |
| replicaCount | int | `3` | Number of deployment replicas |
| resources | object | `{"requests":{"cpu":"100m","ephemeral-storage":"256Mi","memory":"256Mi"}}` | Container resources |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["all"]},"readOnlyRootFilesystem":true,"runAsGroup":65532,"runAsNonRoot":true,"runAsUser":65532}` | Custom container security context |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Kubernetes tolerations |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
