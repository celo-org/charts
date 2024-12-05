#!/usr/bin/env sh

# Get Replica ID from hostname
RID=$(echo $HOSTNAME | sed 's/{{ .Release.Name }}-//')
datadir="{{ .Values.persistence.mountPath }}"

# Split the advertised addresses based on the comma and get the $RID-th key
loadBalancerIps="{{ join "," .Values.services.consensus.loadBalancerIPs }}"
clusterIps="{{ join "," .Values.services.consensus.clusterIPs }}"
# If the loadBalancerIPs are defined, use them
if [ -n "$loadBalancerIps" ]; then
  advertiseIp=$(echo "$loadBalancerIps" | tr ',' '\n' | sed -n "$((RID + 1))p")
# If the clusterIPs are defined now, use them
elif [ -n "$clusterIps" ]; then
  advertiseIp=$(echo "{{ include "op-conductor.fullname" $ }}-consensus-$((RID))")
# If none of the above are defined, use pod's ip
else
  advertiseIp="$(hostname -i)"
fi
if [ -z "$advertiseIp" ]; then
  echo "Could not determine advertise address"
  exit 1
fi
echo "Setting advertise address to $advertiseIp"
echo "$advertiseIp" > "$datadir/advertiseIP"

# Get the execution url
executionUrl=""
if [ -n "{{ .Values.config.execution.url }}" ]; then
  executionUrl="{{ .Values.config.execution.url }}"
else
  executionUrl="{{ .Values.config.execution.protocol }}://{{ .Values.config.execution.namePattern }}-$RID:{{ .Values.config.execution.port }}"
fi
echo "Setting execution url to $executionUrl"
echo "$executionUrl" > "$datadir/executionUrl"

# Get the node url
nodeUrl=""
if [ -n "{{ .Values.config.node.url }}" ]; then
  nodeUrl="{{ .Values.config.node.url }}"
else
  nodeUrl="{{ .Values.config.node.protocol }}://{{ .Values.config.node.namePattern }}-$RID:{{ .Values.config.node.port }}"
fi
echo "Setting execution url to $nodeUrl"
echo "$nodeUrl" > "$datadir/nodeUrl"
