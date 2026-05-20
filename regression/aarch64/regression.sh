#!/bin/bash
. ./env.sh
pushd $os >/dev/null
for f in $src/*.pas; do
    echo "--- testing $(basename $f) ---"
    f=${f%%.*}
    base=$(basename $f)
    $pasdir/pas2arm64 $f --include=$lib --noch --mac=$base
    diff $base.s $base.s.good > $base.s.diff
    if [ -s "$base.s.diff" ]; then
      echo "$base.s is different than $base.s.good"
    fi
    gcc $base.s
    ./a.out > $base.out
    diff $base.out $base.out.good >$base.out.diff
    if [ -s "$base.out.diff" ]; then
      echo "$base.out is different than $base.out.good"
    fi
done
popd >/dev/null
