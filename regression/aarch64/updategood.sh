#!/bin/bash
. ./env.sh
pushd $os >/dev/null
for f in $src/*.pas; do
    echo "--- updating $(basename $f) good files ---"
    f=${f%%.*}
    base=$(basename $f)
    cp $base.s $base.s.good
    cp $base.out $base.out.good
done
popd >/dev/null
