#!/usr/bin/env bash

curl -O https://www.openssl.org/source/openssl-1.1.1d.tar.gz
tar xf openssl-1.1.1d.tar.gz
cd openssl-1.1.1d
../build_openssl_dist.sh ios
../build_openssl_dist.sh osx
rm openssl-1.1.1d.tar.gz
