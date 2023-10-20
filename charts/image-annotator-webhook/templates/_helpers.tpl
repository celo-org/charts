---
{{/*
Expand the name of the chart.
*/}}
{{- define "image-annotator-webhook.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "image-annotator-webhook.fullname" -}}
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
{{- define "image-annotator-webhook.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "image-annotator-webhook.labels" -}}
helm.sh/chart: {{ include "image-annotator-webhook.chart" . }}
{{ include "image-annotator-webhook.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "image-annotator-webhook.selectorLabels" -}}
app.kubernetes.io/name: {{ include "image-annotator-webhook.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "image-annotator-webhook.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "image-annotator-webhook.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
* Specifies an env var given a dictionary, the name of the desired value, and
* if it's optional. If optional, the env var is only given if the desired value exists in the dict.
*/}}
{{- define "image-annotator-webhook.env-var" -}}
{{- if or (not .optional) (and (hasKey .dict .value_name) (get .dict .value_name)) }}
- name: {{ .name }}
  value: "{{ (get .dict .value_name) }}"
{{- end }}
{{- end }}

{{/*
* Specifies an env var between single quotes given a dictionary, the name of the desired value, and
* if it's optional. If optional, the env var is only given if the desired value exists in the dict.
*/}}
{{- define "image-annotator-webhook.env-var-squote" -}}
{{- if or (not .optional) (and (hasKey .dict .value_name) (get .dict .value_name)) }}
- name: {{ .name }}
  value: '{{ (get .dict .value_name) }}'
{{- end }}
{{- end }}

{{/*
Port is fixed
*/}}
{{- define "image-annotator-webhook.port" -}}
8443
{{- end }}
