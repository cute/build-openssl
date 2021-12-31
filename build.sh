#!/usr/bin/env bash

#git clone https://github.com/quictls/openssl --branch OpenSSL_1_1_1m+quic openssl-1.1.1m-quic --depth 1
cd openssl-1.1.1m-quic
gco -- .
../build_openssl_dist.sh ios
../build_openssl_dist.sh osx

