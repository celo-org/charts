{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "celo-lightestnode.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "celo-lightestnode.fullname" -}}
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
{{- define "celo-lightestnode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "celo-lightestnode.rpc-ports" -}}
- port: 8545
  targetPort: rpc
  protocol: TCP
  name: rpc
- port: 8546
  targetPort: ws
  protocol: TCP
  name: ws
{{- end }}

{{/*
 * The easiest way to get the public IP for the node (VM) that a EKS pod is on
 * is to just make a web request. Unfortunately it is not possible to get it
 * from the downward k8s API.
*/}}
{{- define "celo-lightestnode.aws-subnet-specific-nat-ip" -}}
{{- if .Values.aws }}
PUBLIC_IP=$(wget https://ipinfo.io/ip -O - -q)
NAT_FLAG="--nat=extip:${PUBLIC_IP}"
{{- end }}
{{- end }}

{{/*
 * Blockscout indexer requests can take longer than default
 * request timeouts.
 * Adding a dummy comment (template .extra_setup) because helm indenting problems if this template is empty
*/}}
{{- define "celo-lightestnode.extra_setup" -}}
# template .extra_setup
{{- include "celo-lightestnode.aws-subnet-specific-nat-ip" . }}
{{- if .Values.geth.increase_timeouts }}
ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --http.timeout.read 600 --http.timeout.write 600 --http.timeout.idle 2400"
{{- end }}
{{- end }}

{{/*
 * This will create an HTTP server at .server_port
 * that is intended for GCP NEG health checks. It will
 * ensure that TCP at port .tcp_check_port works and
 * that the /health-check.sh script passes. This script
 * ensures that the node is not syncing and its most recent
 * block is at most 30 seconds old.
*/}}
{{- define "celo-lightestnode.health-checker-server" -}}
- name: health-checker-server-{{ .protocol_name }}
  image: us.gcr.io/celo-testnet/health-checker:0.0.5
  imagePullPolicy: IfNotPresent
  args:
  - --script=/health-check.sh
  - --listener=0.0.0.0:{{ .server_port }}
  - --port={{ .tcp_check_port }}
  ports:
  - name: health-check
    containerPort: {{ .server_port }}
  volumeMounts:
  - name: health-check
    mountPath: /health-check.sh
    subPath: health-check.sh
  - name: data-shared
    mountPath: /data-shared
{{- end }}

{{- define "lightest-node-container" -}}
- name: geth
  image: {{ .Values.geth.image.repository }}:{{ .Values.geth.image.tag }}
  imagePullPolicy: {{ .Values.geth.image.imagePullPolicy }}
  command:
  - /bin/sh
  - -c
  args:
  - |
    set -euo pipefail
    RID=$(echo $REPLICA_NAME | grep -Eo '[0-9]+$')
    NAT_FLAG=""
    if [[ ! -z $IP_ADDRESSES ]]; then
      NAT_IP=$(echo "$IP_ADDRESSES" | awk -v RID=$(expr "$RID" + "1") '{split($0,a,","); print a[RID]}')
    fi

    # Taking local ip for natting (probably this means pod cannot have incomming connection from external LAN peers)
    set +u
    if [[ -z $NAT_IP ]]; then
      if [[ -f /root/.celo/ipAddress ]]; then
        NAT_IP=$(cat /root/.celo/ipAddress)
      else
        NAT_IP=$(hostname -i)
      fi
    fi
    NAT_FLAG="--nat=extip:${NAT_IP}"
    set -u

    ADDITIONAL_FLAGS='{{ .geth_flags | default "" }}'
    if [[ -f /root/.celo/pkey ]]; then
      NODE_KEY=$(cat /root/.celo/pkey)
      if [[ ! -z ${NODE_KEY} ]]; then
        ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --nodekey=/root/.celo/pkey"
      fi
    fi
    {{- if .proxy | default false }}
    VALIDATOR_HEX_ADDRESS=$(cat /root/.celo/validator_address)
    ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --proxy.proxiedvalidatoraddress $VALIDATOR_HEX_ADDRESS --proxy.proxy --proxy.internalendpoint :30503"
    {{- end }}

    {{- if .proxied | default false }}
    ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --proxy.proxiedvalidatoraddress $VALIDATOR_HEX_ADDRESS --proxy.proxy --proxy.internalendpoint :30503"
    {{- end }}
    {{- if .unlock | default false }}
    ACCOUNT_ADDRESS=$(cat /root/.celo/address)
    ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --unlock=${ACCOUNT_ADDRESS} --password /root/.celo/account/accountSecret --allow-insecure-unlock"
    {{- end }}
    {{- if .expose }}
    {{- include  "common.geth-http-ws-flags" (dict "Values" $.Values "rpc_apis" (default "eth,net,web3,debug,txpool" .rpc_apis) "ws_port" (default .Values.geth.ws_port .ws_port ) "listen_address" "0.0.0.0") | nindent 4 }}
    {{- end }}
    {{- if .ping_ip_from_packet | default false }}
    ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --ping-ip-from-packet"
    {{- end }}
    {{- if .in_memory_discovery_table_flag | default false }}
    ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --use-in-memory-discovery-table"
    {{- end }}
    {{- if .proxy_allow_private_ip_flag | default false }}
    ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --proxy.allowprivateip"
    {{- end }}
    {{- if .ethstats | default false }}
    ACCOUNT_ADDRESS=$(cat /root/.celo/address)
    if grep -nri ${ACCOUNT_ADDRESS#0x} /root/.celo/keystore/ > /dev/null; then
      :
    {{- if .proxy | default false }}
      ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --etherbase=${ACCOUNT_ADDRESS}"
      [[ "$RID" -eq 0 ]] && ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --ethstats=${HOSTNAME}@{{ .ethstats }}"
    {{- else }}
    {{- if not (.proxied | default false) }}
      ADDITIONAL_FLAGS="${ADDITIONAL_FLAGS} --ethstats=${HOSTNAME}@{{ .ethstats }}"
    {{- end }}
    {{- end }}
    fi
    {{- end }}

    {{- include  "common.geth-add-metrics-pprof-config" (dict "metrics" .Values.metrics "pprof" .Values.geth.pprof) | nindent 4 }}

    PORT=30303

    {{- if .ports }}
    PORTS_PER_RID={{ join "," .ports }}
    PORT=$(echo $PORTS_PER_RID | cut -d ',' -f $((RID + 1)))
    {{- end }}

    {{- include  "common.bootnode-flag-script" . | nindent 4 }}

    {{ default "# No extra setup" .extra_setup | nindent 4 | trim }}

    exec geth \
      --port $PORT \
      {{- $mainnet_envs := list "mainnet" "rc1" -}}
      {{- if not (has .Values.genesis.network $mainnet_envs) }}
      $BOOTNODE_FLAG \
      {{- end }}
      --maxpeers={{ if kindIs "invalid" .maxpeers }}1200{{ else }}{{ .maxpeers }}{{ end }} \
      --nousb \
      --syncmode=lightest \
      --rpc.gascap={{ printf "%v" (default (int .Values.geth.rpc_gascap) (int .rcp_gascap)) }} \
      ${NAT_FLAG} \
      --consoleformat=json \
      --consoleoutput=stdout \
      --verbosity={{ .Values.geth.verbosity }} \
      --vmodule={{ .Values.geth.vmodule }} \
      --datadir=/root/.celo \
      --ipcpath=geth.ipc \
      ${ADDITIONAL_FLAGS}
  env:
  - name: NETWORK_ID
    value: "{{ .Values.genesis.networkId }}"
  - name: IP_ADDRESSES
    value: "{{ join "," .ip_addresses }}"
  - name: REPLICA_NAME
    valueFrom:
      fieldRef:
        fieldPath: metadata.name
  {{- if .Values.aws }}
  - name: HOST_IP
    valueFrom:
      fieldRef:
        fieldPath: status.hostIP
  {{- end }}
  {{- include  "common.geth-prestop-hook" . | nindent 2 -}}
  {{/* TODO: make this use IPC */}}
  {{- if .expose }}
  readinessProbe:
    exec:
      command:
      - /bin/sh
      - "-c"
      - |
        {{- include "common.node-health-check" (dict "maxpeers" .maxpeers "light_maxpeers" .light_maxpeers ) | nindent 8 }}
    initialDelaySeconds: 20
    periodSeconds: 10
  {{- end }}
  ports:
  {{- if .ports }}
  {{- range $index, $port := .ports }}
  - name: discovery-{{ $port }}
    containerPort: {{ $port }}
    protocol: UDP
  - name: ethereum-{{ $port }}
    containerPort: {{ $port }}
  {{- end }}
  {{- else }}
  - name: discovery
    containerPort: 30303
    protocol: UDP
  - name: ethereum
    containerPort: 30303
  {{- end }}
  {{- if .expose }}
  - name: rpc
    containerPort: 8545
  - name: ws
    containerPort: {{ default .Values.geth.ws_port .ws_port }}
  {{- end }}
  {{- if .pprof }}
  - name: pprof
    containerPort: {{ .pprof_port }}
  {{- end }}
  {{- $resources := default .Values.geth.resources .resources -}}
  {{- with $resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  volumeMounts:
  - name: data
    mountPath: /root/.celo
  - name: data-shared
    mountPath: /data-shared
  {{- if .ethstats }}
  - name: account
    mountPath: /root/.celo/account
    readOnly: true
  {{- end }}
{{- end }}

{{- define "common.geth-prestop-hook" -}}
lifecycle:
  preStop:
    exec:
      command: ["/bin/sh","-c","killall -SIGTERM geth; while killall -0 geth; do sleep 1; done"]
{{- end }}

{{- define "common.geth-configmap" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ template "common.fullname" . }}-geth-config
  labels:
    {{- include "common.standard.labels" .  | nindent 4 }}
data:
  networkid: {{ $.Values.genesis.networkId | quote }}
  {{- if eq (default $.Values.genesis.useGenesisFileBase64 "false") "true" }}
  genesis.json: {{ $.Values.genesis.genesisFileBase64 | b64dec | quote }}
  {{- end }}
{{- end }}

{{- define "common.celotool-full-node-statefulset-container" -}}
- name: get-account
  image: {{ .Values.celotool.image.repository }}:{{ .Values.celotool.image.tag }}
  imagePullPolicy: {{ .Values.celotool.image.imagePullPolicy }}
  command:
    - bash
    - "-c"
    - |
      [[ $REPLICA_NAME =~ -([0-9]+)$ ]] || exit 1
      RID=${BASH_REMATCH[1]}
      {{- if .proxy }}
      # To allow proxies to scale up easily without conflicting with keys of
      # proxies associated with other validators
      KEY_INDEX=$(( ({{ .validator_index }} * 10000) + $RID ))
      echo {{ .validator_index }} > /root/.celo/validator_index
      {{- else }}
      KEY_INDEX=$RID
      {{- end }}
      echo "Generating private key with KEY_INDEX=$KEY_INDEX"
      celotooljs.sh generate bip32 --mnemonic "$MNEMONIC" --accountType {{ .mnemonic_account_type }} --index $KEY_INDEX > /root/.celo/pkey
      echo "Private key $(cat /root/.celo/pkey)"
      echo 'Generating address'
      celotooljs.sh generate account-address --private-key $(cat /root/.celo/pkey) > /root/.celo/address
      {{- if .proxy }}
      # Generating the account address of the validator
      echo "Generating the account address of the validator {{ .validator_index }}"
      celotooljs.sh generate bip32 --mnemonic "$MNEMONIC" --accountType validator --index {{ .validator_index }} > /root/.celo/validator_pkey
      celotooljs.sh generate account-address --private-key `cat /root/.celo/validator_pkey` > /root/.celo/validator_address
      rm -f /root/.celo/validator_pkey
      {{- end }}
      echo -n "Generating IP address for node: "
      if [ -z $IP_ADDRESSES ]; then
        echo 'No $IP_ADDRESSES'
        # to use the IP address of a service from an env var that Kubernetes creates
        SERVICE_ENV_VAR_PREFIX={{ .service_ip_env_var_prefix }}
        if [ "$SERVICE_ENV_VAR_PREFIX" ]; then
          echo -n "Using ${SERVICE_ENV_VAR_PREFIX}${RID}_SERVICE_HOST:"
          SERVICE_IP_ADDR=`eval "echo \\${${SERVICE_ENV_VAR_PREFIX}${RID}_SERVICE_HOST}"`
          echo $SERVICE_IP_ADDR
          echo "$SERVICE_IP_ADDR" > /root/.celo/ipAddress
        else
          echo 'Using POD_IP'
          echo $POD_IP > /root/.celo/ipAddress
        fi
      else
        echo 'Using $IP_ADDRESSES'
        POD_IP_ADDRESS=$(echo $IP_ADDRESSES | cut -d '/' -f $((RID + 1)))
        if [ -z $POD_IP_ADDRESS ]; then
          echo 'Using Pod IP address'
          echo $(hostname -i) > /root/.celo/ipAddress
        else
          echo $POD_IP_ADDRESS > /root/.celo/ipAddress
        fi
      fi
      echo "/root/.celo/ipAddress"
      cat /root/.celo/ipAddress

      echo -n "Generating Bootnode enode address for node: "
      celotooljs.sh generate public-key --mnemonic "$MNEMONIC" --accountType bootnode --index 0 > /root/.celo/bootnodeEnodeAddress

      cat /root/.celo/bootnodeEnodeAddress
      [[ "$BOOTNODE_IP_ADDRESS" == 'none' ]] && BOOTNODE_IP_ADDRESS=${{ .Release.Namespace | upper }}_BOOTNODE_SERVICE_HOST

      echo "enode://$(cat /root/.celo/bootnodeEnodeAddress)@$BOOTNODE_IP_ADDRESS:30301" > /root/.celo/bootnodeEnode
      echo -n "Generating Bootnode enode for tx node: "
      cat /root/.celo/bootnodeEnode
  env:
  - name: POD_IP
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: status.podIP
  - name: BOOTNODE_IP_ADDRESS
    value: "{{ default .Values.bootnode.defaultClusterIP .Values.bootnode.ipAddress }}"
  - name: REPLICA_NAME
    valueFrom:
      fieldRef:
        fieldPath: metadata.name
  - name: MNEMONIC
    valueFrom:
      secretKeyRef:
        name: {{ template "common.fullname" . }}-geth-account
        key: mnemonic
  - name: IP_ADDRESSES
    value: {{ .ip_addresses }}
  volumeMounts:
  - name: data
    mountPath: /root/.celo
{{- end }}
