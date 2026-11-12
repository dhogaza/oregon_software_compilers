#!/bin/bash
. ./env.sh
libdir="$HOME/oregon_software_compilers/lib/$os"
echo "--- testing $1 ---"
. ./fileattrs.sh $1
pushd m68k >/dev/null
if [[ "$type" == "pas" || "$type" == "nolib" || "$type" == "check" ]]; then
  if [[ "$type" == "check" ]]; then
    $pas68dir/pas2m68k $src/$1 --include=$lib --mac=$1 $2 $3
  else
    $pas68dir/pas2m68k $src/$1 --include=$lib --noch --mac=$1 $2 $3
  fi
  diff $1.sa $1.sa.good > $1.sa.diff
  if [ -s "$1.sa.diff" ]; then
      echo "$1.sa is different than $1.sa.good"
  fi
fi
rm -f *.tmp
popd >/dev/null
