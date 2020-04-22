#!/usr/bin/env bash

curl -O https://www.openssl.org/source/openssl-1.1.1g.tar.gz
tar xf openssl-1.1.1g.tar.gz
cd openssl-1.1.1g
../build_openssl_dist.sh ios
../build_openssl_dist.sh osx
cd - && rm openssl-1.1.1g.tar.gz
