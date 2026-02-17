#!/bin/sh
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<EOF
Usage: run-sync-tests.sh <network> [options]

Launch snap, execution, and consensus sync tests for the given network.

Arguments:
  network                   Network name (must match a file in networks/)

Options:
  -n, --namespace <ns>      Kubernetes namespace (default: current context namespace)
  --geth-image <repo:tag>   op-geth container image (required)
  --node-image <repo:tag>   op-node container image (required)
  --snapshot <name>         VolumeSnapshot name (required for consensus/execution on mainnet)
  --prefix <prefix>         Release name prefix (default: <network>)
  -h, --help                Show this help message
  --                        All arguments after -- are passed to helm install

Example:
  ./run-sync-tests.sh mainnet \\
    -n mainnet-sync-test \\
    --geth-image us-west1-docker.pkg.dev/myproject/images/op-geth:abc123 \\
    --node-image us-west1-docker.pkg.dev/myproject/images/op-node:abc123 \\
    --snapshot mainnet-cel2-migrated \\
    -- --set op-geth.extraArgs[0]=--verbosity=4
EOF
  exit "${1:-1}"
}

NETWORK=""
NAMESPACE=""
GETH_IMAGE=""
NODE_IMAGE=""
SNAPSHOT=""
PREFIX=""

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--namespace) NAMESPACE="$2"; shift 2 ;;
    --geth-image)   GETH_IMAGE="$2"; shift 2 ;;
    --node-image)   NODE_IMAGE="$2"; shift 2 ;;
    --snapshot)     SNAPSHOT="$2"; shift 2 ;;
    --prefix)       PREFIX="$2"; shift 2 ;;
    -h|--help)      usage 0 ;;
    --)             shift; break ;;
    -*)             echo "Error: unknown option: $1" >&2; usage ;;
    *)
      if [ -z "$NETWORK" ]; then
        NETWORK="$1"; shift
      else
        echo "Error: unexpected argument: $1" >&2; usage
      fi
      ;;
  esac
done

if [ -z "$NETWORK" ]; then
  echo "Error: network is required" >&2
  usage
fi

NETWORK_FILE="${SCRIPT_DIR}/networks/${NETWORK}.yaml"
if [ ! -f "$NETWORK_FILE" ]; then
  echo "Error: network file not found: ${NETWORK_FILE}" >&2
  echo "Available networks:" >&2
  for f in "${SCRIPT_DIR}"/networks/*.yaml; do
    echo "  $(basename "$f" .yaml)" >&2
  done
  exit 1
fi

if [ -z "$GETH_IMAGE" ]; then
  echo "Error: --geth-image is required" >&2
  usage
fi

if [ -z "$NODE_IMAGE" ]; then
  echo "Error: --node-image is required" >&2
  usage
fi

GETH_REPO="${GETH_IMAGE%:*}"
GETH_TAG="${GETH_IMAGE##*:}"
if [ "$GETH_REPO" = "$GETH_IMAGE" ]; then
  echo "Error: --geth-image must be in repo:tag format" >&2
  exit 1
fi

NODE_REPO="${NODE_IMAGE%:*}"
NODE_TAG="${NODE_IMAGE##*:}"
if [ "$NODE_REPO" = "$NODE_IMAGE" ]; then
  echo "Error: --node-image must be in repo:tag format" >&2
  exit 1
fi

PREFIX="${PREFIX:-$NETWORK}"

# Ensure subchart dependencies are built
if [ ! -d "${SCRIPT_DIR}/charts" ]; then
  echo "==> Building subchart dependencies..."
  helm dependency build "$SCRIPT_DIR"
fi

for mode in snap execution consensus; do
  release="${PREFIX}-${mode}"
  preset="${SCRIPT_DIR}/presets/${mode}.yaml"

  echo "==> Installing ${release} (${mode} sync)..."

  # shellcheck disable=SC2086
  helm install "$release" "$SCRIPT_DIR" \
    ${NAMESPACE:+-n "$NAMESPACE"} \
    -f "$preset" \
    -f "$NETWORK_FILE" \
    --set "op-geth.image.repository=${GETH_REPO}" \
    --set "op-geth.image.tag=${GETH_TAG}" \
    --set "op-node.image.repository=${NODE_REPO}" \
    --set "op-node.image.tag=${NODE_TAG}" \
    --set "op-geth.secrets.nodeKey.value=0x$(openssl rand -hex 32)" \
    --set "op-node.secrets.p2pKeys.value=0x$(openssl rand -hex 32)" \
    ${SNAPSHOT:+--set "snapshot.volumeSnapshotName=${SNAPSHOT}"} \
    "$@"

  echo "    ${release} installed"
done

echo ""
echo "All sync tests launched."
if [ -n "$NAMESPACE" ]; then
  echo "Monitor with: kubectl get pods -n ${NAMESPACE}"
else
  echo "Monitor with: kubectl get pods"
fi
