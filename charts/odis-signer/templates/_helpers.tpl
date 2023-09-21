{{/*
Expand the name of the chart.
*/}}
{{- define "odis-signer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "odis-signer.fullname" -}}
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
{{- define "odis-signer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "odis-signer.labels" -}}
helm.sh/chart: {{ include "odis-signer.chart" . }}
{{ include "odis-signer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "odis-signer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "odis-signer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "odis-signer.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "odis-signer.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
ODIS signer port is fixed
*/}}
{{- define "odis-signer.port" -}}
3000
{{- end }}

{{/*
ODIS signer secret name and key
*/}}
{{- define "odis-signer.secret" -}}
db-password
{{- end }}

{{/*
* Specifies an env var given a dictionary, the name of the desired value, and
* if it's optional. If optional, the env var is only given if the desired value exists in the dict.
*/}}
{{- define "odis-signer.env-var" -}}
{{- if or (not .optional) (and (hasKey .dict .value_name) (get .dict .value_name)) }}
- name: {{ .name }}
  value: "{{ (get .dict .value_name) }}"
{{- end }}
{{- end }}