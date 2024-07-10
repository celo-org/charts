echo "Starting chain operations"

time celo-migrate full \
  --deploy-config /output/config/config.json \
  --l1-deployments /output/config/deployment-l1.json \
  --l2-allocs /output/config/l2-allocs.json \
  --l1-rpc {{ .Values.l1Url | quote }} \
  --outfile.rollup-config /output/config/rollup.json \
  --old-db /output/celo/chaindata \
  --new-db /output/celo/chaindata_migrated \
  --memory-limit {{ .Values.migrationTool.config.memoryLimit }} \
  --batch-size {{ .Values.migrationTool.config.batchSize }} \
{{- range .Values.migrationTool.extraArgs }}
{{ tpl (.) $ }} \
{{- end }}

rm -rf /output/celo/chaindata
mv /output/celo/chaindata_migrated /output/celo/chaindata
mv /output/celo /output/geth
tail -f /dev/null