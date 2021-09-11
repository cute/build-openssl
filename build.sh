#!/usr/bin/env bash

# curl -O https://www.openssl.org/source/openssl-1.1.1k.tar.gz
# tar xf openssl-1.1.1k.tar.gz
cd openssl-1.1.1k-quic
../build_openssl_dist.sh ios
../build_openssl_dist.sh osx
# rm ../openssl-1.1.1k.tar.gz
