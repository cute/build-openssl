#!/usr/bin/env bash

curl -O https://www.openssl.org/source/openssl-1.1.1i.tar.gz
tar xf openssl-1.1.1i.tar.gz
cd openssl-1.1.1i
../build_openssl_dist.sh ios
../build_openssl_dist.sh osx
rm openssl-1.1.1i.tar.gz
