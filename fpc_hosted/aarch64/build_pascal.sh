#!/bin/bash
fpc -gl -opas2arm64 -FE. -Fu../pascal -Fu../common -Fu../aarch64  ../pascal/main
fpc -gl -oad -FE. -Fu../pascal -Fu../common -Fu../aarch64  ../common/ad
