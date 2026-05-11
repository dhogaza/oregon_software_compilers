#!/bin/bash
echo "--- benchmarking $1 ---"
# remove fpc executable
../pas2arm64 $1 --noch --mac
gcc $1.s
echo "timing pascal2 version..."
time ./a.out
fpc $1 -O3
echo "timing free pascal version ..."
time ./$1
rm $1
