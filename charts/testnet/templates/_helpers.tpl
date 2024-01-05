{{/* vim: set filetype=mustache: */}}

{{- define "celo.geth-exporter-container" -}}
- name: geth-exporter
  image: "{{ .Values.gethexporter.image.repository }}:{{ .Values.gethexporter.image.tag }}"
  imagePullPolicy: {{ .Values.imagePullPolicy }}
  ports:
    - name: profiler
      containerPort: 9200
  command:
    - /usr/local/bin/geth_exporter
    - -ipc
    - /root/.celo/geth.ipc
    - -filter
    - (.*overall|percentiles_95)
  resources:
    requests:
      memory: 50M
      cpu: 50m
  volumeMounts:
  - name: data
    mountPath: /root/.celo
{{- end -}}

{{- /* This template does not define ports that will be exposed */ -}}
{{- define "celo.node-service" }}
kind: Service
apiVersion: v1
metadata:
  name: {{ template "common.fullname" $ }}-{{ .svc_name | default .node_name }}-{{ .index }}{{ .svc_name_suffix | default "" }}
  labels:
    {{- include "common.standard.labels" .  | nindent 4 }}
    component: {{ .component_label }}
spec:
  selector:
    statefulset.kubernetes.io/pod-name: {{ template "common.fullname" $ }}-{{ .node_name }}-{{ .index }}
  type: {{ .service_type }}
  publishNotReadyAddresses: true
  {{- if and (eq .service_type "LoadBalancer") .load_balancer_ip }}
  loadBalancerIP: {{ .load_balancer_ip }}
  {{- end -}}
{{- end -}}

{{- define "celo.full-node-statefulset" -}}
{{- if gt (int .replicas) 0 -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .name }}
  labels:
    {{- if .proxy | default false }}
    {{- $validatorProxied := printf "%s-validators-%d" .Release.Namespace .validator_index }}
    validator-proxied: "{{ $validatorProxied }}"
    {{- end }}
    component: {{ .component_label }}
spec:
  sessionAffinity: None
  ports:
  - port: 8545
    name: rpc
  {{- $wsPort := ((.ws_port | default .Values.geth.ws_port) | int) -}}
  {{- if ne $wsPort 8545 }}
  - port: {{ $wsPort }}
    name: ws
  {{- end }}
  selector:
    {{- if .proxy | default false }}
    {{- $validatorProxied := printf "%s-validators-%d" .Release.Namespace .validator_index }}
    validator-proxied: "{{ $validatorProxied }}"
    {{- end }}
    component: {{ .component_label }}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .name }}-headless
  labels:
    {{- if .proxy | default false }}
    {{- $validatorProxied := printf "%s-validators-%d" .Release.Namespace .validator_index }}
    validator-proxied: "{{ $validatorProxied }}"
    {{- end }}
    component: {{ .component_label }}
spec:
  type: ClusterIP
  clusterIP: None
  ports:
  - port: 8545
    name: rpc
  {{- if ne $wsPort 8545 }}
  - port: {{ .ws_port | default .Values.geth.ws_port }}
    name: ws
  {{- end }}
  selector:
    {{- if .proxy | default false }}
    {{- $validatorProxied := printf "%s-validators-%d" .Release.Namespace .validator_index }}
    validator-proxied: "{{ $validatorProxied }}"
    {{- end }}
    component: {{ .component_label }}
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ template "common.fullname" . }}-{{ .name }}
  labels:
    {{- include "common.standard.labels" .  | nindent 4 }}
    component: {{ .component_label }}
    {{- if .proxy | default false }}
    {{- $validatorProxied := printf "%s-validators-%d" .Release.Namespace .validator_index }}
    validator-proxied: "{{ $validatorProxied }}"
    {{- end }}
