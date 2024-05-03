#!/usr/bin/env sh
set -e

if [ ! -f /celo/.initialized ]; then
    wget -qO /celo/genesis.json "{{ .Values.init.genesis.url }}"
    wget -qO /celo/rollup.json "{{ .Values.init.rollup.url }}"
    geth --datadir={{ .Values.config.datadir }} --state.scheme={{ .Values.config.state.scheme }} init /celo/genesis.json
    touch /celo/.initialized
    echo "Successfully initialized from genesis file"
else
    echo "Already initialized, skipping."
fi
