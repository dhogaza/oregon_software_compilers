#!/bin/bash
os=`uname`
os="$(echo $os | tr '[A-Z]' '[a-z]')"
pas2arm64 paslib --mac --noch
gcc $os/stdfiles.c -o $os/stdfiles.o -c
gcc heapalloc.c -o $os/heapalloc.o -c
as paslib.s -o $os/paslib.o
ar -rcs $os/libpaslib.a $os/stdfiles.o $os/heapalloc.o $os/paslib.o
