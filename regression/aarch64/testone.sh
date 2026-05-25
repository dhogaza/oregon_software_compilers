#!/bin/bash
. ./env.sh
pushd $os >/dev/null
echo "--- testing $1 ---"
$pasdir/pas2arm64 $src/$1 --include=$lib --noch --mac=$1
diff $1.s $1.s.good > $1.s.diff
if [ -s "$1.s.diff" ]; then
    echo "$1.s is different than $1.s.good"
fi
gcc $HOME/oregon_software_compilers/lib/$os/paslib.o $1.s
./a.out > $1.out
diff $1.out $1.out.good >$1.out.diff
if [ -s "$1.out.diff" ]; then
    echo "$1.out is different than $1.out.good"
fi
rm -f a.out *.tmp
popd >/dev/null
