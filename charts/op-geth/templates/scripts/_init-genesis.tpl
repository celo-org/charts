#!/usr/bin/env sh
set -e

datadir="{{ .Values.persistence.mountPath | default .Values.config.datadir }}"
if [ ! -f $datadir/.initialized ]; then
    wget -qO $datadir/genesis.json "{{ .Values.init.genesis.url }}"
    wget -qO $datadir/rollup.json "{{ .Values.init.rollup.url }}"
    {{- $stateScheme := "" }}
    {{- if .Values.config.state }}
    {{- if .Values.config.state.scheme }}
    {{- $stateScheme = printf " --state.scheme=%s" .Values.config.state.scheme }}
    {{- end }}
    {{- end }}
    geth --datadir={{ .Values.config.datadir }}{{ $stateScheme }} init $datadir/genesis.json
    touch $datadir/.initialized
    echo "Successfully initialized from genesis file"
else
    echo "Already initialized, skipping."
fi
