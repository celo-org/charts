#!/usr/bin/env sh
set -e

datadir="{{ .Values.persistence.mountPath }}"
if [ ! -f $datadir/.initialized ]; then
    wget -qO $datadir/rollup.json "{{ .Values.init.rollup.url }}"
    touch $datadir/.initialized
    echo "Successfully downloaded rollup files"
else
    echo "Already downloaded, skipping."
fi
