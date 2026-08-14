{{/*
Expand the name of the chart.
*/}}
{{- define "celox.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "celox.fullname" -}}
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
{{- define "celox.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "celox.labels" -}}
helm.sh/chart: {{ include "celox.chart" . }}
{{ include "celox.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "celox.selectorLabels" -}}
app.kubernetes.io/name: {{ include "celox.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "celox.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "celox.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
celox arguments, shared by the Deployment and the Job so the two cannot drift.

Only the flags the selected workload actually reads are emitted: celox rejects
unknown combinations, and passing --data-size to a transfer run would just be
noise in `kubectl describe`.

The image ENTRYPOINT is celox itself, so these are container args with no shell
wrapper. That keeps extraArgs a real YAML list rather than a string that has to
be spliced into a command line.

Integer flags go through int64. Helm parses plain YAML numbers as float64 and
renders anything large in scientific notation, so `keySpace: 1000000` would
otherwise reach clap as `1e+06` and fail to parse as a u64. `tps` is exempt:
celox reads it as f64, and Rust's float parser accepts that form.
*/}}
{{- define "celox.args" -}}
- --rpc-url={{ .Values.config.rpcUrl }}
- --workload={{ .Values.config.workload }}
- --tps={{ .Values.config.tps }}
- --senders={{ int64 .Values.config.senders }}
- --window={{ int64 .Values.config.window }}
- --fund={{ .Values.config.fund }}
- --receipt-timeout={{ .Values.config.receiptTimeout }}
- --poll-interval={{ .Values.config.pollInterval }}
{{- if eq .Values.kind "Job" }}
- --duration={{ required "config.duration is required when kind is Job, otherwise the Job never terminates" .Values.config.duration }}
{{- else if .Values.config.duration }}
- --duration={{ .Values.config.duration }}
{{- end }}
{{- if eq .Values.config.workload "transfer" }}
- --recipient={{ .Values.config.recipient }}
{{- end }}
{{- if eq .Values.config.workload "calldata" }}
- --data-size={{ int64 .Values.config.dataSize }}
{{- end }}
{{- if eq .Values.config.workload "storage" }}
- --writes={{ int64 .Values.config.writes }}
- --key-space={{ int64 .Values.config.keySpace }}
{{- end }}
{{- if eq .Values.config.workload "cip64" }}
- --fee-currency={{ required "config.feeCurrency is required by the cip64 workload" .Values.config.feeCurrency }}
- --fund-token={{ .Values.config.fundToken }}
{{- end }}
{{- with .Values.extraArgs }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Pod spec shared by the Deployment and the Job. restartPolicy differs, so it is
set by the caller rather than here.
*/}}
{{- define "celox.podSpec" -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
serviceAccountName: {{ include "celox.serviceAccountName" . }}
securityContext:
  {{- toYaml .Values.podSecurityContext | nindent 2 }}
containers:
  - name: {{ .Chart.Name }}
    securityContext:
      {{- toYaml .Values.securityContext | nindent 6 }}
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    args:
      {{- include "celox.args" . | nindent 6 }}
    {{- if .Values.secretEnv }}
    env:
      {{- range $key, $value := .Values.secretEnv }}
      - name: {{ $key }}
        valueFrom:
          secretKeyRef:
            name: {{ $value.secretName }}
            key: {{ $value.secretKey }}
      {{- end }}
    {{- end }}
    resources:
      {{- toYaml .Values.resources | nindent 6 }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
