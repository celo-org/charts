#!/usr/bin/env sh

export S5CMD="/gcloud alpha storage"

# local directory structure config
export ROLLUP_DIR="${ROLLUP_DIR?ROLLUP_DIR not provided.}"
export INITIALIZED_FILE="${INITIALIZED_FILE?INITIALIZED_FILE not provided.}"

# s3 directory structure config
export GCS_BASE_URL="${GCS_BASE_URL?GCS_BASE_URL not provided.}"
export S3_ROLLUP_URL="${GCS_BASE_URL}/rollup"

# download/upload options
export FORCE_INIT="${FORCE_INIT:-False}"
