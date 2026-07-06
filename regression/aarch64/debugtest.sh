#!/bin/bash
echo "testing --mac --noch --test compile only"
. ./env.sh
for f in $src/*.pas; do
  echo "--- testing $(basename $f) ---"
  . ./fileattrs.sh $f
  pushd $os >/dev/null
  if [[ "$type" == "pas" || "$type" == "nolib" ]]; then
    $pasdir/pas2arm64 $f --include=$lib --noch --mac=$base --test
  fi
  rm a.out *.tmp
  popd >/dev/null
done
