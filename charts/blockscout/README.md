# blockscout

Chart which is used to deploy Blockscout for Celo Networks

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.0.4-beta](https://img.shields.io/badge/AppVersion-v2.0.4--beta-informational?style=flat-square)

- [blockscout](#blockscout)
  - [Chart requirements](#chart-requirements)
  - [Chart releases](#chart-releases)
  - [More relevant values](#more-relevant-values)
  - [Ingress setup](#ingress-setup)
  - [Basic chart operation](#basic-chart-operation)
  - [Values](#values)

## Chart requirements

- Tested with Kubernetes >=1.23
- Tested with Helm >=v3.9.4

Apart from that, this chart requires the next external dependencies to be accesible:

- Celo archive node endpoints for RPC and WS (see [celo-fullnode](../celo-fullnode/README.md) chart, or use a public provider)
- A Cloud SQL Postgres instance for the database.
- Secret Manager with required secrets already provided and accesible. These secret references are defined in the [values.yaml](./values.yaml) file.

## Chart releases

Chart is released to oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci/blockscout repository automatically every commit to `main` branch.
Just remind yourself to bump the version of the chart in the [Chart.yaml](./Chart.yaml) file.
This process is configured using GitHub Actions in the [helm_release.yml](../../.github/workflows/helm_release.yml)
and [helm_test.yml](../../.github/workflows/helm_test.yml) files.

## Basic chart operation

To install/manage a release named `celo-mainnet-fullnode` connected to `mainnet` in namespace `celo` using `values-mainnet-node.yaml` custom values:

```bash
# Select the chart release to use
CHART_RELEASE="oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci/blockscout --version=1.0.0" # Use remote chart and specific version
CHART_RELEASE="./" # Use this local folder

# (Only for local chart) Sync helm dependencies
helm dependency update

# (Optional) Render the chart template to check the templates
helm template my-blockscout --create-namespace -f values-alfajores-blockscout2.yaml --namespace=celo --output-dir=/tmp "$CHART_RELEASE"

# Installing the chart
helm install my-blockscout --create-namespace -f values-alfajores-blockscout2.yaml --namespace=celo "$CHART_RELEASE"

# (Optional) Check a diff when upgrading the chart
# Using https://github.com/databus23/helm-diff
helm diff -C5 upgrade my-blockscout -f values-alfajores-blockscout2.yaml --namespace=celo "$CHART_RELEASE"

# Upgrade the chart
helm upgrade my-blockscout -f values-alfajores-blockscout2.yaml --namespace=celo "$CHART_RELEASE"
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| blockscout.api | object | `{"affinity":{},"autoscaling":{"maxReplicas":10,"minReplicas":2,"target":{"cpu":70}},"db":{"connectionName":"project:region:db-name","name":"blockscout","port":5432,"proxy":{"host":"127.0.0.1","livenessProbe":{},"port":5432,"readinessProbe":{},"resources":{"requests":{"cpu":"10m","memory":"20Mi"}}}},"livenessProbe":{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":5},"nodeSelector":{},"poolSize":30,"poolSizeReplica":5,"port":4000,"primaryRpcRegion":"indexer","rateLimit":"1000000","readinessProbe":{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":5},"resources":{"requests":{"cpu":0.5,"memory":"500Mi"}},"rpcRegion":"api","strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":"20%"}},"suffix":{"enabled":false,"path":""}}` | Configuraton for the api component |
| blockscout.api.affinity | object | `{}` | affinity for api pods |
| blockscout.api.autoscaling | object | `{"maxReplicas":10,"minReplicas":2,"target":{"cpu":70}}` | HPA configuration for api deployment |
| blockscout.api.db | object | `{"connectionName":"project:region:db-name","name":"blockscout","port":5432,"proxy":{"host":"127.0.0.1","livenessProbe":{},"port":5432,"readinessProbe":{},"resources":{"requests":{"cpu":"10m","memory":"20Mi"}}}}` | Database configuration for indexer. Prepared to be used with CloudSQL |
| blockscout.api.db.connectionName | string | `"project:region:db-name"` | Name of the CloudSQL connection to use |
| blockscout.api.db.name | string | `"blockscout"` | Name of the database to use. Database is created if it does not exist |
| blockscout.api.db.proxy | object | `{"host":"127.0.0.1","livenessProbe":{},"port":5432,"readinessProbe":{},"resources":{"requests":{"cpu":"10m","memory":"20Mi"}}}` | Configuration for the CloudSQL proxy (https://cloud.google.com/sql/docs/mysql/sql-proxy) |
| blockscout.api.db.proxy.livenessProbe | object | `{}` | livenessProbe for cloud-sql container |
| blockscout.api.db.proxy.readinessProbe | object | `{}` | livinessProbe for cloud-sql container |
| blockscout.api.db.proxy.resources | object | `{"requests":{"cpu":"10m","memory":"20Mi"}}` | resources for cloud-sql container |
| blockscout.api.livenessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":5}` | livenessProbe for api container |
| blockscout.api.nodeSelector | object | `{}` | nodeSelector for api pods |
| blockscout.api.poolSize | int | `30` | Max number of DB connections excluding read-only API endpoints requests |
| blockscout.api.poolSizeReplica | int | `5` | Max number of DB connections for read-only API endpoints requests |
| blockscout.api.primaryRpcRegion | string | `"indexer"` | PRIMARY_REGION env variable for api pod. Do not change. |
| blockscout.api.rateLimit | string | `"1000000"` | request rateLimit for api coponent |
| blockscout.api.readinessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":5}` | readinessProbe for api container |
| blockscout.api.resources | object | `{"requests":{"cpu":0.5,"memory":"500Mi"}}` | resources for api container |
| blockscout.api.rpcRegion | string | `"api"` | MY_REGION env variable for api pod. Do not change. |
| blockscout.api.strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":"20%"}}` | UpdateStrategy for api deployment |
| blockscout.api.suffix | object | `{"enabled":false,"path":""}` | If api component is served at rootPath |
| blockscout.eventStream | object | `{"beanstalkdHost":"","beanstalkdPort":"","enableEventStream":false,"livenessProbe":{},"port":4000,"readinessProbe":{},"replicas":0,"resources":{"requests":{"cpu":2,"memory":"1000Mi"}},"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}` | Configuraton for the eventStream component |
| blockscout.eventStream.beanstalkdHost | string | `""` | `BEANSTALKD_HOST` env for eventStream deployment |
| blockscout.eventStream.beanstalkdPort | string | `""` | `BEANSTALKD_PORT` env for eventStream deployment |
| blockscout.eventStream.enableEventStream | bool | `false` | Enable the eventStream component |
| blockscout.eventStream.livenessProbe | object | `{}` | livenessProbe for eventStream container |
| blockscout.eventStream.readinessProbe | object | `{}` | readinessProbe for eventStream container |
| blockscout.eventStream.replicas | int | `0` | replicas for eventStream deployment |
| blockscout.eventStream.resources | object | `{"requests":{"cpu":2,"memory":"1000Mi"}}` | resources for eventStream container |
| blockscout.eventStream.strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}` | UpdateStrategy for eventStream deployment |
| blockscout.indexer | object | `{"affinity":{},"db":{"connectionName":"project:region:db-name","name":"blockscout","port":5432,"proxy":{"host":"127.0.0.1","livenessProbe":{},"port":5432,"readinessProbe":{},"resources":{"requests":{"cpu":"100m","memory":"40Mi"}}}},"fetchers":{"blockRewards":{"enabled":false}},"livenessProbe":{},"nodeSelector":{},"poolSize":200,"poolSizeReplica":5,"port":4001,"primaryRpcRegion":"indexer","readinessProbe":{"failureThreshold":5,"httpGet":{"path":"/health/readiness","port":"health","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":5},"resources":{"requests":{"cpu":2,"memory":"2G"}},"rpcRegion":"indexer","strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}},"terminationGracePeriodSeconds":60}` | Configuraton for the indexer component |
| blockscout.indexer.affinity | object | `{}` | affinity for indexer pods |
| blockscout.indexer.db | object | `{"connectionName":"project:region:db-name","name":"blockscout","port":5432,"proxy":{"host":"127.0.0.1","livenessProbe":{},"port":5432,"readinessProbe":{},"resources":{"requests":{"cpu":"100m","memory":"40Mi"}}}}` | Database configuration for indexer. Prepared to be used with CloudSQL |
| blockscout.indexer.db.connectionName | string | `"project:region:db-name"` | Name of the CloudSQL connection to use |
| blockscout.indexer.db.name | string | `"blockscout"` | Name of the database to use. Database is created if it does not exist |
| blockscout.indexer.db.proxy | object | `{"host":"127.0.0.1","livenessProbe":{},"port":5432,"readinessProbe":{},"resources":{"requests":{"cpu":"100m","memory":"40Mi"}}}` | Configuration for the CloudSQL proxy (https://cloud.google.com/sql/docs/mysql/sql-proxy) |
| blockscout.indexer.db.proxy.livenessProbe | object | `{}` | livenessProbe for cloud-sql container |
| blockscout.indexer.db.proxy.readinessProbe | object | `{}` | readinessProbe for cloud-sql container |
| blockscout.indexer.db.proxy.resources | object | `{"requests":{"cpu":"100m","memory":"40Mi"}}` | resources for cloud-sql container |
| blockscout.indexer.fetchers | object | `{"blockRewards":{"enabled":false}}` | Enable CELO blockRewards functionality |
| blockscout.indexer.livenessProbe | object | `{}` | livenessProbe for indexer container |
| blockscout.indexer.nodeSelector | object | `{}` | nodeSelector for indexer pods |
| blockscout.indexer.poolSize | int | `200` | Max number of DB connections excluding read-only API endpoints requests |
| blockscout.indexer.poolSizeReplica | int | `5` | Max number of DB connections for read-only API endpoints requests |
| blockscout.indexer.primaryRpcRegion | string | `"indexer"` | PRIMARY_REGION env variable for indexer pod. Do not change. |
| blockscout.indexer.readinessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/health/readiness","port":"health","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":5}` | readinessProbe for indexer container |
| blockscout.indexer.resources | object | `{"requests":{"cpu":2,"memory":"2G"}}` | resources for indexer container |
| blockscout.indexer.rpcRegion | string | `"indexer"` | MY_REGION env variable for indexer pod. Do not change. |
| blockscout.indexer.strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}` | UpdateStrategy for indexer deployment |
| blockscout.indexer.terminationGracePeriodSeconds | int | `60` | termination timeout for indexer pod |
| blockscout.metadataCrawler | object | `{"discordClusterName":"","enabled":false,"image":{"repository":"gcr.io/celo-testnet/celo-monorepo","tag":"metadata-crawler-77a392216d4927e85ce4b683508fc0539aa92a34"},"schedule":"0 */2 * * *"}` | Configuraton for the metadataCrawler component |
| blockscout.metadataCrawler.discordClusterName | string | `""` | Discord server for notifications |
| blockscout.metadataCrawler.schedule | string | `"0 */2 * * *"` | Cron schedule for the metadataCrawler |
| blockscout.shared.db | object | `{"drop":"false"}` | Drop the database on startup |
| blockscout.shared.epochRewards | object | `{"enabled":true}` | Enable epochRewards |
| blockscout.shared.erlangNodeName | string | `"blockscout"` |  |
| blockscout.shared.healthyBlocksPeriod | int | `300` | Max delay in seconds for the indexer to be considered unhealthy |
| blockscout.shared.image | object | `{"pullPolicy":"IfNotPresent","repository":"gcr.io/celo-testnet/blockscout","tag":"v2.0.4-beta-celo"}` | Image to use for blockscout components |
| blockscout.shared.secrets | object | `{"campaignBannerApiUrl":"","dbPassword":"","dbUser":"","discordWebhookUrl":"","erlang":{"cookie":""},"grafanaCloud":"","recaptcha":{"apiKey":"","projectId":"","secretKey":"","siteKey":""},"segmentKey":""}` | Reference to secrets. Format: gcp:secretmanager:projects/<project-id>/secrets/<env>-blockscout-<secret-key>. Using tool https://github.com/doitintl/secrets-init |
| blockscout.web | object | `{"accountPoolSize":1,"affinity":{},"appsMenu":{"connectList":"[{\"url\":\"https://impactmarket.com/\", \"title\":\"impactMarket\"}, {\"url\":\"https://talentprotocol.com/\", \"title\":\"Talent Protocol\"}, {\"url\":\"https://doni.app/\", \"title\":\"Doni\"}]","defiList":"[{\"url\":\"https://moola.market/\", \"title\":\"Moola\"},  {\"url\":\"https://www.pinnata.xyz/farm#/\", \"title\":\"Pinnata\"}, {\"url\":\"https://goodghosting.com/\", \"title\":\"GoodGhosting\"}, {\"url\":\"https://revo.market/\", \"title\":\"Revo\"}, {\"url\":\"https://www.immortaldao.finance\", \"title\":\"ImmortalDao Finance\"}]","enabled":true,"financeToolsList":"[{\"url\":\"https://celotracker.com/\", \"title\":\"Celo Tracker\"}, {\"url\":\"https://celo.tax/\", \"title\":\"celo.tax\"}, {\"url\":\"https://trelis.com/\", \"title\": \"Trelis\"}]","learningList":"[{\"url\": \"https://celo.org/papers/whitepaper\", \"title\":\"Celo Whitepaper\"}, {\"url\": \"https://learn.figment.io/protocols/celo\", \"title\":\"Learn Celo\"}, {\"url\": \"https://www.coinbase.com/price/celo\", \"title\":\"Coinbase Earn\"}]","nftList":"[{\"url\":\"https://niftydrop.net/\", \"title\":\"Niftydrop\"}, {\"url\":\"https://nfts.valoraapp.com/\", \"title\":\"NFT Viewer\"}, {\"url\":\"https://cyberbox.art/\", \"title\":\"Cyberbox\"}, {\"url\":\"https://nom.space/\", \"title\":\"Nomspace\"}, {\"url\":\"https://alities.io/\", \"title\":\"Alities\"}]","resourcesList":"[{\"url\":\"https://celovote.com/\", \"title\":\"Celo Vote\"}, {\"url\":\"https://forum.celo.org/\", \"title\":\"Celo Forum\"}, {\"url\":\"https://thecelo.com/\", \"title\":\"TheCelo\"}, {\"url\":\"https://celo.org/validators/explore\", \"title\":\"Validators\"}, {\"url\":\"https://celoreserve.org/\", \"title\":\"Celo Reserve\"}, {\"url\":\"https://docs.celo.org/\", \"title\":\"Celo Docs\"}]","spendList":"[{\"url\":\"https://giftcards.bidali.com/\", \"title\":\"Bidali\"}, {\"url\":\"https://flywallet.io/\", \"title\":\"Flywallet\"},{\"url\":\"https://chispend.com/\", \"title\":\"ChiSpend\"}]","swapList":"[{\"url\":\"https://ubeswap.org/\", \"title\":\"Ubeswap\"}, {\"url\":\"https://symmetric.finance/\", \"title\":\"Symmetric\"}, {\"url\":\"https://www.mobius.money/\", \"title\":\"Mobius\"}, {\"url\":\"https://mento.finance/\", \"title\":\"Mento-fi\"}, {\"url\":\"https://swap.bitssa.com/\", \"title\":\"Swap Bitssa\"}]","walletList":"[{\"url\":\"https://valoraapp.com/\", \"title\":\"Valora\"}, {\"url\":\"https://celoterminal.com/\", \"title\":\"Celo Terminal\"}, {\"url\":\"https://celowallet.app/\", \"title\":\"Celo Wallet\"}, {\"url\":\"https://www.nodewallet.xyz/\", \"title\":\"Node Wallet\"}]"},"autoscaling":{"maxReplicas":5,"minReplicas":2,"target":{"cpu":70}},"basicAuth":{"enabled":false},"campaignBanner":{"refreshInterval":"60"},"db":{"connectionName":"project:region:db-name","name":"blockscout","port":5432,"proxy":{"host":"127.0.0.1","livenessProbe":{},"port":5432,"readinessProbe":{},"resources":{"requests":{"cpu":"10m","memory":"20Mi"}}}},"extraEnvironments":{"source":[],"target":[]},"homepage":{"showPrice":true,"showTxs":false},"host":"","liveUpdates":{"disabled":true},"livenessProbe":{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":5},"nodeSelector":{},"poolSize":30,"poolSizeReplica":5,"port":4000,"primaryRpcRegion":"indexer","readinessProbe":{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":5},"recaptchaSecretName":"","resources":{"requests":{"cpu":"500m","memory":"250M"}},"rpcRegion":"web","sourcify":{"enabled":true,"repoUrl":"https://repo.sourcify.dev/contracts","serverUrl":"https://sourcify.dev/server"},"stats":{"enabled":false,"makerdojo":"","reportUrl":""},"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":"20%"}},"suffix":{"enabled":false,"path":""},"tokenIcons":{"enabled":false}}` | Configuraton for the web component |
| blockscout.web.accountPoolSize | int | `1` | ACCOUNT_POOL_SIZE env variable for web pod |
| blockscout.web.affinity | object | `{}` | affinity for web pods |
| blockscout.web.appsMenu | object | `{"connectList":"[{\"url\":\"https://impactmarket.com/\", \"title\":\"impactMarket\"}, {\"url\":\"https://talentprotocol.com/\", \"title\":\"Talent Protocol\"}, {\"url\":\"https://doni.app/\", \"title\":\"Doni\"}]","defiList":"[{\"url\":\"https://moola.market/\", \"title\":\"Moola\"},  {\"url\":\"https://www.pinnata.xyz/farm#/\", \"title\":\"Pinnata\"}, {\"url\":\"https://goodghosting.com/\", \"title\":\"GoodGhosting\"}, {\"url\":\"https://revo.market/\", \"title\":\"Revo\"}, {\"url\":\"https://www.immortaldao.finance\", \"title\":\"ImmortalDao Finance\"}]","enabled":true,"financeToolsList":"[{\"url\":\"https://celotracker.com/\", \"title\":\"Celo Tracker\"}, {\"url\":\"https://celo.tax/\", \"title\":\"celo.tax\"}, {\"url\":\"https://trelis.com/\", \"title\": \"Trelis\"}]","learningList":"[{\"url\": \"https://celo.org/papers/whitepaper\", \"title\":\"Celo Whitepaper\"}, {\"url\": \"https://learn.figment.io/protocols/celo\", \"title\":\"Learn Celo\"}, {\"url\": \"https://www.coinbase.com/price/celo\", \"title\":\"Coinbase Earn\"}]","nftList":"[{\"url\":\"https://niftydrop.net/\", \"title\":\"Niftydrop\"}, {\"url\":\"https://nfts.valoraapp.com/\", \"title\":\"NFT Viewer\"}, {\"url\":\"https://cyberbox.art/\", \"title\":\"Cyberbox\"}, {\"url\":\"https://nom.space/\", \"title\":\"Nomspace\"}, {\"url\":\"https://alities.io/\", \"title\":\"Alities\"}]","resourcesList":"[{\"url\":\"https://celovote.com/\", \"title\":\"Celo Vote\"}, {\"url\":\"https://forum.celo.org/\", \"title\":\"Celo Forum\"}, {\"url\":\"https://thecelo.com/\", \"title\":\"TheCelo\"}, {\"url\":\"https://celo.org/validators/explore\", \"title\":\"Validators\"}, {\"url\":\"https://celoreserve.org/\", \"title\":\"Celo Reserve\"}, {\"url\":\"https://docs.celo.org/\", \"title\":\"Celo Docs\"}]","spendList":"[{\"url\":\"https://giftcards.bidali.com/\", \"title\":\"Bidali\"}, {\"url\":\"https://flywallet.io/\", \"title\":\"Flywallet\"},{\"url\":\"https://chispend.com/\", \"title\":\"ChiSpend\"}]","swapList":"[{\"url\":\"https://ubeswap.org/\", \"title\":\"Ubeswap\"}, {\"url\":\"https://symmetric.finance/\", \"title\":\"Symmetric\"}, {\"url\":\"https://www.mobius.money/\", \"title\":\"Mobius\"}, {\"url\":\"https://mento.finance/\", \"title\":\"Mento-fi\"}, {\"url\":\"https://swap.bitssa.com/\", \"title\":\"Swap Bitssa\"}]","walletList":"[{\"url\":\"https://valoraapp.com/\", \"title\":\"Valora\"}, {\"url\":\"https://celoterminal.com/\", \"title\":\"Celo Terminal\"}, {\"url\":\"https://celowallet.app/\", \"title\":\"Celo Wallet\"}, {\"url\":\"https://www.nodewallet.xyz/\", \"title\":\"Node Wallet\"}]"}` | Configuration for the app menu on the web, for customizing the list of apps on `More` menu |
| blockscout.web.autoscaling | object | `{"maxReplicas":5,"minReplicas":2,"target":{"cpu":70}}` | HPA configuration for web deployment |
| blockscout.web.basicAuth | object | `{"enabled":false}` | Enable basicAuth on ingress |
| blockscout.web.campaignBanner | object | `{"refreshInterval":"60"}` | Configuration for the campaignBanner |
| blockscout.web.db.connectionName | string | `"project:region:db-name"` | Name of the CloudSQL connection to use |
| blockscout.web.db.name | string | `"blockscout"` | Name of the database to use. Database is created if it does not exist |
| blockscout.web.db.proxy | object | `{"host":"127.0.0.1","livenessProbe":{},"port":5432,"readinessProbe":{},"resources":{"requests":{"cpu":"10m","memory":"20Mi"}}}` | Configuration for the CloudSQL proxy (https://cloud.google.com/sql/docs/mysql/sql-proxy) |
| blockscout.web.db.proxy.livenessProbe | object | `{}` | livenessProbe for cloud-sql container |
| blockscout.web.db.proxy.readinessProbe | object | `{}` | readinessProbe for cloud-sql container |
| blockscout.web.db.proxy.resources | object | `{"requests":{"cpu":"10m","memory":"20Mi"}}` | resources for cloud-sql container |
| blockscout.web.homepage.showPrice | bool | `true` | Show the exchange rate chart on the homepage |
| blockscout.web.homepage.showTxs | bool | `false` | Show the tx chart on the homepage |
| blockscout.web.liveUpdates | object | `{"disabled":true}` | DISABLE_LIVE_UPDATES env variable for web pod |
| blockscout.web.livenessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":5}` | livenessProbe for Web container |
| blockscout.web.nodeSelector | object | `{}` | nodeSelector for web pods |
| blockscout.web.poolSize | int | `30` | Max number of DB connections excluding read-only API endpoints requests |
| blockscout.web.poolSizeReplica | int | `5` | Max number of DB connections for read-only API endpoints requests |
| blockscout.web.primaryRpcRegion | string | `"indexer"` | PRIMARY_REGION env variable for web pod. Do not change. |
| blockscout.web.readinessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":5}` | readinessProbe for web container |
| blockscout.web.recaptchaSecretName | string | `""` | k8s secret with Google recaptcha secret. It needs to pre-exist |
| blockscout.web.resources | object | `{"requests":{"cpu":"500m","memory":"250M"}}` | resources for web container |
| blockscout.web.rpcRegion | string | `"web"` | MY_REGION env variable for web pod. Do not change. |
| blockscout.web.strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":"20%"}}` | UpdateStrategy for web deployment |
| blockscout.web.tokenIcons | object | `{"enabled":false}` | Show token icons |
| changeCause | string | `""` | Add annotation with a message about the upgrade process trigger. Intended to be used by CD or deployment tool |
| infrastructure | object | `{"affinity":{},"domainName":"celo-testnet.org","gcp":{"projectId":"celo-testnet-production"},"grafanaUrl":"https://clabs.grafana.net","metrics":{"enabled":false},"nodeSelector":{}}` | Infrastructure/Kubernetes shared configuration |
| infrastructure.affinity | object | `{}` | Default affinity for the pods |
| infrastructure.grafanaUrl | string | `"https://clabs.grafana.net"` | Grafana url to use during deployment |
| infrastructure.metrics | object | `{"enabled":false}` | Enable prometheus metrics, using annotations |
| infrastructure.nodeSelector | object | `{}` | Default nodeSelector for the pods |
| ingressClassName | string | `"nginx"` |  |
| network | object | `{"name":"Celo","networkID":1101,"nodes":{"archiveNodes":{"jsonrpcHttpUrl":"http://tx-nodes-private:8545","jsonrpcWsUrl":"ws://tx-nodes-private:8545"},"fullNodes":{"jsonrpcPublicHttp":""}}}` | Configuration related with the CELO network |
| network.nodes | object | `{"archiveNodes":{"jsonrpcHttpUrl":"http://tx-nodes-private:8545","jsonrpcWsUrl":"ws://tx-nodes-private:8545"},"fullNodes":{"jsonrpcPublicHttp":""}}` | RPC/WS endpoints for the node network. Indexer requires archive data |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0). To regenerate run `helm-docs` command at this folder.
