{{/*
Expand the name of the chart.
*/}}
{{- define "op-succinct.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "op-succinct.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- $nameWithMode := printf "%s-%s" $name .Values.mode }}
{{- if contains $nameWithMode .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $nameWithMode | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "op-succinct.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "op-succinct.labels" -}}
helm.sh/chart: {{ include "op-succinct.chart" . }}
{{ include "op-succinct.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "op-succinct.selectorLabels" -}}
app.kubernetes.io/name: {{ include "op-succinct.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
op-succinct/mode: {{ .Values.mode }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "op-succinct.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "op-succinct.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the binary name based on mode
*/}}
{{- define "op-succinct.binaryName" -}}
{{- if eq .Values.mode "proposer" }}
{{- "op-proposer" }}
{{- else if eq .Values.mode "challenger" }}
{{- "op-challenger" }}
{{- else }}
{{- fail "mode must be either 'proposer' or 'challenger'" }}
{{- end }}
{{- end }}

{{/*
Get the full image name
*/}}
{{- define "op-succinct.image" -}}
{{- printf "%s/%s:%s" .Values.image.repository .Values.mode (.Values.image.tag | default .Chart.AppVersion) }}
{{- end }}

{{/*
Get the metrics port name based on app type
*/}}
{{- define "op-succinct.metricsPortName" -}}
{{- if eq .Values.mode "proposer" }}
{{- "PROPOSER_METRICS_PORT" }}
{{- else }}
{{- "CHALLENGER_METRICS_PORT" }}
{{- end }}
{{- end }}