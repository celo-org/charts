# Install dependencies
apk add --no-cache tar zstd curl bash python3 pv

# Install gcloud cli
curl -sSL https://sdk.cloud.google.com | bash -s -- --disable-prompts
source /root/google-cloud-sdk/path.bash.inc
/root/google-cloud-sdk/bin/gcloud components install alpha -q

# Uplaod rollup config
/root/google-cloud-sdk/bin/gcloud alpha storage cp /output/config/rollup.json gs://{{ .Values.gcsBucket | trimPrefix "gs://" | trimSuffix "/" }}/{{ .Values.cel2NetworkName }}-rollup.json

# Uplaod genesis
/root/google-cloud-sdk/bin/gcloud alpha storage cp /output/config/genesis.json gs://{{ .Values.gcsBucket | trimPrefix "gs://" | trimSuffix "/" }}/{{ .Values.cel2NetworkName }}-genesis.json

# Delete jwt and nodekey
rm -f /output/geth/nodekey /output/geth/jwtsecret

# Compress the node data using zstd
echo "Compressing the node data. Progress is referenced to the uncompressed size, so you can expect it won't reach 100%"
cd /output && tar -I 'zstd -T0' -cf - geth | pv -s $(du -sb /output/geth | awk '{print $1}') > {{ .Values.cel2NetworkName }}-cel2.tar.zstd

# Upload the compressed data to the bucket
/root/google-cloud-sdk/bin/gcloud alpha storage cp /output/{{ .Values.cel2NetworkName }}-cel2.tar.zstd gs://{{ .Values.gcsBucket | trimPrefix "gs://" | trimSuffix "/" }}/{{ .Values.cel2NetworkName }}-cel2.tar.zstd