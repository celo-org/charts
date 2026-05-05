#!/usr/bin/env sh

# Get Replica ID from hostname
RID=$(echo $HOSTNAME | sed 's/{{ .Release.Name }}-//')
datadir="{{ .Values.persistence.mountPath | default .Values.config.rollup.config }}"

# Split the jwt keys based on the comma and get the $RID-th key
echo $JWT_SECRET | tr ',' '\n' | sed -n "$((RID + 1))p" | tr -d '\n' > "$datadir/jwt.hex"
# If the jwt is not defined for this index, use the first jwt key
if [ ! -s "$datadir/jwt.hex" ]; then
  cat $JWT_SECRET | tr ',' '\n' | head -n 1 | tr -d '\n' > "$datadir/jwt.hex"
fi

# Split the p2p keys based on the comma and get the $RID-th key
echo $P2P_KEYS | tr ',' '\n' | sed -n "$((RID + 1))p" | tr -d '\n' | sed 's/^0x//' > "$datadir/opnode_p2p_priv.txt"
# If the p2p is not defined for this index, fail
if [ ! -s "$datadir/opnode_p2p_priv.txt" ]; then
  echo "P2P key not found for replica $RID"
  exit 1
fi

# Save sequencer private key to a file in datadir
if [ -f /secrets/sequencer.hex ]; then
  cp -rp /secrets/sequencer.hex "$datadir/sequencer.hex"
fi

# Split the advertised addresses based on the comma and get the $RID-th key
loadBalancerIps="{{ join "," .Values.services.p2p.loadBalancerIPs }}"
clusterIps="{{ join "," .Values.services.p2p.clusterIPs }}"
# If the loadBalancerIPs are defined, use them
if [ -n "$loadBalancerIps" ]; then
  advertiseIp=$(echo "$loadBalancerIps" | tr ',' '\n' | sed -n "$((RID + 1))p")
# If the clusterIPs are defined now, use them
elif [ -n "$clusterIps" ]; then
  advertiseIp=$(echo "$clusterIps" | tr ',' '\n' | sed -n "$((RID + 1))p")
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

# Get the L2 url
l2Url=""
if [ -n "{{ .Values.config.l2.url }}" ]; then
  l2Url="{{ tpl .Values.config.l2.url . }}"
else
  l2Url="{{ .Values.config.l2.protocol }}://{{ .Values.config.l2.namePattern }}-$RID:{{ .Values.config.l2.port }}"
fi
echo "Setting L2 url to $l2Url"
echo "$l2Url" > "$datadir/l2Url"


# Get the conductor url
conductorRpcUrl=""
if [ -n "{{ .Values.config.conductor.rpc.url }}" ]; then
  conductorRpcUrl="{{ .Values.config.conductor.rpc.url }}"
else
  conductorRpcUrl="{{ .Values.config.conductor.rpc.protocol }}://{{ .Values.config.conductor.rpc.namePattern }}-$RID:{{ .Values.config.conductor.rpc.port }}"
fi
echo "Setting conductor url to $conductorRpcUrl"
echo "$conductorRpcUrl" > "$datadir/conductorRpcUrl"