spec:
  {{- $updateStrategy := index $.Values.updateStrategy $.component_label }}
  updateStrategy:
    {{- toYaml $updateStrategy | nindent 4 }}
  {{- if .Values.geth.storage }}
  volumeClaimTemplates:
  - metadata:
      name: data
      {{- if .pvc_annotations }}
      annotations:
        {{- toYaml .pvc_annotations | nindent 8 }}
      {{- end }}
    spec:
      {{- with $.Values.geth.storageClassName }}
      storageClassName: {{ . }}
      {{- end }}
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          {{- $disk_size := ternary .Values.geth.privateTxNodediskSizeGB .Values.geth.diskSizeGB (eq .name "tx-nodes-private") }}
          storage: {{ $disk_size }}Gi
      {{- with .dataSource }}
      dataSource:
        {{- toYaml . | nindent 8 }}
      {{- end }}
  {{- end }}
  podManagementPolicy: Parallel
  replicas: {{ .replicas }}
  serviceName: {{ .name }}
  selector:
    matchLabels:
      {{- include "common.standard.short_labels" .  | nindent 6 }}
      component: {{ .component_label }}
      {{- if .proxy | default false }}
      {{- $validatorProxied := printf "%s-validators-%d" .Release.Namespace .validator_index }}
      validator-proxied: "{{ $validatorProxied }}"
      {{- end }}
  template:
    metadata:
      labels:
        {{- include "common.standard.short_labels" .  | nindent 8 }}
        component: {{ .component_label }}
        {{- if .extraPodLabels -}}
        {{- toYaml .extraPodLabels | nindent 8 }}
        {{- end }}
        {{- if .proxy | default false }}
        {{- $validatorProxied := printf "%s-validators-%d" .Release.Namespace .validator_index }}
        validator-proxied: "{{ $validatorProxied }}"
        {{- end }}
      annotations:
        clabs.co/images: "{{ .Values.geth.image.repository }}:{{ .Values.geth.image.tag }}; {{ .Values.celotool.image.repository }}:{{ .Values.celotool.image.tag }}"
        {{- include "common.prometheus-annotations" (dict "pprof" .Values.geth.pprof ) | nindent 8 }}
    spec:
      initContainers:
      {{- include "common.conditional-init-genesis-container" .  | nindent 6 }}
      {{- include "common.celotool-full-node-statefulset-container" (dict
        "Values" .Values
        "Release" .Release
        "Chart" .Chart
        "proxy" .proxy
        "mnemonic_account_type" .mnemonic_account_type
        "service_ip_env_var_prefix" .service_ip_env_var_prefix
        "ip_addresses" .ip_addresses
        "validator_index" .validator_index
        "secret_name" (include "celo.account-secret-name" .)
        "mnemonic_key" (include "celo.account-secret-mnemonic-key" .)
        ) | nindent 6 }}
      {{- if .unlock | default false }}
      {{- include "common.import-geth-account-container" .  | nindent 6 }}
      {{- end }}
      containers:
      {{- include "common.full-node-container" (dict
        "Values" .Values
        "Release" .Release
        "Chart" .Chart
        "proxy" .proxy
        "proxy_allow_private_ip_flag" .proxy_allow_private_ip_flag
        "unlock" .unlock
        "rpc_apis" .rpc_apis
        "expose" .expose
        "rcp_gascap" (default (int .Values.geth.rpc_gascap) (int .rcp_gascap))
        "syncmode" .syncmode
        "gcmode" .gcmode
        "resources" .resources
        "ws_port" (default .Values.geth.ws_port .ws_port)
        "pprof" (or (.Values.metrics) (.Values.geth.pprof.enabled))
        "pprof_port" (.Values.geth.pprof.port)
        "light_serve" .Values.geth.light.serve
        "light_maxpeers" .Values.geth.light.maxpeers
        "maxpeers" .Values.geth.maxpeers
        "metrics" .Values.metrics
        "public_ips" .public_ips
        "ethstats" (printf "%s-ethstats.%s" (include "common.fullname" .) .Release.Namespace)
        "extra_setup" .extra_setup
        ) | nindent 6 }}
      terminationGracePeriodSeconds:  {{ .Values.geth.terminationGracePeriodSeconds | default 300 }}
      {{- with .affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .node_selector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      volumes:
      - name: data
        emptyDir: {}
      - name: data-shared
        emptyDir: {}
      - name: config
        configMap:
          name: {{ template "common.fullname" . }}-geth-config
      - name: account
        secret:
          secretName: {{ include "celo.account-secret-name" . }}
{{- end -}}
{{- end -}}

{{- /* This template puts a semicolon-separated pair of proxy enodes into $PROXY_ENODE_URL_PAIR. */ -}}
{{- /* I.e <internal enode>;<external enode>. */ -}}
{{- /* Expects env variables MNEMONIC, RID (the validator index), and PROXY_INDEX */ -}}
{{- define "celo.proxyenodeurlpair" -}}
echo "Generating proxy enode url pair for proxy $PROXY_INDEX"
PROXY_INTERNAL_IP_ENV_VAR={{ $.Release.Namespace | upper | replace "-" "_" }}_VALIDATORS_${RID}_PROXY_INTERNAL_${PROXY_INDEX}_SERVICE_HOST
echo "PROXY_INTERNAL_IP_ENV_VAR=$PROXY_INTERNAL_IP_ENV_VAR"
PROXY_INTERNAL_IP=`eval "echo \\${${PROXY_INTERNAL_IP_ENV_VAR}}"`
# If $PROXY_IPS is not empty, then we use the IPs from there. Otherwise,
# we use the IP address of the proxy internal service
if [ ! -z $PROXY_IPS ]; then
  echo "Proxy external IP from PROXY_IPS=$PROXY_IPS: "
  PROXY_EXTERNAL_IP=`echo -n $PROXY_IPS | cut -d '/' -f $((PROXY_INDEX + 1))`
else
  PROXY_EXTERNAL_IP=$PROXY_INTERNAL_IP
fi
echo "Proxy internal IP: $PROXY_INTERNAL_IP"
echo "Proxy external IP: $PROXY_EXTERNAL_IP"
# Proxy key index to allow for a high number of proxies per validator without overlap
PROXY_KEY_INDEX=$(( ($RID * 10000) + $PROXY_INDEX ))
PROXY_ENODE_ADDRESS=`celotooljs.sh generate public-key --mnemonic "$MNEMONIC" --accountType proxy --index $PROXY_KEY_INDEX`
PROXY_INTERNAL_ENODE=enode://${PROXY_ENODE_ADDRESS}@${PROXY_INTERNAL_IP}:30503
PROXY_EXTERNAL_ENODE=enode://${PROXY_ENODE_ADDRESS}@${PROXY_EXTERNAL_IP}:30303
echo "Proxy internal enode: $PROXY_INTERNAL_ENODE"
echo "Proxy external enode: $PROXY_EXTERNAL_ENODE"
PROXY_ENODE_URL_PAIR=$PROXY_INTERNAL_ENODE\;$PROXY_EXTERNAL_ENODE
{{- end -}}

{{- define "celo.proxyipaddresses" -}}
{{- if .Values.geth.static_ips -}}
{{- index .Values.geth.proxyIPAddressesPerValidatorArray .validatorIndex -}}
{{- end -}}
{{- end -}}

{{- define "celo.account-secret-name" -}}
{{- $defaultSecretName := printf "%s-geth-account" (include "common.fullname" .) }}
{{- .Values.secrets.existingSecret | default $defaultSecretName }}
{{- end }}

{{- define "celo.account-secret-bootnode-key" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.bootnodePrivatekeyKey }}
{{- else -}}
privateKey
{{- end }}
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
