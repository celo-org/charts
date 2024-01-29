{{/* vim: set filetype=mustache: */}}

{{- define "celo.account-secret-name" -}}
{{- $defaultSecretName := printf "%s-load-test" (include "common.fullname" .) }}
{{- .Values.secrets.existingSecret | default $defaultSecretName }}
{{- end }}

{{- define "celo.account-secret-mnemonic-key" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.mnemonicKey }}
{{- else -}}
mnemonic
{{- end }}
{{- end }}

{{- define "celo.account-secret-account-secret-key" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.accountSecretKey }}
{{- else -}}
accountSecret
{{- end }}
{{- end }}
