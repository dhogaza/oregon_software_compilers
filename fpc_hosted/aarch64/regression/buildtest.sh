#!/bin/bash
# Assumes pascal test is known to work so creates .s.good and
# .out.good
echo "--- building $1.pas test output"
../pas2arm64 $1 --include=../test --noch --mac
gcc $1.s
mv $1.s $1.s.good
./a.out > $1.out
mv $1.out $1.out.good
