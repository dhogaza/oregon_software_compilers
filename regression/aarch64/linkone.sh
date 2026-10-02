#!/bin/bash
. ./env.sh
libdir="$HOME/oregon_software_compilers/lib/$os"
echo "--- assembling/linking/testing $1 ---"
. ./fileattrs.sh $1
pushd $os >/dev/null
gcc $libdir/stdfiles.o $libdir/paslib.o $base.s
stdbuf -o0 ./a.out > $1.out 2>&1
diff $1.out $1.out.good >$1.out.diff
if [ -s "$1.out.diff" ]; then
   echo "$1.out is different than $1.out.good"
fi
popd >/dev/null
