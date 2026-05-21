#!/bin/bash
. ./env.sh
pushd $os >/dev/null
for f in $src/*.pas; do
    echo "--- updating $(basename $f) good files ---"
    f=${f%%.*}
    base=$(basename $f)
    if [ -s "$base.out.diff" ]; then
      echo "making $base.out good"
      cp $base.out $base.out.good
    fi
    if [ -s "$base.s.diff" ]; then
      echo "making $base.s good"
      cp $base.s $base.s.good
    fi
done
popd >/dev/null
