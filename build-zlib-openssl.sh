#!/bin/sh

ZLIB=zlib-1.2.11

if [ ! -f $ZLIB.tar.gz ]; then
  echo "Downloading zlib sources..."
  wget https://www.zlib.net/$ZLIB.tar.gz
fi
rm -rf ./$ZLIB
echo "Unpacking zlib sources..."
tar xzf $ZLIB.tar.gz || exit 1
cd $ZLIB
CC=arm-none-linux-gnueabi-gcc CFLAGS=-fPIC ./configure
echo "Building zlib..."
make -j 4 || exit 1
rm -rf ../build/zlib || exit 1
mkdir -p ../build/zlib/lib || exit 1
mkdir -p ../build/zlib/include || exit 1
cp libz.a ../build/zlib/lib/ || exit 1
cp zconf.h zlib.h ../build/zlib/include || exit 1
cd ..

OPENSSL=openssl-1.1.1d
if [ ! -f $OPENSSL.tar.gz ]; then
  echo "Downloading OpenSSL sources..."
  wget https://www.openssl.org/source/$OPENSSL.tar.gz
fi
rm -rf ./$OPENSSL
echo "Unpacking OpenSSL sources..."
tar xzf $OPENSSL.tar.gz || exit 1
cd $OPENSSL

./Configure --cross-compile-prefix=arm-none-linux-gnueabi- linux-generic32 no-shared no-threads no-dso no-engine no-unit-test || exit 1
echo "Building OpenSSL..."
make depend || exit 1
make -j 4 || exit 1

rm -rf ../build/crypto || exit 1
mkdir -p ../build/crypto/lib || exit 1
cp libcrypto.a libssl.a ../build/crypto/lib/ || exit 1
cp -r include ../build/crypto/ || exit 1
cd ..
