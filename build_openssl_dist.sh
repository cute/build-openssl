#!/bin/bash

set -x

BUILD_PLATFORM=$1
DFT_DIST_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
TMP_DIR=$DFT_DIST_DIR/build/${BUILD_PLATFORM}

CROSS_TOP_SIM="`xcode-select --print-path`/Platforms/iPhoneSimulator.platform/Developer"
CROSS_SDK_SIM="iPhoneSimulator.sdk"

CROSS_TOP_IOS="`xcode-select --print-path`/Platforms/iPhoneOS.platform/Developer"
CROSS_SDK_IOS="iPhoneOS.sdk"

CROSS_TOP_OSX="`xcode-select --print-path`/Platforms/MacOSX.platform/Developer"
CROSS_SDK_OSX="MacOSX.sdk"

export CROSS_COMPILE=`xcode-select --print-path`/Toolchains/XcodeDefault.xctoolchain/usr/bin/

function build_osx_for ()
{
  PLATFORM=$1
  ARCH=$2
  CROSS_TOP_ENV=CROSS_TOP_$3
  CROSS_SDK_ENV=CROSS_SDK_$3

  make clean

  export CROSS_TOP="${!CROSS_TOP_ENV}"
  export CROSS_SDK="${!CROSS_SDK_ENV}"

  ./Configure $PLATFORM "-arch $ARCH -fembed-bitcode -isysroot \$(CROSS_TOP)/SDKs/\$(CROSS_SDK)" no-shared no-async --prefix=${TMP_DIR}/${ARCH} || exit 1
  # problem of concurrent build; make -j8
  make -j8 && make install_sw || exit 2
  unset CROSS_TOP
  unset CROSS_SDK
}

function pack_osx_for ()
{
  LIBNAME=$1
  mkdir -p ${TMP_DIR}/lib/
  ${DEVROOT}/usr/bin/lipo \
  ${TMP_DIR}/x86_64/lib/lib${LIBNAME}.a \
  -output ${TMP_DIR}/lib/lib${LIBNAME}.a -create
}

function build_ios_for ()
{
  PLATFORM=$1
  ARCH=$2
  CROSS_TOP_ENV=CROSS_TOP_$3
  CROSS_SDK_ENV=CROSS_SDK_$3

  make clean

  export CROSS_TOP="${!CROSS_TOP_ENV}"
  export CROSS_SDK="${!CROSS_SDK_ENV}"
  ./Configure $PLATFORM "-arch $ARCH -fembed-bitcode" --prefix=${TMP_DIR}/${ARCH} || exit 1
  # problem of concurrent build; make -j8
  make -j8 && make install_sw || exit 2
  unset CROSS_TOP
  unset CROSS_SDK
}

function pack_ios_for ()
{
  LIBNAME=$1
  mkdir -p ${TMP_DIR}/lib/
  ${DEVROOT}/usr/bin/lipo \
	${TMP_DIR}/x86_64/lib/lib${LIBNAME}.a \
	${TMP_DIR}/armv7s/lib/lib${LIBNAME}.a \
	${TMP_DIR}/arm64/lib/lib${LIBNAME}.a \
	-output ${TMP_DIR}/lib/lib${LIBNAME}.a -create
}

if [[ ${BUILD_PLATFORM} == "osx" ]]; then
    build_osx_for darwin64-x86_64-cc x86_64 OSX || exit 2

    pack_osx_for ssl || exit 6
    pack_osx_for crypto || exit 7

    cp -r ${TMP_DIR}/x86_64/include ${TMP_DIR}/
else
  patch Configurations/10-main.conf < ../patch-conf.patch

  build_ios_for ios64sim-cross x86_64 SIM || exit 2
  build_ios_for ios-cross armv7s IOS || exit 4
  build_ios_for ios64-cross arm64 IOS || exit 5

  pack_ios_for ssl || exit 6
  pack_ios_for crypto || exit 7

  cp -r ${TMP_DIR}/armv7s/include ${TMP_DIR}/
  patch -p3 ${TMP_DIR}/include/openssl/opensslconf.h < patch-include.patch
fi

DIST_DIR=$DFT_DIST_DIR/${BUILD_PLATFORM}
mkdir -p ${DIST_DIR}
cp -r ${TMP_DIR}/include ${TMP_DIR}/lib ${DIST_DIR}

