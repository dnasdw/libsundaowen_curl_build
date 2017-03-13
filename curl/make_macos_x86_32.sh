#!/bin/bash

cwdir=`pwd`
rootdir=`dirname "$0"`
cd "$rootdir"
rootdir=`pwd`
target=macos_x86_32
prefix=$rootdir/$target
version=`cat "$rootdir/version.txt"`
rm -rf "$rootdir/$version"
mkdir -p "$rootdir/$version"
cp -rf "$rootdir/../$version/"* "$rootdir/$version"
rm -rf "$rootdir/project"
mkdir -p "$rootdir/project"
cd "$rootdir/project"
openssl_version=`cat "$rootdir/../openssl_build/openssl/version.txt"`
cmake -DBUILD64=OFF -C "$rootdir/CMakeLists.txt" -D_OPENSSL_VERSION="$openssl_version" -DOPENSSL_INCLUDE_DIR="$rootdir/../openssl_build/target/include/$target" -DOPENSSL_CRYPTO_LIBRARY="$rootdir/../openssl_build/target/lib/$target/libcrypto.a" -DOPENSSL_SSL_LIBRARY="$rootdir/../openssl_build/target/lib/$target/libssl.a" -DBUILD_CURL_EXE=OFF -DBUILD_TESTING=OFF -DCURL_STATICLIB=ON -DCURL_DISABLE_LDAP=ON -DCURL_ZLIB=OFF -DCMAKE_INSTALL_PREFIX="$prefix" "$rootdir/$version"
cmake "$rootdir/$version"
cmake --build . --target install --config Release --clean-first
mkdir -p "$rootdir/../target/include/$target"
cp -rf "$prefix/include/"* "$rootdir/../target/include/$target"
mkdir -p "$rootdir/../target/lib/$target"
cp -f "$prefix/lib/libcurl.a" "$rootdir/../target/lib/$target"
cd "$cwdir"
rm -rf "$rootdir/$version"
rm -rf "$rootdir/project"
rm -rf "$prefix"
