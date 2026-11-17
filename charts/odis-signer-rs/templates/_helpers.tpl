{{/*
Expand the name of the chart.
*/}}
{{- define "odis-signer-rs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "odis-signer-rs.fullname" -}}
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
{{- define "odis-signer-rs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "odis-signer-rs.labels" -}}
helm.sh/chart: {{ include "odis-signer-rs.chart" . }}
{{ include "odis-signer-rs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | trunc 63 | trimSuffix "-" | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "odis-signer-rs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "odis-signer-rs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "odis-signer-rs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "odis-signer-rs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the secret the chart creates for values given in plain text.
*/}}
{{- define "odis-signer-rs.secretName" -}}
{{- include "odis-signer-rs.fullname" . }}
{{- end }}

{{/*
True when the chart has to create its own secret.
*/}}
{{- define "odis-signer-rs.createSecret" -}}
{{- $db := .Values.database }}
{{- $bc := .Values.blockchain }}
{{- if or (and (not $bc.apiKeyExistingSecret) $bc.apiKey) (and (not $db.urlExistingSecret) $db.url) (and (not $db.urlExistingSecret) (not $db.url) $db.host (not $db.passwordExistingSecret) $db.password) }}
{{- true }}
{{- end }}
{{- end }}

{{/*
Renders a plain env var, or nothing when the value is null or an empty string.
The Rust signer refuses empty numbers and booleans, so an unset value must leave the variable out.
Whole numbers that YAML parsed as floats (e.g. 11142220) are printed without an exponent.
Usage: include "odis-signer-rs.envVar" (list "NAME" .Values.some.value)
*/}}
{{- define "odis-signer-rs.envVar" -}}
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
