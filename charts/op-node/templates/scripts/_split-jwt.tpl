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

# Split the advertised addresses based on the comma and get the $RID-th key
advertiseIp=$(echo "{{ .Values.config.p2p.advertiseIP }}" | tr ',' '\n' | sed -n "$((RID + 1))p" | tr -d '\n')
# Check if not empty
if [ -n "$advertiseIp" ]; then
  echo "Setting advertise address to $advertiseIp"
  echo "$advertiseIp" > "$datadir/advertiseIP"
fi
