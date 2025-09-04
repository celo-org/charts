{{/*
Expand the name of the chart.
*/}}
{{- define "op-succinct-base.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "op-succinct-base.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "op-succinct-base.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "op-succinct-base.labels" -}}
helm.sh/chart: {{ include "op-succinct-base.chart" . }}
{{ include "op-succinct-base.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "op-succinct-base.selectorLabels" -}}
app.kubernetes.io/name: {{ include "op-succinct-base.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "op-succinct-base.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "op-succinct-base.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the full image name
*/}}
{{- define "op-succinct-base.image" -}}
{{- printf "%s/%s:%s" .Values.image.repository .Values.app.type (.Values.image.tag | default .Chart.AppVersion) }}
{{- end }}

{{/*
Get the metrics port name based on app type
*/}}
{{- define "op-succinct-base.metricsPortName" -}}
{{- if eq .Values.app.type "proposer" }}
{{- "PROPOSER_METRICS_PORT" }}
{{- else }}
{{- "CHALLENGER_METRICS_PORT" }}
{{- end }}
{{- end }}