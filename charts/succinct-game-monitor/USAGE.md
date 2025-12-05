# Succinct Game Monitor - Usage Guide

This Helm chart deploys the Succinct Game Monitor as a StatefulSet in Kubernetes.

## Installation

```bash
helm install my-game-monitor ./charts/succinct-game-monitor
```

## Configuration Options

The chart supports three main ways to configure environment variables:

### Option 1: Individual Environment Variables

Use this when you have a few environment variables to configure:

```yaml
config:
  env:
    GAME_MONITOR_URL: "https://example.com/api"
    GAME_MONITOR_INTERVAL: "60"
    LOG_LEVEL: "info"
```

Install with:
```bash
helm install my-game-monitor ./charts/succinct-game-monitor -f my-values.yaml
```

Or via command line:
```bash
helm install my-game-monitor ./charts/succinct-game-monitor \
  --set config.env.GAME_MONITOR_URL="https://example.com/api" \
  --set config.env.LOG_LEVEL="info"
```

### Option 2: Environment File

Use this when you want to mount a complete `.env` file into the container:

```yaml
config:
  envFile:
    enabled: true
    mountPath: "/app/.env"
    content: |
      GAME_MONITOR_URL=https://example.com/api
      GAME_MONITOR_INTERVAL=60
      LOG_LEVEL=info
      API_KEY=your-api-key-here
```

The env file will be mounted at the specified `mountPath` (default: `/app/.env`).

### Option 3: Secret Environment Variables

Use this for sensitive data like API keys and private keys:

```yaml
config:
  env:
    GAME_MONITOR_URL: "https://example.com/api"
  secretEnv:
    API_KEY: "your-secret-api-key"
    PRIVATE_KEY: "your-private-key"
```

Secret environment variables are stored in a Kubernetes Secret and referenced in the pod.

**Note:** For production, it's recommended to manage secrets externally (e.g., using sealed-secrets, external-secrets, or vault) rather than storing them in values files.

## Persistence

Enable persistence to store data across pod restarts:

```yaml
persistence:
  enabled: true
  mountPath: /data
  pvc:
    size: 10Gi
    storageClass: "fast-ssd"
    accessMode: ReadWriteOnce
```

## Resource Management

Configure resource requests and limits:

```yaml
resources:
  limits:
    cpu: 1000m
    memory: 2Gi
  requests:
    cpu: 500m
    memory: 1Gi
```

## Monitoring

Add Prometheus annotations for metrics scraping:

```yaml
podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "8080"
  prometheus.io/path: "/metrics"
```

## Custom Image

Use a custom image repository or tag:

```yaml
image:
  repository: my-registry.io/succinct-game-monitor
  tag: "v1.0.0"
  pullPolicy: Always

imagePullSecrets:
  - name: my-registry-secret
```

## Extra Arguments

Pass additional command-line arguments to the binary:

```yaml
extraArgs:
  - "--verbose"
  - "--debug"
```

## Custom Command

Override the default container command (ENTRYPOINT from the image):

### Simple Command

```yaml
command:
  - /usr/local/bin/game-monitor

extraArgs:
  - "--config=/app/.env"
  - "--log-level=info"
```

### Shell Wrapper for Complex Startup

For more complex startup logic, use a shell wrapper:

```yaml
command:
  - /bin/sh
  - -c

extraArgs:
  - |
    echo "Starting game monitor..."
    echo "Environment: ${ENVIRONMENT}"
    
    # Run any pre-start checks or setup
    if [ ! -f /app/.env ]; then
      echo "Error: Config file not found"
      exit 1
    fi
    
    # Start the application
    exec /usr/local/bin/game-monitor \
      start \
      --config=/app/.env \
      --log-level=${LOG_LEVEL:-info}
```

**Note:** Using `exec` in shell wrappers ensures the process replaces the shell and receives signals properly for graceful shutdowns.

## Complete Example

Here's a complete example combining multiple features:

```yaml
image:
  repository: succinctlabs/op-succinct-game-monitor
  tag: "v1.0.0"

config:
  env:
    LOG_LEVEL: "info"
    MONITOR_INTERVAL: "30"
  secretEnv:
    API_KEY: "your-secret-key"

persistence:
  enabled: true
  mountPath: /data
  pvc:
    size: 5Gi

resources:
  requests:
    cpu: 250m
    memory: 512Mi
  limits:
    cpu: 1000m
    memory: 1Gi

podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "8080"

nodeSelector:
  workload: monitoring
```

## Upgrade

```bash
helm upgrade my-game-monitor ./charts/succinct-game-monitor -f my-values.yaml
```

## Uninstall

```bash
helm uninstall my-game-monitor
```

**Note:** If persistence is enabled, you may need to manually delete the PVC:

```bash
kubectl delete pvc data-my-game-monitor-0
```

