{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "op-reth.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "op-reth.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "op-reth.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "op-reth.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "op-reth.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "op-reth.labels" -}}
helm.sh/chart: {{ include "op-reth.chart" . }}
{{ include "op-reth.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "op-reth.selectorLabels" -}}
app.kubernetes.io/name: {{ include "op-reth.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "op-reth.healthcheck" -}}
{{- $context := index . 0 }}
{{- $root := index . 1 }}
{{- if and $root.exec (kindIs "slice" $root.exec.command) }}
{{- omit $root "enabled" "exec" | toYaml }}
exec:
  command:
    {{- range $cmd := $root.exec.command -}}
    {{- $processedCmd := tpl $cmd $context | trim -}}
    {{- if contains "\n" $processedCmd }}
    - |
      {{- $processedCmd | nindent 7 }}
    {{- else -}}
    {{ printf "- %s" $processedCmd | nindent 4 }}
    {{- end -}}
    {{- end -}}
{{- else }}
{{- omit $root "enabled" | toYaml }}
{{- end }}
{{- end }}

{{/*
op-reth.nodeMode: effective node mode driving the celo-reth `--full` / `--minimal`
prune flag. Precedence: an explicit .Values.nodeMode ("archive"|"full"|"minimal")
wins; otherwise fall back to the deprecated .Values.config.full (true => "full"),
defaulting to "archive" (no prune flag = full history).
*/}}
{{- define "op-reth.nodeMode" -}}
{{- $mode := .Values.nodeMode | default "" -}}
{{- if $mode -}}
{{- if not (has $mode (list "archive" "full" "minimal")) -}}
{{- fail (printf "nodeMode must be one of \"archive\", \"full\" or \"minimal\"; got %q" $mode) -}}
{{- end -}}
{{- $mode -}}
{{- else if .Values.config.full -}}
full
{{- else -}}
archive
{{- end -}}
{{- end -}}

{{/*
op-reth.snapshotComponents: snapshot tier passed to `celo-reth download`.
Precedence: an explicit .Values.nodeMode wins; otherwise the deprecated
.Values.snapshot.components.
*/}}
{{- define "op-reth.snapshotComponents" -}}
{{- if .Values.nodeMode -}}
{{- include "op-reth.nodeMode" . -}}
{{- else -}}
{{- .Values.snapshot.components -}}
{{- end -}}
{{- end -}}
