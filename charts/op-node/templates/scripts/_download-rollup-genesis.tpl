#!/usr/bin/env sh
set -e

if [ ! -f /celo/.initialized ]; then
    wget -qO /celo/genesis.json "{{ .Values.init.genesis.url }}"
    wget -qO /celo/rollup.json "{{ .Values.init.rollup.url }}"
    touch /celo/.initialized
    echo "Successfully downloaded genesis and rollup files"
else
    echo "Already downloaded, skipping."
fi
