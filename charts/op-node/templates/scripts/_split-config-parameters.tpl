#!/usr/bin/env sh

# Get Replica ID from hostname
RID=$(echo $HOSTNAME | sed 's/{{ .Release.Name }}-//')
datadir="{{ .Values.persistence.mountPath | default .Values.config.rollup.config }}"

# Split the jwt keys based on the comma and get the $RID-th key
cat /secrets/jwt.hex | tr ',' '\n' | sed -n "$((RID + 1))p" | tr -d '\n' > "$datadir/jwt.hex"
# If the jwt is not defined for this index, use the first jwt key
if [ ! -s "$datadir/jwt.hex" ]; then
  cat /secrets/jwt.hex | tr ',' '\n' | head -n 1 | tr -d '\n' > "$datadir/jwt.hex"
fi

# Split the p2p keys based on the comma and get the $RID-th key
cat /secrets/p2p.hex | tr ',' '\n' | sed -n "$((RID + 1))p" | tr -d '\n' > "$datadir/opnode_p2p_priv.txt"
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
advertiseIp=$(echo "{{ .Values.config.p2p.advertiseIP }}" | tr ',' '\n' | sed -n "$((RID + 1))p" | tr -d '\n')
# Check if not empty
if [ -n "$advertiseIp" ]; then
  echo "Setting advertise address to $advertiseIp"
  echo "$advertiseIp" > "$datadir/advertiseIP"
fi

# Get the L2 url
l2Url=""
if [ -n "{{ .Values.config.l2.url }}" ]; then
  l2Url="{{ .Values.config.l2.url }}"
else
  l2Url="{{ .Values.config.l2.protocol }}://{{ .Values.config.l2.namePattern }}-$RID:{{ .Values.config.l2.port }}"
fi
echo "Setting L2 url to $l2Url"
echo "$l2Url" > "$datadir/l2Url"
