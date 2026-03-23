{{/*
Expand the name of the chart.
*/}}
{{- define "espresso-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "espresso-node.fullname" -}}
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
{{- define "espresso-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "espresso-node.labels" -}}
helm.sh/chart: {{ include "espresso-node.chart" . }}
{{ include "espresso-node.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "espresso-node.selectorLabels" -}}
app.kubernetes.io/name: {{ include "espresso-node.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "espresso-node.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "espresso-node.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Secret name for private keys
*/}}
{{- define "espresso-node.secretName" -}}
{{- if .Values.espresso.existingSecret }}
{{- .Values.espresso.existingSecret }}
{{- else }}
{{- include "espresso-node.fullname" . }}-keys
{{- end }}
{{- end }}

{{/*
PostgreSQL host - use subchart if enabled, otherwise use configured host
*/}}
{{- define "espresso-node.postgresHost" -}}
{{- if .Values.espresso.storage.postgresHost }}
{{- .Values.espresso.storage.postgresHost }}
{{- else if .Values.postgresql.enabled }}
{{- include "espresso-node.fullname" . }}-postgresql
{{- else }}
{{- "localhost" }}
{{- end }}
{{- end }}

{{/*
Compute the sequencer command based on mode.
Mainnet 1 uses /bin/sequencer-postgres binary.
Commands per Espresso team instructions (2026-02-23):
  Non-DA: /bin/sequencer-postgres -- http -- catchup -- status -- config
  DA:     /bin/sequencer-postgres -- http -- catchup -- query -- hotshot-events -- submit -- status -- storage-sql -- light-client -- explorer -- config
*/}}
{{- define "espresso-node.command" -}}
{{- if .Values.commandOverride }}
{{- .Values.commandOverride }}
{{- else if eq .Values.mode "da" }}
/bin/sequencer-postgres -- http -- catchup -- query -- hotshot-events -- submit -- status -- storage-sql -- light-client -- explorer -- config
{{- else if eq .Values.mode "archival" }}
/bin/sequencer-postgres -- http -- catchup -- query -- hotshot-events -- submit -- status -- storage-sql -- light-client -- explorer -- config
{{- else }}
/bin/sequencer-postgres -- http -- catchup -- status -- config
{{- end }}
{{- end }}

{{/*
State peers value — appends /v1 suffix to each peer URL for DA/archival modes.
Ref: https://docs.espressosys.com/network/releases/mainnet-1/running-a-mainnet-1-node
*/}}
{{- define "espresso-node.statePeers" -}}
{{- if or (eq .Values.mode "da") (eq .Values.mode "archival") -}}
{{- range $i, $peer := splitList "," .Values.espresso.statePeers -}}
{{- if $i }},{{ end -}}
{{- printf "%s/v1" (trimSuffix "/" (trim $peer)) -}}
{{- end -}}
{{- else -}}
{{- .Values.espresso.statePeers -}}
{{- end -}}
{{- end }}

{{/*
Container image reference
*/}}
{{- define "espresso-node.image" -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end }}
