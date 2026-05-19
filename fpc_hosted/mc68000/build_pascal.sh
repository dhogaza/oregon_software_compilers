#!/bin/bash
cd ~/oregon_software_compilers/fpc_hosted/mc68000
fpc -gl -opas2m68k -FE. -Fu../pascal -Fu../common -Fu../mc68000  ../pascal/main
