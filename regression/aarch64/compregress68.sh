#!/bin/bash
. ./env.sh
for f in $src/*.pas; do
  echo "--- testing $(basename $f) ---"
  . ./fileattrs.sh $f
  pushd m68k >/dev/null
  if [[ "$type" == "pas" || "$type" == "nolib" || "$type" == "check" ]]; then
    if [[ "$type" == "check" ]]; then
      $pas68dir/pas2m68k $f --include=$lib --mac=$base $1 $2
    else
      $pasdir/pas2m68k $f --include=$lib --noch --mac=$base $1 $2
    fi
    diff $base.sa $base.sa.good > $base.sa.diff
    if [ -s "$base.s.diff" ]; then
      echo "$base.sa is different than $base.sa.good"
    fi
  fi
  rm -f *.tmp
  popd >/dev/null
done
