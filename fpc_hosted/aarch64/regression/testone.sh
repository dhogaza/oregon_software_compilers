#!/bin/bash
echo "--- testing $1 ---"
../pas2arm64 $1 --include=../test --noch --mac
diff $1.s $1.s.good > $1.s.diff
if [ -s "$1.s.diff" ]; then
    echo "$1.s is different than $1.s.good"
fi
gcc $1.s
./a.out > $1.out
diff $1.out $1.out.good >$1.out.diff
if [ -s "$1.out.diff" ]; then
    echo "$1.out is different than $1.out.good"
fi
