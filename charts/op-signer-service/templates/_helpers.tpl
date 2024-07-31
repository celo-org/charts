{{/*
Expand the name of the chart.
*/}}
{{- define "op-signer-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "op-signer-service.fullname" -}}
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
{{- define "op-signer-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "op-signer-service.labels" -}}
helm.sh/chart: {{ include "op-signer-service.chart" . }}
{{ include "op-signer-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "op-signer-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "op-signer-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "op-signer-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "op-signer-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Container signer port
*/}}
{{- define "op-signer-service.port" -}}
{{- if .Values.service.port }}
{{- .Values.service.port }}
{{- else }}
3000
{{- end }}
{{- end }}

{{/*
Container TLS signer port
*/}}
{{- define "op-signer-service.tls-port" -}}
{{- if .Values.service.tlsPort }}
{{- .Values.service.tlsPort }}
{{- else }}
3001
{{- end }}
{{- end }}
