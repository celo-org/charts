{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "periodic-chain-call.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "periodic-chain-call.fullname" -}}
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
{{- define "periodic-chain-call.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "periodic-chain-call.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "periodic-chain-call.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "periodic-chain-call.labels" -}}
helm.sh/chart: {{ include "periodic-chain-call.chart" . }}
{{ include "periodic-chain-call.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "periodic-chain-call.selectorLabels" -}}
app.kubernetes.io/name: {{ include "periodic-chain-call.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "periodic-chain-call.healthcheck" -}}
{{- $context := index . 0 }}
{{- $root := index . 1 }}
{{- if and $root.exec (kindIs "string" $root.exec.command) }}
{{- omit $root "enabled" "exec" | toYaml }}
exec:
  command:
		{{- tpl $root.exec.command $context | nindent 4 }}
{{- else }}
{{- omit $root "enabled" | toYaml }}
{{- end }}
{{- end }}
