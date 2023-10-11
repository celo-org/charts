{{/*
Expand the name of the chart.
*/}}
{{- define "odis-loadtest.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "odis-loadtest.fullname" -}}
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
{{- define "odis-loadtest.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "odis-loadtest.labels" -}}
helm.sh/chart: {{ include "odis-loadtest.chart" . }}
{{ include "odis-loadtest.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "odis-loadtest.selectorLabels" -}}
app.kubernetes.io/name: {{ include "odis-loadtest.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "odis-loadtest.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "odis-loadtest.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
ODIS loadTest secret name and key
*/}}
{{- define "odis-loadtest.secret" -}}
private-key
{{- end }}

{{/*
* Specifies an env var given a dictionary, the name of the desired value, and
* if it's optional. If optional, the env var is only given if the desired value exists in the dict.
*/}}
{{- define "odis-loadtest.env-var" -}}
{{- if or (not .optional) (and (hasKey .dict .value_name) (get .dict .value_name)) }}
- name: {{ .name }}
  value: "{{ (get .dict .value_name) }}"
{{- end }}
{{- end }}

{{/*
* Specifies an env var between single quotes given a dictionary, the name of the desired value, and
* if it's optional. If optional, the env var is only given if the desired value exists in the dict.
*/}}
{{- define "odis-loadtest.env-var-squote" -}}
{{- if or (not .optional) (and (hasKey .dict .value_name) (get .dict .value_name)) }}
- name: {{ .name }}
  value: '{{ (get .dict .value_name) }}'
{{- end }}
{{- end }}
