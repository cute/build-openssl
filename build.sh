#!/usr/bin/env bash

#git clone https://github.com/quictls/openssl --branch OpenSSL_1_1_1n+quic openssl-1.1.1n-quic --depth 1
cd openssl-1.1.1n-quic
gco -- .
../build_openssl_dist.sh ios
../build_openssl_dist.sh osx

