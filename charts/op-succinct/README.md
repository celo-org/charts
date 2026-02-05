# op-succinct

![Version: 1.2.0-rc.1](https://img.shields.io/badge/Version-1.2.0--rc.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.0](https://img.shields.io/badge/AppVersion-1.1.0-informational?style=flat-square)

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
| config.game.disable_monitor_only | bool | `false` | If the monitor-only mode is disabled, the challenger will try to send `challenge()` calls onchain in case of a challenger (challenger only). |
| config.game.dispute_game_factory_address | string | `""` | Address of the active L1 `DisputeGameFactoryProxy` address |
| config.game.malicious_challenge_percentage | string | `"0.0"` | Percentage (0.0-100.0) of valid games to challenge for testing defense mechanisms (challenger only) |
| config.google_kms_signing.hsm_key_name | string | `""` | Name of the HSM key within the keyring |
| config.google_kms_signing.hsm_key_version | int | `2` | Version number of the HSM key to use for signing |
| config.google_kms_signing.keyring | string | `""` | GCP KMS keyring name containing the signing key |
| config.google_kms_signing.location | string | `""` | GCP region/location where the KMS keyring is deployed, e.g., "global" |
| config.google_kms_signing.project_id | string | `""` | GCP project ID where the KMS resources are located |
| config.intervals.fetch | int | `30` | Fetch interval |
| config.intervals.proposal | int | `20` | Proposal interval in blocks (proposer only) |
| config.metrics.addr | string | `"0.0.0.0"` |  |
| config.metrics.enabled | bool | `true` |  |
| config.metrics.port | int | `7300` |  |
| config.proof.agg_cycle_limit | string | `"1000000000000"` |  |
| config.proof.agg_gas_limit | string | `"1000000000000"` | The gas limit to use for aggregation proofs. |
| config.proof.agg_proof_mode | string | `"plonk"` | Changing the proof mode requires updating the SP1_VERIFIER address in contracts/src/fp/OPSuccinctFaultDisputeGame.sol to the corresponding verifier gateway contract. |
| config.proof.max_concurrent_range_proofs | int | `1` | on observed latency, and system resources before deviating from default. |
| config.proof.range_cycle_limit | string | `"1000000000000"` | The cycle limit to use for range proofs. |
| config.proof.range_gas_limit | string | `"1000000000000"` | The gas limit to use for range proofs. |
| config.proof.range_split_count | int | `1` | The number of segments to split the range into (1-16) (default: 1). |
| config.proof.timeout | int | `14400` | The proving timeout (in seconds). Used as the server-side deadline for proof requests and as the client-side maximum wait time when polling for proof completion. |
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
| image.repository | string | `"us-west1-docker.pkg.dev/devopsre/celo-blockchain-public/op-succinct-proposer"` | Image repository base |
| image.tag | string | `"1.0.2"` | Image tag Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | Image pull secrets |
| livenessProbe | object | `{}` | Liveness probe configuration |
| mode | string | `"proposer"` | Mode to run in (proposer or challenger) |
| nameOverride | string | `""` | Chart name override |
| nodeSelector | object | `{}` | Kubernetes node selector |
| persistence.enabled | bool | `false` |  |
| persistence.mountPath | string | `"/data"` |  |
| persistence.pvc.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.pvc.annotations | object | `{}` |  |
| persistence.pvc.size | string | `"1Gi"` |  |
| persistence.pvc.storageClass | string | `""` |  |
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
