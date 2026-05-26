#!/bin/bash
# Assumes pascal test is known to work so creates .s.good and
# .out.good
. ./env.sh
pushd $os >/dev/null
echo "--- building $1 good files ---"
$pasdir/pas2arm64 $src/$1 --include=$lib --noch --mac=$1
gcc $HOME/oregon_software_compilers/lib/$os/paslib.o $1.s
mv $1.s $1.s.good
./a.out > $1.out
mv $1.out $1.out.good
rm -f a.out *.tmp
popd >/dev/null
