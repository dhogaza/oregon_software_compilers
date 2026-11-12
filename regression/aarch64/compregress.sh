#!/bin/bash
. ./env.sh
libdir="$HOME/oregon_software_compilers/lib/$os"
for f in $src/*.pas; do
  echo "--- testing $(basename $f) ---"
  . ./fileattrs.sh $f
  pushd $os >/dev/null
  if [[ "$type" == "pas" || "$type" == "nolib" || "$type" == "check" ]]; then
    if [[ "$type" == "check" ]]; then
      $pasdir/pas2arm64 $f --include=$lib --mac=$base $1 $2
    else
      $pasdir/pas2arm64 $f --include=$lib --noch --mac=$base $1 $2
    fi
    diff $base.s $base.s.good > $base.s.diff
    if [ -s "$base.s.diff" ]; then
      echo "$base.s is different than $base.s.good"
    fi
  fi
  rm -f *.tmp a.out
  popd >/dev/null
done
