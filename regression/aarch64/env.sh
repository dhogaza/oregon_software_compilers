#!/bin/bash
os=`uname`
os=${os,,}
arch=`uname -m`
if [[ "$arch" == "arm64" ]]; then
  arch="aarch64"
fi
if [[ "$arch" != "aarch64" ]]; then
  echo "Not an aarch64 machine"
  exit
fi
src="$HOME/oregon_software_compilers/regression/src"
lib="$HOME/oregon_software_compilers/lib/$os"
pasdir="$HOME/oregon_software_compilers/fpc_hosted/aarch64"
if [ ! -d "$os" ]; then
  mkdir $os
fi
