{{/*
Expand the name of the chart.
*/}}
{{- define "ultragreen-dashboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ultragreen-dashboard.fullname" -}}
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
{{- define "ultragreen-dashboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ultragreen-dashboard.labels" -}}
helm.sh/chart: {{ include "ultragreen-dashboard.chart" . }}
{{ include "ultragreen-dashboard.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ultragreen-dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ultragreen-dashboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ultragreen-dashboard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ultragreen-dashboard.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "ultragreen-dashboard.shared-env-vars" -}}
- name: PG_HOST
  value: {{ include "postgresql.primary.fullname" .Subcharts.postgresql }}
- name: PG_PORT
  value: {{ quote (include "postgresql.service.port" .Subcharts.postgresql) }}
- name: PG_USER
  value: {{ include "postgresql.username" .Subcharts.postgresql }}
- name: PG_PSW
  valueFrom:
    secretKeyRef:
      name: {{ include "postgresql.secretName" .Subcharts.postgresql }}
      key: {{ include "postgresql.userPasswordKey" .Subcharts.postgresql }}
- name: PG_DBNAME
  value: {{ include "postgresql.database" .Subcharts.postgresql }}
{{- end -}}
