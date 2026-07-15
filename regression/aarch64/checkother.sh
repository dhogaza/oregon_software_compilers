#!/bin/bash
# Check darwin output files against linux output files or
# vice-versa.
. ./env.sh
libdir="$HOME/oregon_software_compilers/lib/$os"
if [[ "$os" == "darwin" ]]; then
  other="linux"
else
  other="darwin"
fi

# yes, other not $other
if [ ! -d "other" ]; then
  mkdir other
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
      gcc $libdir/stdfiles.o $libdir/paslib.o $base.s
    else
      gcc $libdir/stdfiles.o $base.s
    fi
    ./a.out &> ../other/$base.out
    diff ../other/$base.out ../$other/$base.out.good >../other/$base.out.diff
    if [ -s "../other/$base.out.diff" ]; then
      echo "$base.out is different than ../$other/$base.out.good"
    fi
  elif [[ "$type" == "errors" ]]; then
    $pasdir/pas2arm64 $f --include=$lib >../other/$base.out
    diff ../other/$base.out ../$other/$base.out.good >../other/$base.out.diff
    if [ -s "../other/$base.out.diff" ]; then
      echo "$base.out is different than $base.out.good"
    fi
  fi
  rm -f *.tmp a.out
  popd >/dev/null
done
