#!/usr/bin/env sh
set -e

if [ ! -f /celo/.initialized ]; then
    wget -qO /celo/genesis.json "{{ .Values.init.genesis.url }}"
    wget -qO /celo/rollup.json "{{ .Values.init.rollup.url }}"
    {{- $stateScheme := "" }}
    {{- if .Values.config.state }}
    {{- if .Values.config.state.scheme }}
    {{- $stateScheme = printf " --state.scheme=%s" .Values.config.state.scheme }}
    {{- end }}
    {{- end }}
    geth --datadir={{ .Values.config.datadir }}{{ $stateScheme }} init /celo/genesis.json
    touch /celo/.initialized
    echo "Successfully initialized from genesis file"
else
    echo "Already initialized, skipping."
fi
