#!/usr/bin/env sh
set -e

datadir="{{ .Values.persistence.mountPath | default .Values.config.datadir }}"
if [ ! -f $datadir/.initialized ]; then
    {{- if .Values.init.rollup.enabled }}
    wget -qO $datadir/rollup.json "{{ .Values.init.rollup.url }}"
    echo "Successfully downloaded rollup.json"
    {{- end }}
    {{- if .Values.init.genesis.enabled }}
    wget -qO $datadir/genesis.json "{{ .Values.init.genesis.url }}"
    geth \
      --datadir={{ .Values.config.datadir }} \
      {{- with .Values.init.extraArgs }}
      {{- range . }}
      {{- tpl (.) $ | nindent 6 }} \
      {{- end }}
      {{- end }}
      {{- if .Values.config.state.scheme }}
      --state.scheme={{ .Values.config.state.scheme }} \
      {{- end }}
      init $datadir/genesis.json
    echo "Successfully initialized from genesis file"
    {{- end }}
    touch $datadir/.initialized
else
    echo "Already initialized, skipping."
fi
