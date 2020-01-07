#!/bin/sh

OPENSSL=openssl-1.1.1d
if [ ! -f $OPENSSL.tar.gz ]; then
  echo "Downloading OpenSSL sources..."
  wget https://www.openssl.org/source/$OPENSSL.tar.gz
fi
rm -rf ./$OPENSSL
echo "Unpacking OpenSSL sources..."
tar xzf $OPENSSL.tar.gz || exit 1
cd $OPENSSL

configure ./Configure linux-generic32 no-shared no-threads no-dso no-engine no-unit-test no-ui || exit 1
echo "Building OpenSSL..."
make depend || exit 1
make -j 4 || exit 1

rm -rf ../build/crypto || exit 1
mkdir -p ../build/crypto/lib || exit 1
cp libcrypto.a libssl.a ../build/crypto/lib/ || exit 1
cp -r include ../build/crypto/ || exit 1
cd ..
