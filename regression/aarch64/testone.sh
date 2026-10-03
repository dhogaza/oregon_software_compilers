#!/bin/bash
. ./env.sh
libdir="$HOME/oregon_software_compilers/lib/$os"
echo "--- testing $1 ---"
. ./fileattrs.sh $1
pushd $os >/dev/null
if [[ "$type" == "pas" || "$type" == "nolib" || "$type" == "check" ]]; then
  if [[ "$type" == "check" ]]; then
    $pasdir/pas2arm64 $src/$1 --include=$lib --mac=$1 $2 $3
  else
    $pasdir/pas2arm64 $src/$1 --include=$lib --noch --mac=$1 $2 $3
  fi
  diff $1.s $1.s.good > $1.s.diff
  if [ -s "$1.s.diff" ]; then
      echo "$1.s is different than $1.s.good"
  fi
  if [[ "$type" == "pas" || "$type" == "check" ]]; then
    gcc $libdir/libpaslib.a $base.s
  else
    gcc $libdir/stdfiles.o $base.s
  fi
  stdbuf -o0 ./a.out &> $1.out
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
fi
rm -f a.out *.tmp
popd >/dev/null
