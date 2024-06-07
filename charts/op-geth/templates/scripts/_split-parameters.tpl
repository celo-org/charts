#!/usr/bin/env sh

# Get Replica ID from hostname
RID=$(echo $HOSTNAME | sed 's/{{ .Release.Name }}-//')
datadir="{{ .Values.persistence.mountPath | default .Values.config.datadir }}"
# Split the jwt keys based on the comma and get the $RID-th key
cat /secrets/jwt.hex | tr ',' '\n' | sed -n "$((RID + 1))p" | tr -d '\n' > "$datadir/jwt.hex"
# If the jwt is not defined for this index, use the first jwt key
if [ ! -s "$datadir/jwt.hex" ]; then
  cat /secrets/jwt.hex | tr ',' '\n' | head -n 1 | tr -d '\n' > "$datadir/jwt.hex"
fi

# Saving the announce ip address to a file
loadBalancerIps="{{ join "," .Values.services.p2p.loadBalancerIPs }}"
clusterIps="{{ join "," .Values.services.p2p.clusterIPs }}"
# If the loadBalancerIPs are defined, use them
if [ -n "$loadBalancerIps" ]; then
  loadBalancerIp=$(echo "$loadBalancerIps" | tr ',' '\n' | sed -n "$((RID + 1))p")
  echo "$loadBalancerIp" > "$datadir/announce_ip"
# If the clusterIPs are defined now, use them
elif [ -n "$clusterIps" ]; then
  clusterIp=$(echo "$clusterIps" | tr ',' '\n' | sed -n "$((RID + 1))p")
  echo "$clusterIp" > "$datadir/announce_ip"
# If none of the above are defined, use the hostname
else
  echo $(hostname -i) > "$datadir/announce_ip"
fi
