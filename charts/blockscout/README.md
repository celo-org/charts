# blockscout

Chart which is used to deploy Blockscout for Celo Networks

![Version: 1.3.27](https://img.shields.io/badge/Version-1.3.27-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.0.4-beta](https://img.shields.io/badge/AppVersion-v2.0.4--beta-informational?style=flat-square)

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
CHART_RELEASE="oci://us-west1-docker.pkg.dev/celo-testnet/clabs-public-oci/blockscout --version=1.3.27" # Use remote chart and specific version
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
| blockscout.api | object | `{"affinity":{},"autoscaling":{"enabled":true,"maxReplicas":10,"minReplicas":2,"target":{"cpu":70}},"db":{"connectionName":"project:region:db-name","name":"blockscout","port":5432,"proxy":{"resources":{"requests":{"cpu":"10m","memory":"20Mi"}}}},"hostname":"","livenessProbe":{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":60,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5},"nodeSelector":{},"poolSize":30,"poolSizeReplica":5,"port":4000,"primaryRpcRegion":"indexer","rateLimit":"1000000","readinessProbe":{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5},"replicas":1,"resources":{"requests":{"cpu":0.5,"memory":"500Mi"}},"rpcRegion":"api","strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":"20%"}},"suffix":{"enabled":false,"path":""}}` | Configuraton for the api component |
| blockscout.api.affinity | object | `{}` | affinity for api pods |
| blockscout.api.autoscaling | object | `{"enabled":true,"maxReplicas":10,"minReplicas":2,"target":{"cpu":70}}` | HPA configuration for api deployment |
| blockscout.api.db | object | `{"connectionName":"project:region:db-name","name":"blockscout","port":5432,"proxy":{"resources":{"requests":{"cpu":"10m","memory":"20Mi"}}}}` | Database configuration for indexer. Prepared to be used with CloudSQL |
| blockscout.api.db.connectionName | string | `"project:region:db-name"` | Name of the CloudSQL connection to use |
| blockscout.api.db.name | string | `"blockscout"` | Name of the database to use. Database is created if it does not exist |
| blockscout.api.db.proxy | object | `{"resources":{"requests":{"cpu":"10m","memory":"20Mi"}}}` | Configuration for the CloudSQL proxy (https://cloud.google.com/sql/docs/mysql/sql-proxy) |
| blockscout.api.db.proxy.resources | object | `{"requests":{"cpu":"10m","memory":"20Mi"}}` | resources for cloud-sql container |
| blockscout.api.hostname | string | `""` | Hostname for api ingress endpoint |
| blockscout.api.livenessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":60,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | livenessProbe for api container |
| blockscout.api.nodeSelector | object | `{}` | nodeSelector for api pods |
| blockscout.api.poolSize | int | `30` | Max number of DB connections excluding read-only API endpoints requests |
| blockscout.api.poolSizeReplica | int | `5` | Max number of DB connections for read-only API endpoints requests |
| blockscout.api.primaryRpcRegion | string | `"indexer"` | PRIMARY_REGION env variable for api pod. Do not change. |
| blockscout.api.rateLimit | string | `"1000000"` | request rateLimit for api coponent |
| blockscout.api.readinessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | readinessProbe for api container |
| blockscout.api.replicas | int | `1` | Number of replicas for api deployment. Won't be used if autoscaling.enabled is true |
| blockscout.api.resources | object | `{"requests":{"cpu":0.5,"memory":"500Mi"}}` | resources for api container |
| blockscout.api.rpcRegion | string | `"api"` | MY_REGION env variable for api pod. Do not change. |
| blockscout.api.strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":"20%"}}` | UpdateStrategy for api deployment |
| blockscout.api.suffix | object | `{"enabled":false,"path":""}` | If api component is served at rootPath |
| blockscout.dbMaintenance | object | `{"enabled":true,"image":{"repository":"us-west1-docker.pkg.dev/devopsre/db-maintenance/db-maintenance-image","tag":"latest"},"schedule":"0 0 * * *"}` | Configuraton for the database maintenance cronjob |
| blockscout.eventStream | object | `{"beanstalkdHost":"","beanstalkdPort":"","beanstalkdTube":"","enabled":false,"livenessProbe":{},"port":4000,"readinessProbe":{},"replicas":0,"resources":{"requests":{"cpu":2,"memory":"1000Mi"}},"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}` | Configuraton for the eventStream component |
| blockscout.eventStream.beanstalkdHost | string | `""` | `BEANSTALKD_HOST` env for eventStream deployment |
| blockscout.eventStream.beanstalkdPort | string | `""` | `BEANSTALKD_PORT` env for eventStream deployment |
| blockscout.eventStream.beanstalkdTube | string | `""` | `BEANSTALKD_TUBE` env for eventStream deployment |
| blockscout.eventStream.enabled | bool | `false` | Enable the eventStream component |
| blockscout.eventStream.livenessProbe | object | `{}` | livenessProbe for eventStream container |
| blockscout.eventStream.readinessProbe | object | `{}` | readinessProbe for eventStream container |
| blockscout.eventStream.replicas | int | `0` | replicas for eventStream deployment |
| blockscout.eventStream.resources | object | `{"requests":{"cpu":2,"memory":"1000Mi"}}` | resources for eventStream container |
| blockscout.eventStream.strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}` | UpdateStrategy for eventStream deployment |
| blockscout.indexer | object | `{"affinity":{},"db":{"connectionName":"project:region:db-name","name":"blockscout","port":5432,"proxy":{"resources":{"requests":{"cpu":"100m","memory":"40Mi"}}}},"fetchers":{"blockRewards":{"enabled":false},"catchup":{"batchSize":5,"concurrency":5}},"livenessProbe":{"failureThreshold":5,"initialDelaySeconds":60,"periodSeconds":30,"tcpSocket":{"port":"health"}},"nodeSelector":{},"poolSize":200,"poolSizeReplica":5,"port":4001,"primaryRpcRegion":"indexer","readinessProbe":{"failureThreshold":5,"httpGet":{"path":"/health/readiness","port":"health","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5},"replicas":1,"resources":{"requests":{"cpu":2,"memory":"2G"}},"rpcRegion":"indexer","strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}},"terminationGracePeriodSeconds":60,"tracerImplementation":"call_tracer"}` | Configuraton for the indexer component |
| blockscout.indexer.affinity | object | `{}` | affinity for indexer pods |
| blockscout.indexer.db | object | `{"connectionName":"project:region:db-name","name":"blockscout","port":5432,"proxy":{"resources":{"requests":{"cpu":"100m","memory":"40Mi"}}}}` | Database configuration for indexer. Prepared to be used with CloudSQL |
| blockscout.indexer.db.connectionName | string | `"project:region:db-name"` | Name of the CloudSQL connection to use |
| blockscout.indexer.db.name | string | `"blockscout"` | Name of the database to use. Database is created if it does not exist |
| blockscout.indexer.db.proxy | object | `{"resources":{"requests":{"cpu":"100m","memory":"40Mi"}}}` | Configuration for the CloudSQL proxy (https://cloud.google.com/sql/docs/mysql/sql-proxy) |
| blockscout.indexer.db.proxy.resources | object | `{"requests":{"cpu":"100m","memory":"40Mi"}}` | resources for cloud-sql container |
| blockscout.indexer.fetchers.blockRewards | object | `{"enabled":false}` | Enable CELO blockRewards functionality |
| blockscout.indexer.fetchers.catchup | object | `{"batchSize":5,"concurrency":5}` | Block catchup fetcher config |
| blockscout.indexer.livenessProbe | object | `{"failureThreshold":5,"initialDelaySeconds":60,"periodSeconds":30,"tcpSocket":{"port":"health"}}` | livenessProbe for indexer container |
| blockscout.indexer.nodeSelector | object | `{}` | nodeSelector for indexer pods |
| blockscout.indexer.poolSize | int | `200` | Max number of DB connections excluding read-only API endpoints requests |
| blockscout.indexer.poolSizeReplica | int | `5` | Max number of DB connections for read-only API endpoints requests |
| blockscout.indexer.primaryRpcRegion | string | `"indexer"` | PRIMARY_REGION env variable for indexer pod. Do not change. |
| blockscout.indexer.readinessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/health/readiness","port":"health","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | readinessProbe for indexer container |
| blockscout.indexer.replicas | int | `1` | Number of replicas for indexer deployment. Should not be bigger than 1 |
| blockscout.indexer.resources | object | `{"requests":{"cpu":2,"memory":"2G"}}` | resources for indexer container |
| blockscout.indexer.rpcRegion | string | `"indexer"` | MY_REGION env variable for indexer pod. Do not change. |
| blockscout.indexer.strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}` | UpdateStrategy for indexer deployment |
| blockscout.indexer.terminationGracePeriodSeconds | int | `60` | termination timeout for indexer pod |
| blockscout.indexer.tracerImplementation | string | `"call_tracer"` | tracer to use to fetch internal transactions - 'js' or 'call_tracer' |
| blockscout.metadataCrawler | object | `{"discordClusterName":"","enabled":false,"image":{"repository":"us-west1-docker.pkg.dev/devopsre/celo-monorepo/blockscout-metadata-crawler","tag":"latest"},"schedule":"0 */2 * * *"}` | Configuraton for the metadataCrawler component |
| blockscout.metadataCrawler.discordClusterName | string | `""` | Discord server for notifications |
| blockscout.metadataCrawler.schedule | string | `"0 */2 * * *"` | Cron schedule for the metadataCrawler |
| blockscout.shared.db | object | `{"drop":"false"}` | Drop the database on startup |
| blockscout.shared.epochRewards | object | `{"enabled":true}` | Enable epochRewards |
| blockscout.shared.erlangNodeName | string | `"blockscout"` |  |
| blockscout.shared.healthyBlocksPeriod | int | `300` | Max delay in seconds for the indexer to be considered unhealthy |
| blockscout.shared.image | object | `{"pullPolicy":"Always","repository":"gcr.io/celo-testnet/blockscout","tag":"c6ca0da21bd238948d13ec2fabf4428a9dbbc7b6"}` | Image to use for blockscout components |
| blockscout.shared.migrationJobInitialValue | string | `"{0,0}"` | Starting point for data migration job (`INITIAL_VALUE` env var) |
| blockscout.shared.secrets | object | `{"analyticsKey":"","campaignBannerApiUrl":"","dbPassword":"","dbUser":"","discordWebhookUrl":"","erlang_cookie":"","grafanaCloud":"","recaptcha_apiKey":"","recaptcha_projectId":"","recaptcha_secretKey":"","recaptcha_siteKey":"","segmentKey":""}` | Reference to secrets. Format: gcp:secretmanager:projects/<project-id>/secrets/<env>-blockscout-<secret-key>. Using tool https://github.com/doitintl/secrets-init |
| blockscout.web | object | `{"accountPoolSize":1,"affinity":{},"appsMenu":{"enabled":true},"autoscaling":{"enabled":true,"maxReplicas":5,"minReplicas":2,"target":{"cpu":70}},"basicAuth":{"enabled":false},"campaignBanner":{"refreshInterval":"60"},"db":{"connectionName":"project:region:db-name","name":"blockscout","port":5432,"proxy":{"resources":{"requests":{"cpu":"10m","memory":"20Mi"}}}},"envHostname":"","extraEnvironments":{"source":[],"target":[]},"homepage":{"showPrice":true,"showTxs":false},"hostname":"","liveUpdates":{"disabled":true},"livenessProbe":{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":60,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5},"nodeSelector":{},"poolSize":30,"poolSizeReplica":5,"port":4000,"primaryRpcRegion":"indexer","readinessProbe":{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5},"replicas":1,"resources":{"requests":{"cpu":"500m","memory":"250M"}},"rpcRegion":"web","sourcify":{"enabled":true,"repoUrl":"https://repo.sourcify.dev/contracts","serverUrl":"https://sourcify.dev/server"},"stats":{"enabled":false,"makerdojo":"","reportUrl":""},"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":"20%"}},"suffix":{"enabled":false,"path":""},"tokenIcons":{"enabled":false}}` | Configuraton for the web component |
| blockscout.web.accountPoolSize | int | `1` | ACCOUNT_POOL_SIZE env variable for web pod |
| blockscout.web.affinity | object | `{}` | affinity for web pods |
| blockscout.web.appsMenu | object | `{"enabled":true}` | Configuration for the app menu on the web, for customizing the list of apps on `More` menu |
| blockscout.web.autoscaling | object | `{"enabled":true,"maxReplicas":5,"minReplicas":2,"target":{"cpu":70}}` | HPA configuration for web deployment |
| blockscout.web.basicAuth | object | `{"enabled":false}` | Enable basicAuth on ingress |
| blockscout.web.campaignBanner | object | `{"refreshInterval":"60"}` | Configuration for the campaignBanner |
| blockscout.web.db.connectionName | string | `"project:region:db-name"` | Name of the CloudSQL connection to use |
| blockscout.web.db.name | string | `"blockscout"` | Name of the database to use. Database is created if it does not exist |
| blockscout.web.db.proxy | object | `{"resources":{"requests":{"cpu":"10m","memory":"20Mi"}}}` | Configuration for the CloudSQL proxy (https://cloud.google.com/sql/docs/mysql/sql-proxy) |
| blockscout.web.db.proxy.resources | object | `{"requests":{"cpu":"10m","memory":"20Mi"}}` | resources for cloud-sql container |
| blockscout.web.envHostname | string | `""` | Env hostname. This will be used by blockscout for generating links. If empty, hostname will be used |
| blockscout.web.homepage.showPrice | bool | `true` | Show the exchange rate chart on the homepage |
| blockscout.web.homepage.showTxs | bool | `false` | Show the tx chart on the homepage |
| blockscout.web.hostname | string | `""` | Hostname for web ingress endpoint (also applies to api at /(graphql|graphiql|api)). If empty, will be generated based on release name and domainName. |
| blockscout.web.liveUpdates | object | `{"disabled":true}` | DISABLE_LIVE_UPDATES env variable for web pod |
| blockscout.web.livenessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":60,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | livenessProbe for Web container |
| blockscout.web.nodeSelector | object | `{}` | nodeSelector for web pods |
| blockscout.web.poolSize | int | `30` | Max number of DB connections excluding read-only API endpoints requests |
| blockscout.web.poolSizeReplica | int | `5` | Max number of DB connections for read-only API endpoints requests |
| blockscout.web.primaryRpcRegion | string | `"indexer"` | PRIMARY_REGION env variable for web pod. Do not change. |
| blockscout.web.readinessProbe | object | `{"failureThreshold":5,"httpGet":{"path":"/api/v1/health/liveness","port":"http","scheme":"HTTP"},"initialDelaySeconds":30,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | readinessProbe for web container |
| blockscout.web.replicas | int | `1` | Number of replicas for web deployment. Won't be used if autoscaling.enabled is true |
| blockscout.web.resources | object | `{"requests":{"cpu":"500m","memory":"250M"}}` | resources for web container |
| blockscout.web.rpcRegion | string | `"web"` | MY_REGION env variable for web pod. Do not change. |
| blockscout.web.strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":"20%"}}` | UpdateStrategy for web deployment |
| blockscout.web.tokenIcons | object | `{"enabled":false}` | Show token icons |
| changeCause | string | `""` | Add annotation with a message about the upgrade process trigger. Intended to be used by CD or deployment tool |
| infrastructure | object | `{"affinity":{},"database":{"connectionName":"project:region:db-name","enableCloudSQLProxy":true,"name":"blockscout","port":5432,"proxy":{"host":"127.0.0.1","livenessProbe":{},"port":5432,"readinessProbe":{},"resources":{"requests":{"cpu":"10m","memory":"20Mi"}}}},"domainName":"celo-testnet.org","gcp":{"projectId":"celo-testnet-production","serviceAccount":""},"grafanaUrl":"https://clabs.grafana.net","metrics":{"enabled":false},"nodeSelector":{},"secretsInit":{"exitEarly":true}}` | Infrastructure/Kubernetes shared configuration |
| infrastructure.affinity | object | `{}` | Default affinity for the pods |
| infrastructure.database.proxy.livenessProbe | object | `{}` | livenessProbe for cloud-sql container |
| infrastructure.database.proxy.readinessProbe | object | `{}` | livinessProbe for cloud-sql container |
| infrastructure.database.proxy.resources | object | `{"requests":{"cpu":"10m","memory":"20Mi"}}` | resources for cloud-sql container |
| infrastructure.gcp.serviceAccount | string | `""` | GCP Service Account to use with Workload Identity. If empty, `.Release.Name@projectId.iam.gserviceaccount.com` will be used |
| infrastructure.grafanaUrl | string | `"https://clabs.grafana.net"` | Grafana url to use during deployment |
| infrastructure.metrics | object | `{"enabled":false}` | Enable prometheus metrics, using annotations |
| infrastructure.nodeSelector | object | `{}` | Default nodeSelector for the pods |
| infrastructure.secretsInit | object | `{"exitEarly":true}` | secrets-init configuration |
| infrastructure.secretsInit.exitEarly | bool | `true` | exit when a provider fails or a secret is not found |
| ingressClassName | string | `"nginx"` |  |
| network | object | `{"name":"Celo","networkID":1101,"nodes":{"archiveNodes":{"jsonrpcHttpUrl":"http://tx-nodes-private:8545","jsonrpcWsUrl":"ws://tx-nodes-private:8545"},"fullNodes":{"jsonrpcPublicHttp":""}}}` | Configuration related with the CELO network |
| network.nodes | object | `{"archiveNodes":{"jsonrpcHttpUrl":"http://tx-nodes-private:8545","jsonrpcWsUrl":"ws://tx-nodes-private:8545"},"fullNodes":{"jsonrpcPublicHttp":""}}` | RPC/WS endpoints for the node network. Indexer requires archive data |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs). To regenerate run `helm-docs` command at this folder.
