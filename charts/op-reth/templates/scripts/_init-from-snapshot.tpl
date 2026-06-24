#!/usr/bin/env sh
set -e
{{- $components := include "op-reth.snapshotComponents" . }}
{{- if not (has $components (list "minimal" "full" "archive")) }}
{{- fail (printf "snapshot download component (nodeMode or snapshot.components) must be one of \"minimal\", \"full\" or \"archive\"; got %q" $components) }}
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

echo "Bootstrapping datadir from snapshot via 'celo-reth download --{{ $components }} --resumable'..."
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
  --resumable \
{{- with .Values.snapshot.extraArgs }}
{{- range . }}
  {{ tpl . $ }} \
{{- end }}
{{- end }}
  --{{ $components }}

touch "$datadir/.initialized"
echo "Snapshot download complete; datadir marked initialized."
