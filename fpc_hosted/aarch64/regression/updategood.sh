#!/bin/bash
for f in *.pas; do
    echo "--- updating $f good files ---"
    f=${f%%.*}
    cp $f.s $f.s.good
    cp $f.out $f.out.good
done
