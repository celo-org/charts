{{- define "sync-test.validate" -}}
{{- $geth := index .Values "op-geth" -}}
{{- $node := index .Values "op-node" -}}

{{- $_ := required "op-geth.image.repository is required: --set op-geth.image.repository=..." $geth.image.repository -}}
{{- $_ := required "op-geth.image.tag is required: --set op-geth.image.tag=..." $geth.image.tag -}}
{{- $_ := required "op-geth.secrets.nodeKey.value is required: --set op-geth.secrets.nodeKey.value=0x$(openssl rand -hex 32)" $geth.secrets.nodeKey.value -}}

{{- $_ := required "op-node.image.repository is required: --set op-node.image.repository=..." $node.image.repository -}}
{{- $_ := required "op-node.image.tag is required: --set op-node.image.tag=..." $node.image.tag -}}
{{- $_ := required "op-node.secrets.p2pKeys.value is required: --set op-node.secrets.p2pKeys.value=0x$(openssl rand -hex 32)" $node.secrets.p2pKeys.value -}}

{{- if .Values.snapshot.enabled -}}
{{- $_ := required "snapshot.volumeSnapshotName is required for consensus/execution mode: --set snapshot.volumeSnapshotName=..." .Values.snapshot.volumeSnapshotName -}}
{{- end -}}

{{- end -}}
