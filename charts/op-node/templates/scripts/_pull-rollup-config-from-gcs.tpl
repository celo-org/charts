#!/usr/bin/env sh

set -e

. /scripts/gcs-env.sh

process_inputs() {
  # download even if we are already initialized
  if [ "$FORCE_INIT" = "True" ]; then
    echo "Force init enabled, existing data will be deleted."
    rm -f "$INITIALIZED_FILE"
  fi
  # check for gcloud authentication
  if [ -z "$(gcloud auth list --format='value(account)' --filter='status:ACTIVE')" ]; then
    echo "gcloud is not authenticated, exiting"; exit 1
  fi
}

sync() {
  # check if we are already initialized
  if [ -f "$INITIALIZED_FILE" ]; then
    echo "Blockchain already initialized. Exiting..."
    exit 0
  fi

  echo "Cleaning up local data..."
  rm -rf "${ROLLUP_DIR}"
  mkdir -p "${ROLLUP_DIR}"

  echo "Starting download data from S3..."

  # download remote snapshot to an empty datadir
  time "$GCSCMD" rsync "gs://${GCS_ROLLUP_URL}/*" "${ROLLUP_DIR}/"

  # all done, mark as initialized
  touch "$INITIALIZED_FILE"
}

main() {
  process_inputs
  sync
}

main
