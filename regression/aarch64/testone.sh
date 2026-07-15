#!/bin/bash
. ./env.sh
libdir="$HOME/oregon_software_compilers/lib/$os"
echo "--- testing $1 ---"
. ./fileattrs.sh $1
pushd $os >/dev/null
if [[ "$type" == "pas" || "$type" == "nolib" ]]; then
  $pasdir/pas2arm64 $src/$1 --include=$lib --noch --mac=$1
  diff $1.s $1.s.good > $1.s.diff
  if [ -s "$1.s.diff" ]; then
      echo "$1.s is different than $1.s.good"
  fi
    if [[ "$type" == "pas" ]]; then
      gcc $libdir/stdfiles.o $libdir/paslib.o $base.s
    else
      gcc $libdir/stdfiles.o $base.s
  fi
  ./a.out &> $1.out
  diff $1.out $1.out.good >$1.out.diff
  if [ -s "$1.out.diff" ]; then
      echo "$1.out is different than $1.out.good"
  fi
elif [[ "$type" == "errors" ]]; then
  $pasdir/pas2arm64 $src/$1 --include=$lib >$1.out
  diff $1.out $1.out.good >$1.out.diff
  if [ -s "$1.out.diff" ]; then
      echo "$1.out is different than $1.out.good"
  fi
rm -f a.out *.tmp
popd >/dev/null
fi
