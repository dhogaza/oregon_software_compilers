#!/bin/bash
echo "--- benchmarking $1 ---"
# remove fpc executable
rm -f $1
../pas2arm64 $1 --noch --mac
gcc $1.s
echo "timing pascal2 version..."
time ./a.out
fpc $1 -O3
echo "timing free pascal version ..."
time ./$1
