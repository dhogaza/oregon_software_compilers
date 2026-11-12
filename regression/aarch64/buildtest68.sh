#!/bin/bash
# Assumes pascal test is known to work so creates .s.good and
# .out.good
. ./env.sh
echo "--- building $1 good files ---"
. ./fileattrs.sh $1
pushd m68k >/dev/null
if [[ "$type" == "pas" || "$type" == "nolib" || "$type" == "check" ]]; then
  if [[ "$type" == "check" ]]; then
    $pas68dir/pas2m68k $src/$1 --include=$lib --mac=$1
  else
    $pas68dir/pas2m68k $src/$1 --include=$lib --noch --mac=$1
  fi
  if [ $? == 0 ]; then
    mv $1.sa $1.sa.good
  else
    echo "*** compilation error detected ***"
  fi
elif [[ "$type" == "errors" ]]; then
  $pas68dir/pas2m68k $src/$1 --include=$lib >$1.out
  if [ $? == 0 ]; then
    echo "*** no compilation error detected ***" 
  fi
  mv $1.out $1.out.good
fi
rm -f *.tmp
popd >/dev/null
