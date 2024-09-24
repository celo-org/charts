echo "Starting chain operations"

{{- if .Values.migrationTool.preMigration }}
time celo-migrate pre \
	--old-db /output/celo/chaindata \
	--new-db /output/celo/chaindata_migrated \
  --memory-limit {{ .Values.migrationTool.config.memoryLimit }} \
  --batch-size {{ .Values.migrationTool.config.batchSize }}{{ if .Values.migrationTool.extraArgs }} \{{ end }}
{{- else }}
time celo-migrate full \
  --deploy-config /output/config/config.json \
  --l1-deployments /output/config/deployment-l1.json \
  --l2-allocs /output/config/l2-allocs.json \
  --l1-rpc {{ .Values.l1Url | quote }} \
  --outfile.rollup-config /output/config/rollup.json \
  --outfile.genesis /output/config/genesis.json \
  --old-db /output/celo/chaindata \
  --new-db /output/celo/chaindata_migrated \
  --memory-limit {{ .Values.migrationTool.config.memoryLimit }} \
  --batch-size {{ .Values.migrationTool.config.batchSize }}{{ if .Values.migrationTool.extraArgs }} \{{ end }}
  {{- $length := len .Values.migrationTool.extraArgs }}
  {{- range $index, $value := .Values.migrationTool.extraArgs }}
  {{ tpl $value $ }}{{ if lt $index (sub $length 1) }} \{{ end }}
  {{- end }}

rm -rf /output/celo/chaindata
mv /output/celo/chaindata_migrated /output/celo/chaindata
mv /output/celo /output/geth
{{ if .Values.migrationTool.pauseOnCompletion }}
tail -f /dev/null
{{- end }}
{{- end }}
