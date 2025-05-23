{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "op-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "op-node.fullname" -}}
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
{{- define "op-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "op-node.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "op-node.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "op-node.labels" -}}
helm.sh/chart: {{ include "op-node.chart" . }}
{{ include "op-node.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "op-node.selectorLabels" -}}
{{- with .Values.statefulset.labels }}
{{- toYaml . }}
{{- end }}
app.kubernetes.io/name: {{ include "op-node.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "op-node.healthcheck" -}}
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
