mkdir -p /output/config
wget -O /output/config/config.json {{ .Values.download.config }}
wget -O /output/config/deployment-l1.json {{ .Values.download.deploymentL1 }}
wget -O /output/config/l2-allocs.json {{ .Values.download.l2Allocs }}
{{- if not .Values.pvc.useOutputAsInput }}
apk add -U rsync
echo "Copying chaindata to /output/celo/chaindata"
rsync -ah --progress /input/celo /output/
{{- end }}