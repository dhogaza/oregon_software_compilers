#!/bin/bash
. ./env.sh
. ./fileattrs.sh $1
libdir="$HOME/oregon_software_compilers/lib/$os"
if [[ "$type" != "pas" ]]; then
  echo "can only benchmark pascal programs the use paslib or the fpc lib"
  exit 1
fi
if [ ! -d "$os" ]; then
  mkdir $os
fi
pushd $os >/dev/null
echo "--- benchmarking $1 ---"
$pasdir/pas2arm64 $src/$1 --include=$lib --noch --mac=$1
gcc $libdir/stdfiles.o $libdir/paslib.o $1.s
echo "timing pascal2 version..."
time ./a.out
fpc $src/$1 -FU./ -o./a.out -O3 -Mdelphi
echo "timing free pascal version ..."
time ./a.out
rm -f a.out *.tmp
popd >/dev/null
