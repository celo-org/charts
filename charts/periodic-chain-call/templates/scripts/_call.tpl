{{- if .Values.senderKey.value }}
sender_address=$(cast wallet address --private-key {{ .Values.senderKey.value }})
balance=$(cast balance --rpc-url {{ .Values.rpcURL}} $sender_address)

echo "Sending address $sender_address has $balance account balance"

cast send --private-key "{{ .Values.senderKey.value  }}" --rpc-url "{{ .Values.rpcURL }}" "{{ .Values.contractAddress }}" "{{ .Values.functionSignature }}" "{{ .Values.functionArgs }}"
{{- else }}
cast call --rpc-url {{ .Values.rpcURL }} "{{ .Values.contractAddress }}" "{{ .Values.functionSignature }}" "{{ .Values.functionArgs }}"
{{- end }}