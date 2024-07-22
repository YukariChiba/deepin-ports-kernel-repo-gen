#!/bin/bash

REPO=deepin-community/deepin-riscv-kernel

mkdir -p tmp

pushd tmp

ENDP=https://api.github.com/repos/$REPO/actions/artifacts

WFID=`curl $ENDP | jq -c '.artifacts | first | .workflow_run | .id'`

for device in mango star64 th1520 unmatched visionfive2-61y visionfive2 visionfive2-upstream; do
  wget https://nightly.link/$REPO/actions/runs/$WFID/kernel-$device-deb.zip
  unzip ./kernel-$device-deb.zip
done

popd

reprepro -b repo/ -C ports-kernel includedeb beige tmp/*.deb

rm -r tmp

rsync -atrvzlu -e 'ssh -p 2222' repo/ deepin@10.20.64.70:/storage/repos/deepin-ports/v23-addons --delete
