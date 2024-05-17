#!/usr/bin/env sh
set -e

datadir=/data
if [ ! -f $datadir/.initialized ]; then
    wget -qO $datadir/rollup.json "{{ .Values.init.rollup.url }}"
    touch $datadir/.initialized
    echo "Successfully downloaded rollup file"
else
    echo "Already downloaded, skipping."
fi
