#!/bin/bash
echo "testing --mac --noch --test compile only"
. ./env.sh
for f in $src/*.pas; do
  echo "--- testing $(basename $f) ---"
  . ./fileattrs.sh $f
  pushd $os >/dev/null
  if [[ "$type" == "pas" || "$type" == "nolib" || "$type" == "check" ]]; then
    if [[ "$type" == "check" ]]; then
      $pasdir/pas2arm64 $f --include=$lib --mac=$base --test
    else
      $pasdir/pas2arm64 $f --include=$lib --noch --mac=$base --test
    fi
  fi
  rm -f *.tmp
  popd >/dev/null
done
