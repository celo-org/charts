{{/*
Expand the name of the chart.
*/}}
{{- define "odis-combiner-rs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "odis-combiner-rs.fullname" -}}
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
{{- define "odis-combiner-rs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "odis-combiner-rs.labels" -}}
helm.sh/chart: {{ include "odis-combiner-rs.chart" . }}
{{ include "odis-combiner-rs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | trunc 63 | trimSuffix "-" | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "odis-combiner-rs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "odis-combiner-rs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "odis-combiner-rs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "odis-combiner-rs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the secret the chart creates for the API key given in plain text.
*/}}
{{- define "odis-combiner-rs.secretName" -}}
{{- include "odis-combiner-rs.fullname" . }}
{{- end }}

{{/*
True when the chart has to create its own secret.
*/}}
{{- define "odis-combiner-rs.createSecret" -}}
{{- if and (not .Values.blockchain.apiKeyExistingSecret) .Values.blockchain.apiKey }}
{{- true }}
{{- end }}
{{- end }}

{{/*
Renders a plain env var, or nothing when the value is null or an empty string.
The Rust combiner refuses empty numbers, so an unset value must leave the variable out.
Whole numbers that YAML parsed as floats (e.g. 11142220) are printed without an exponent.
Usage: include "odis-combiner-rs.envVar" (list "NAME" .Values.some.value)
*/}}
{{- define "odis-combiner-rs.envVar" -}}
{{- $name := index . 0 }}
{{- $value := index . 1 }}
{{- if not (or (kindIs "invalid" $value) (eq (toString $value) "")) }}
{{- if and (kindIs "float64" $value) (eq $value (floor $value)) }}
{{- $value = printf "%d" (int64 $value) }}
{{- end }}
- name: {{ $name }}
  value: {{ toString $value | quote }}
{{- end }}
{{- end }}

{{/*
Renders a list from the values as a JSON env var, and fails unless the list has entries.
Usage: include "odis-combiner-rs.jsonListEnvVar" (list "NAME" .Values.some.list "values.path")
*/}}
{{- define "odis-combiner-rs.jsonListEnvVar" -}}
{{- $name := index . 0 }}
{{- $value := index . 1 }}
{{- $path := index . 2 }}
{{- if not (and (kindIs "slice" $value) $value) }}
{{- fail (printf "%s is required: a list with at least one entry, written to %s as JSON" $path $name) }}
{{- end }}
- name: {{ $name }}
  value: {{ toJson $value | quote }}
{{- end }}
