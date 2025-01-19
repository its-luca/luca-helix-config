#!/usr/bin/env bash

set -e
INSTALL_DIR=~/bin
RT_DIR=~/.config/helix
TMP_DIR=$(mktemp)
wget -P $TMP_DIR https://github.com/helix-editor/helix/releases/download/25.01/helix-25.01-aarch64-macos.tar.xz

echo "Tmp dir is $TMP_DIR"

pushd $TMP_DIR 2>/dev/null

mkdir -p $INSTALL_DIR

tar xvf ./helix-25.01-aarch64-macos.tar.xz
cp helix-25.01-aarch64-macos/hx $INSTALL_DIR

mkdir -p $RT_DIR

cp -r helix-25.01-aarch64-macos/runtime $RT_DIR

popd

echo "Add $INSTALL_DIR to your path"

