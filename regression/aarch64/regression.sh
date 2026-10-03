#!/bin/bash
. ./env.sh
libdir="$HOME/oregon_software_compilers/lib/$os"
for f in $src/*.pas; do
  echo "--- testing $(basename $f) ---"
  . ./fileattrs.sh $f
  pushd $os >/dev/null
  if [[ "$type" == "pas" || "$type" == "nolib" || "$type" == "check" ]]; then
    if [[ "$type" == "check" ]]; then
      $pasdir/pas2arm64 $f --include=$lib --mac=$base $1 $2
    else
      $pasdir/pas2arm64 $f --include=$lib --noch --mac=$base $1 $2
    fi
    diff $base.s $base.s.good > $base.s.diff
    if [ -s "$base.s.diff" ]; then
      echo "$base.s is different than $base.s.good"
    fi
    if [[ "$type" == "pas" || "$type" == "check" ]]; then
      gcc $libdir/libpaslib.a $base.s
    else
      gcc $libdir/stdfiles.o $base.s
    fi
    stdbuf -o0 ./a.out &> $base.out
    diff $base.out $base.out.good >$base.out.diff
    if [ -s "$base.out.diff" ]; then
      echo "$base.out is different than $base.out.good"
    fi
  elif [[ "$type" == "errors" ]]; then
    $pasdir/pas2arm64 $f --include=$lib >$base.out
    diff $base.out $base.out.good >$base.out.diff
    if [ -s "$base.out.diff" ]; then
      echo "$base.out is different than $base.out.good"
    fi
  fi
  rm -f *.tmp a.out
  popd >/dev/null
done
