# op-succinct

![Version: 0.2.1](https://img.shields.io/badge/Version-0.2.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: main](https://img.shields.io/badge/AppVersion-main-informational?style=flat-square)

A Helm chart for op-succinct proposer and challenger

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://github.com/celo-org/op-succinct>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Kubernetes pod affinity |
| config.endpoints.eigenda_proxy | string | `""` | URL of the EigenDA proxy |
| config.endpoints.l1_consensus | string | `""` | URL of the L1 consensus (beacon) client (proposer only) |
| config.endpoints.l1_execution | string | `""` | URL of the L1 execution client |
| config.endpoints.l2_consensus | string | `""` | URL of the L2 consensus (op-node) client (proposer only) |
| config.endpoints.l2_execution | string | `""` | URL of the L2 execution (op-geth) client |
| config.game.dispute_game_factory_address | string | `""` | Address of the active L1 `DisputeGameFactoryProxy` address |
| config.game.malicious_challenge_percentage | string | `"0.0"` |  |
| config.game.max_game_limits | object | `{"bond_claiming":100,"challenge":100,"defense":100,"resolution":100}` | maximum size of the queue that processes games for different operations |
| config.game.max_game_limits.bond_claiming | int | `100` | queue size to reclaim bonds from games |
| config.game.max_game_limits.challenge | int | `100` | queue size to challenge games |
| config.game.max_game_limits.defense | int | `100` | queue size to defend games |
| config.game.max_game_limits.resolution | int | `100` | queue size to resolve games |
| config.game.resolution | bool | `true` | enable game-resolution |
| config.intervals.fetch | int | `30` | Fetch interval |
| config.intervals.proposal | int | `20` | Proposal interval in blocks (proposer only) |
| config.metrics.addr | string | `"0.0.0.0"` |  |
| config.metrics.enabled | bool | `true` |  |
| config.metrics.port | int | `7300` |  |
| config.remote_signing.enabled | bool | `true` | of reading the "PRIVATE_KEY" env-var and signing locally. |
| config.remote_signing.endpoint | string | `""` | Note that this currently only works, when TLS is disabled in the signer-service |
| config.remote_signing.signer_address | string | `""` | Address of the signer, will get used as the 'from' address in `eth_signTransaction` call |
| config.secret_env | object | `{"existing_name":"","overwrites":{}}` | the `PRIVATE_KEY` is only required when `config.remote_signing.enabled` is `false`. |
| config.secret_env.existing_name | string | `""` | Use an existing kubernetes secret by it's secret name |
| config.secret_env.overwrites | object | `{}` | into the executor. |
| enableServiceLinks | bool | `false` | Kubernetes enableServiceLinks |
| extraArgs | list | `[]` |  |
| fullnameOverride | string | `""` | Chart full name override |
| image.pullPolicy | string | `"IfNotPresent"` | Image pullpolicy |
| image.repository | string | `"us-west1-docker.pkg.dev/devopsre/dev-images/op-succinct/proposer"` | Image repository base (will be combined with mode, like <repository>/op-succinct-<mode>:<tag>) |
| image.tag | string | `"sha-bd79cc6"` | Image tag Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | Image pull secrets |
| livenessProbe | object | `{}` | Liveness probe configuration |
| mode | string | `"proposer"` | Mode to run in (proposer or challenger) |
| nameOverride | string | `""` | Chart name override |
| nodeSelector | object | `{}` | Kubernetes node selector |
| podAnnotations | object | `{}` | Custom pod annotations |
| podLabels | object | `{}` | Custom pod labels |
| podSecurityContext | object | `{}` | Custom pod security context |
| readinessProbe | object | `{}` | Readiness probe configuration |
| replicaCount | int | `1` | Number of deployment replicas |
| resources | object | `{}` | Container resources |
| securityContext | object | `{}` | Custom container security context |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| services.metrics.annotations | object | `{}` |  |
| services.metrics.enabled | bool | `true` |  |
| services.metrics.port | int | `7300` |  |
| services.metrics.publishNotReadyAddresses | bool | `true` |  |
| services.metrics.type | string | `"ClusterIP"` |  |
| tolerations | list | `[]` | Kubernetes tolerations |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
