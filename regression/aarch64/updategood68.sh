#!/bin/bash
. ./env.sh
for f in $src/*.pas; do
    . ./fileattrs.sh $f
    echo "--- updating $base good files ---"
    pushd m68k >/dev/null
    if [ -s "$base.out.diff" ]; then
      echo "making $base.out good"
      cp $base.out $base.out.good
    fi
    if [ -s "$base.sa.diff" ]; then
      echo "making $base.s good"
      cp $base.sa $base.sa.good
    fi
    popd >/dev/null
done
