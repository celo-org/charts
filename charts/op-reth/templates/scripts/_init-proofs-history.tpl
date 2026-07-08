#!/usr/bin/env sh
set -e

datadir="{{ .Values.persistence.mountPath | default .Values.config.datadir }}"
storagePath="{{ .Values.proofsHistory.storagePath | default (printf "%s/proofs-history" .Values.config.datadir) }}"
minSyncedBlock={{ .Values.proofsHistory.minSyncedBlock | int64 }}
nodeMode="{{ include "op-reth.nodeMode" . }}"

# "proofs init" anchors the proofs store at the node's CURRENT canonical head and only fills
# FORWARD from there; it never backfills. If the anchor lands behind the live network tip, the
# ExEx must catch up by re-executing the skipped blocks:
#   * archive nodes retain all history, so catch-up (and "proofs backfill") works -> anchoring at
#     a local/snapshot head behind the tip is safe.
#   * full/minimal (pruned) nodes prune historical state beyond the prune distance, so a gap
#     between the anchor and the live tip is UNRECOVERABLE: catch-up fails (NonceTooLow) and the
#     proof window freezes at the anchor forever.
# This init container runs BEFORE the node, so it cannot observe whether the datadir is actually
# caught up to the live NETWORK tip (a snapshot restore leaves it hundreds of thousands of blocks
# behind). We therefore refuse to auto-anchor a pruned node: it runs WITHOUT --proofs-history until
# an operator confirms the node is fully synced and sets "proofsHistory.init.initAtCurrentHead=true"
# (then restarts), at which point the store is anchored at the now-current head.
if [ ! -f "$datadir/.proofs-initialized" ] && { [ "$nodeMode" = "full" ] || [ "$nodeMode" = "minimal" ]; } && [ "{{ .Values.proofsHistory.init.initAtCurrentHead }}" != "true" ]; then
  echo "proofs-history: pruned node ($nodeMode) not auto-initialized to avoid anchoring the proof window behind the live tip (pruned nodes cannot backfill the gap)."
  echo "proofs-history: sync the node fully to the live tip, then set 'proofsHistory.init.initAtCurrentHead=true' and restart. (Archive nodes bootstrap hands-off.)"
  rm -f "$datadir/.proofs-initialized"
  exit 0
fi

# Highest block present in the headers static files (reth names them
# "static_file_headers_<start>_<end>"). Cheap "is the node synced?" probe that avoids
# starting the node: "proofs init" anchors the store at the chain tip, so initializing while
# the node is still doing its initial sync would anchor the store far behind the network.
headBlock=0
if [ -d "$datadir/static_files" ]; then
  for f in "$datadir"/static_files/static_file_headers_*; do
    [ -e "$f" ] || continue
    end=$(basename "$f" | cut -d_ -f5 | sed 's/[^0-9].*$//')
    case "$end" in
      ''|*[!0-9]*) continue ;;
    esac
    if [ "$end" -gt "$headBlock" ]; then headBlock="$end"; fi
  done
fi

if [ "$headBlock" -lt "$minSyncedBlock" ]; then
  echo "proofs-history: head block $headBlock < minSyncedBlock $minSyncedBlock; skipping init (node not synced)."
  # Drop the marker so the node container launches WITHOUT --proofs-history until a later
  # restart finds the node synced past minSyncedBlock and initializes the store.
  rm -f "$datadir/.proofs-initialized"
  exit 0
fi

echo "proofs-history: initializing store at $storagePath (head block $headBlock)..."
# Idempotent: "proofs init" anchors the store at the current chain tip and is a no-op once
# initialized, so this is safe to re-run on every pod restart.
celo-reth proofs init \
  --datadir={{ .Values.config.datadir }} \
{{- if .Values.config.chain }}
  --chain={{ .Values.config.chain }} \
{{- else }}
  --chain=$datadir/genesis.json \
{{- end }}
  --proofs-history.storage-path="$storagePath" \
  --proofs-history.storage-version={{ .Values.proofsHistory.storageVersion }}

touch "$datadir/.proofs-initialized"
echo "proofs-history: store initialized."
