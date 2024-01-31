{{/* vim: set filetype=mustache: */}}

{{- define "celo.account-secret-name" -}}
{{- $defaultSecretName := printf "%s-attestation-bot-secrets" .Values.environment }}
{{- if and (ne .Values.secrets.existingSecret "") (hasKey .Values.secrets "existingSecret") }}
{{- .Values.secrets.existingSecret }}
{{- else }}
{{- $defaultSecretName }}
{{- end }}
{{- end }}

{{- define "celo.account-secret-mnemonic-key" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.mnemonicKey }}
{{- else -}}
mnemonic
{{- end }}
{{- end }}

{{- define "celo.twilio-account-sid-secret-key" -}}
{{- if and .Values.secrets.existingSecret .Values.secrets.twilioAccountSidKey }}
{{- .Values.secrets.twilioAccountSidKey }}
{{- else -}}
twilioAccountSid
{{- end }}
{{- end }}

{{- define "celo.twilio-account-auth-token-secret-key" -}}
{{- if and .Values.secrets.existingSecret .Values.secrets.twilioAuthTokenKey }}
{{- .Values.secrets.twilioAuthTokenKey }}
{{- else -}}
twilioAuthToken
{{- end }}
{{- end }}

{{- define "celo.twilio-account-address-sid-secret-key" -}}
{{- if and .Values.secrets.existingSecret .Values.secrets.twilioAddressSidKey }}
{{- .Values.secrets.twilioAddressSidKey }}
{{- else -}}
twilioAddressSid
{{- end }}
{{- end }}
