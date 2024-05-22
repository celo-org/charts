# cel2-migration-tool

![Version: 0.0.2](https://img.shields.io/badge/Version-0.0.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

Node migration tool for Cel2 network

**Homepage:** <https://clabs.co>

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
| cel2NetworkName | string | `"myNetwork"` |  |
| download.config | string | `"https://storage.googleapis.com/cel2-rollup-files/jctestnet/config.json"` |  |
| download.deploymentL1 | string | `"https://storage.googleapis.com/cel2-rollup-files/jctestnet/deployment-l1.json"` |  |
| gcsBucket | string | `"cel2-node-files/"` |  |
| l1Url | string | `"https://ethereum-holesky-rpc.publicnode.com"` |  |
| opGeth.image.pullPolicy | string | `"Always"` |  |
| opGeth.image.repository | string | `"us-west1-docker.pkg.dev/blockchaintestsglobaltestnet/dev-images/op-geth"` |  |
| opGeth.image.tag | string | `"3d6a0e48e00137e581ee064db9cafa8300598771"` |  |
| pvc.input | string | `"myNetwork-input"` |  |
| pvc.output | string | `"myNetwork-output"` |  |
| schedule | string | `"0 0 30 2 0"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.