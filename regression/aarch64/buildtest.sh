#!/bin/bash
# Assumes pascal test is known to work so creates .s.good and
# .out.good
. ./env.sh
libdir="$HOME/oregon_software_compilers/lib/$os"
echo "--- building $1 good files ---"
. ./fileattrs.sh $1
pushd $os >/dev/null
if [[ "$type" == "pas" || "$type" == "nolib" ]]; then
  $pasdir/pas2arm64 $src/$1 --include=$lib --noch --mac=$1
  if [ $? == 0 ]; then
    if [[ "$type" == "pas" ]]; then
      gcc $libdir/stdfiles.o $libdir/paslib.o $base.s
    else
      gcc $libdir/stdfiles.o $base.s
    fi
    mv $1.s $1.s.good
    ./a.out &> $1.out.good
  else
    echo "*** compilation error detected ***"
  fi
elif [[ "$type" == "errors" ]]; then
  $pasdir/pas2arm64 $src/$1 --include=$lib >$1.out
  if [ $? == 0 ]; then
    echo "*** no compilation error detected ***" 
  fi
  mv $1.out $1.out.good
fi
rm -f a.out *.tmp
popd >/dev/null
