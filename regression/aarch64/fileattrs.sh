#!/bin/bash
ext=${1#*.}
if [[ $1 == "$ext" ]]; then
  type="pas"
else
  type=${ext%.*}
fi
f=${1%%.pas}
base=$(basename $f)
