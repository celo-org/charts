{{/*
Expand the name of the chart.
*/}}
{{- define "digester-system.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "digester-system.fullname" -}}
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
{{- define "digester-system.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Secret name as is hardcoded in
https://github.com/google/k8s-digester/blob/a0304bcbe5ba51b89c671ad58c62139c0e2172cd/cmd/webhook/webhook.go#L47
*/}}
{{- define "digester-system.secret-name" -}}
{{- printf "digester-webhook-server-cert" }}
{{- end }}

{{/*
Service name as is hardcoded in
https://github.com/google/k8s-digester/blob/a0304bcbe5ba51b89c671ad58c62139c0e2172cd/cmd/webhook/webhook.go#L48
*/}}
{{- define "digester-system.svc-name" -}}
{{- printf "digester-webhook-service" }}
{{- end }}

{{/*
Webhook name as is hardcoded in
https://github.com/google/k8s-digester/blob/a0304bcbe5ba51b89c671ad58c62139c0e2172cd/cmd/webhook/webhook.go#L49
*/}}
{{- define "digester-system.webhook-name" -}}
{{- printf "digester-mutating-webhook-configuration" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "digester-system.labels" -}}
helm.sh/chart: {{ include "digester-system.chart" . }}
{{ include "digester-system.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "digester-system.selectorLabels" -}}
app.kubernetes.io/name: {{ include "digester-system.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "digester-system.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "digester-system.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
