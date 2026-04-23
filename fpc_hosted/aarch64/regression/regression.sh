#!/bin/bash
for f in *.pas; do
    echo "--- testing $f ---"
    f=${f%%.*}
    ../pas2arm64 $f --include=../test --noch --mac
    diff $f.s $f.s.good > $f.s.diff
    if [ -s "$f.s.diff" ]; then
      echo "$f.s is different than $f.s.good"
    fi
    gcc $f.s
    ./a.out > $f.out
    diff $f.out $f.out.good >$f.out.diff
    if [ -s "$f.out.diff" ]; then
      echo "$f.out is different than $f.out.good"
    fi
done
