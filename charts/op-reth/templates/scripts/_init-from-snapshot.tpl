#!/usr/bin/env sh
set -e
{{- if not (has .Values.snapshot.components (list "minimal" "full" "archive")) }}
{{- fail (printf "snapshot.components must be one of \"minimal\", \"full\" or \"archive\"; got %q" .Values.snapshot.components) }}
{{- end }}
{{- if and .Values.snapshot.manifestUrl .Values.snapshot.url }}
{{- fail "snapshot.manifestUrl and snapshot.url are mutually exclusive" }}
{{- end }}

datadir="{{ .Values.persistence.mountPath | default .Values.config.datadir }}"

{{- if not .Values.snapshot.force }}
if [ -f "$datadir/.initialized" ]; then
    echo "Datadir already initialized; skipping snapshot download."
    exit 0
fi
{{- end }}

echo "Bootstrapping datadir from snapshot via 'celo-reth download --{{ .Values.snapshot.components }}'..."
celo-reth download \
  --datadir={{ .Values.config.datadir }} \
{{- if .Values.config.chain }}
  --chain={{ .Values.config.chain }} \
{{- end }}
{{- with .Values.snapshot.manifestUrl }}
  --manifest-url={{ . }} \
{{- end }}
{{- with .Values.snapshot.url }}
  --url={{ . }} \
{{- end }}
  --force \
{{- with .Values.snapshot.extraArgs }}
{{- range . }}
  {{ tpl . $ }} \
{{- end }}
{{- end }}
  --{{ .Values.snapshot.components }}

touch "$datadir/.initialized"
echo "Snapshot download complete; datadir marked initialized."
