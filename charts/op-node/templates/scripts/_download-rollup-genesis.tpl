#!/usr/bin/env sh
set -e

datadir="{{ .Values.persistence.mountPath | default .Values.config.rollup.config }}"
if [ ! -f $datadir/.initialized ]; then
    wget -qO $datadir/genesis.json "{{ .Values.init.genesis.url }}"
    wget -qO $datadir/rollup.json "{{ .Values.init.rollup.url }}"
    touch $datadir/.initialized
    echo "Successfully downloaded genesis and rollup files"
else
    echo "Already downloaded, skipping."
fi
