# celox

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 570fb7ee5fe1a43b35b3ecffb92a798187e8af53](https://img.shields.io/badge/AppVersion-570fb7ee5fe1a43b35b3ecffb92a798187e8af53-informational?style=flat-square)

Transaction load generator for Celo chains, with CIP-64 fee-currency, calldata and contract-storage workloads.

## Usage

celox reads its root key from the `CELOX_PRIVATE_KEY` environment variable and
deliberately refuses a command-line flag, so it must be supplied through
`secretEnv`:

```yaml
secretEnv:
  CELOX_PRIVATE_KEY:
    secretName: celox
    secretKey: privateKey
```

That account funds every sender at startup — celox tops each one up to
`config.fund` and refuses to start if the root cannot cover all of it, so
funding is all-or-nothing rather than an airdrop that dies halfway.

### Soak vs one-shot

`kind: Deployment` (the default) runs until the release is scaled down or
deleted. `kind: Job` requires `config.duration` and turns the run into a
pass/fail artifact: celox exits 0 only if every transaction it sent was
confirmed with status 1, and a run that sent nothing also fails, which makes it
usable as a CI gate.

### Scaling

`replicas` is fixed at 1 and not configurable. Sender keys are derived as
`keccak256(root_key || "celox" || index)` over `0..senders` with no per-replica
offset, so two pods sharing a root key would drive the same accounts and fight
over nonces. Increase `config.tps` and `config.senders` instead.

### Workloads

| `config.workload` | What each transaction does                             | Extra values                           |
|-------------------|--------------------------------------------------------|----------------------------------------|
| `transfer`        | 1-wei native self-transfer, the cheapest baseline      | —                                      |
| `calldata`        | Random calldata to a burner account                    | `config.dataSize`                      |
| `cip64`           | Self-transfer paying gas in a fee currency (type 0x7b) | `config.feeCurrency`, `config.fundToken` |
| `storage`         | Writes storage slots in one shared contract            | `config.writes`, `config.keySpace`     |

Only the flags the selected workload reads are rendered. `cip64` fails
templating without `config.feeCurrency`, as does `kind: Job` without
`config.duration`.

celox reports to stdout and exposes no metrics endpoint, so this chart creates
no Service and no scrape annotations.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cLabs | <devops@clabs.co> | <https://clabs.co> |

## Source Code

* <https://github.com/palango/celox>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Kubernetes pod affinity |
| config.dataSize | int | `1024` | Calldata payload size in bytes. Only used by the `calldata` workload. |
| config.duration | string | `""` | How long to send for, e.g. `30m`. Empty means run until stopped, which is only valid for `kind: Deployment`. |
| config.feeCurrency | string | `""` | Fee currency address. Required by the `cip64` workload, ignored otherwise. Validated against the chain's FeeCurrencyDirectory; adapter currencies (USDC, USDT) are rejected because celox cannot move them to fund senders. |
| config.fund | string | `"0.1"` | Native balance each sender is topped up to at startup, in CELO |
| config.fundToken | string | `"1"` | Fee-currency balance each sender is topped up to, in whole tokens. Only used by the `cip64` workload. |
| config.keySpace | int | `1000000` | Slot range the `storage` workload writes into. A wide range grows the state trie; a narrow one contends on hot slots. |
| config.pollInterval | string | `"250ms"` | How often to poll for receipts. Raising this reduces the read load celox itself puts on the node. |
| config.receiptTimeout | string | `"15s"` | How long to wait for a receipt before counting a transaction as dropped |
| config.rpcUrl | string | `"http://op-reth-sequencer-shared-rpc:8545"` | JSON-RPC endpoint of the target chain |
| config.senders | int | `10` | Number of sender accounts, derived deterministically from the root key |
| config.tps | int | `10` | Target transactions per second across all senders |
| config.window | int | `10` | Maximum transactions in flight per sender. Nodes cap pending transactions per account (16 in reth), so a deeper window only earns rejections. |
| config.workload | string | `"transfer"` | Workload to generate. One of `transfer`, `calldata`, `cip64`, `storage`. |
| config.writes | int | `5` | Storage slots each transaction writes. Only used by the `storage` workload. |
| extraArgs | list | `[]` | Extra args appended to the celox command, as a list. |
| fullnameOverride | string | `""` | Chart full name override |
| image.pullPolicy | string | `"IfNotPresent"` | Image pullpolicy |
| image.repository | string | `"us-west1-docker.pkg.dev/devopsre/dev-images/celox"` | Image repository |
| image.tag | string | `""` | Image tag. Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | Image pull secrets |
| job | object | `{"backoffLimit":0,"ttlSecondsAfterFinished":86400}` | Settings that apply only when `kind: Job` |
| job.backoffLimit | int | `0` | Retries before the Job is marked failed. Zero keeps a failed load test failed instead of silently re-running it. |
| job.ttlSecondsAfterFinished | int | `86400` | Delete the finished Job (and its pod) this many seconds after it ends. Null keeps it until deleted by hand. |
| kind | string | `"Deployment"` | Workload primitive. `Deployment` soaks until scaled down; `Job` runs once and its exit code is the verdict (celox exits 0 only if every transaction it sent was confirmed with status 1), which makes it usable as a CI gate. A `Job` needs `config.duration` set, or it never terminates. |
| nameOverride | string | `""` | Chart name override |
| nodeSelector | object | `{}` | Kubernetes node selector |
| podAnnotations | object | `{}` | Custom pod annotations |
| podLabels | object | `{}` | Custom pod labels |
| podSecurityContext | object | `{}` | Custom pod security context |
| resources | object | `{}` | Container resources |
| secretEnv | object | `{}` | Env vars mounted from a secret. celox reads the root key from `CELOX_PRIVATE_KEY` and refuses a command-line flag, so it must be set here. |
| securityContext | object | `{}` | Custom container security context |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `false` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Kubernetes tolerations |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
