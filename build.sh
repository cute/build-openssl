#!/usr/bin/env bash

#git clone https://github.com/quictls/openssl --branch OpenSSL_1_1_1p+quic openssl-1.1.1p-quic --depth 1
cd openssl-1.1.1p-quic
gco -- .
../build_openssl_dist.sh ios
../build_openssl_dist.sh osx

