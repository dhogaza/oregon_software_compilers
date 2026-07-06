#!/bin/bash
# Check darwin output files against linux output files or
# vice-versa.
. ./env.sh

if [[ "$os" == "darwin" ]]; then
  other="linux"
else
  other="darwin"
fi

for f in $src/*.pas; do
  echo "--- testing $(basename $f) ---"
  . ./fileattrs.sh $f
  pushd $os >/dev/null
  if [[ "$type" == "pas" || "$type" == "nolib" ]]; then
    $pasdir/pas2arm64 $f --include=$lib --noch --mac=$base
    diff $base.s $base.s.good > $base.s.diff
    if [ -s "$base.s.diff" ]; then
      echo "$base.s is different than $base.s.good"
    fi
    if [[ "$type" == "pas" ]]; then
      gcc $HOME/oregon_software_compilers/lib/$os/paslib.o $base.s
    else
      gcc $base.s
    fi
    ./a.out > $base.out
    diff $base.out ../$other/$base.out.good >../$other/$base.out.diff
    if [ -s "../$other/$base.out.diff" ]; then
      echo "$base.out is different than ../$other/$base.out.good"
    fi
  elif [[ "$type" == "errors" ]]; then
    $pasdir/pas2arm64 $f --include=$lib >$base.out
    diff $base.out $base.out.good >$base.out.diff
    if [ -s "$base.out.diff" ]; then
      echo "$base.out is different than $f.out.good"
    fi
  fi
  popd >/dev/null
done
