{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "op-geth-bootnode.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "op-geth-bootnode.fullname" -}}
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
{{- define "op-geth-bootnode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "op-geth-bootnode.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "op-geth-bootnode.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "op-geth-bootnode.labels" -}}
helm.sh/chart: {{ include "op-geth-bootnode.chart" . }}
{{ include "op-geth-bootnode.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "op-geth-bootnode.selectorLabels" -}}
app.kubernetes.io/name: {{ include "op-geth-bootnode.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "op-geth-bootnode.healthcheck" -}}
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
