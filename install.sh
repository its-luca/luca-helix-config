#!/usr/bin/env bash

INSTALL_DIR=~/bin
RT_DIR=~/.config/helix
TMP_DIR=$(mktemp)

# Detect the operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macos"
elif [[ -f /etc/os-release ]]; then
  # Check if it's Linux and specifically Ubuntu
  if grep -q "Ubuntu" /etc/os-release; then
    OS="ubuntu"
  else
    echo "Running on Linux (but not Ubuntu)"
    exit
  fi
else
  echo "Unknown operating system"
  exit
fi

echo "Detected OS: $OS"

hx --version 2>/dev/null
if [ $? -ne 0 ]; then

  pushd $TMP_DIR 2>/dev/null
  #Download and install hx
  if [ $OS == "macos" ]; then
    wget https://github.com/helix-editor/helix/releases/download/25.01/helix-25.01-aarch64-macos.tar.xz
    tar xvf ./helix-25.01-aarch64-macos.tar.xz
    cp helix-25.01-aarch64-macos/hx $INSTALL_DIR
    cp -r helix-25.01-aarch64-macos/runtime $RT_DIR
  else
    wget https://github.com/helix-editor/helix/releases/download/25.01/helix-25.01-x86_64-linux.tar.xz
    tar xvf ./helix-25.01-x86_64-linux.tar.xz
    cp ./helix-25.01-x86_64-linux.tar.xz/hx $INSTALL_DIR
    cp -r ./helix-25.01-x86_64-linux.tar.xz/runtime $RT_DIR
  fi

  mkdir -p $INSTALL_DIR

  mkdir -p $RT_DIR

  popd

  echo "Add $INSTALL_DIR to your path"
else
  echo "Helix already installed"
fi

bash-language-server --version &>/dev/null
if [ $? -ne 0 ]; then
  # install bash language server
  if [[ $OS == "macos" ]]; then
    brew install bash-language-server
  elif [[ $OS == "ubuntu" ]]; then
    sudo snap install bash-language-server --classic
  fi
else
  echo "Bash language server already installed"
fi

shellcheck --version 2>/dev/null
if [ $? -ne 0 ]; then
  if [[ $OS == "macos" ]]; then
    brew install shellcheck
  else
    sudo apt install shellcheck
  fi
else
  echo "Shellcheck is already installed"
fi

command shfmt
if [ $? -ne 0 ]; then
  echo "Installing shfmt"
  if [[ $OS == "macos" ]]; then
    wget -O $INSTALL_DIR/shfmt https://github.com/mvdan/sh/releases/download/v3.10.0/shfmt_v3.10.0_darwin_arm64
    chmod +x $INSTALL_DIR/shfmt
  else
    wget -O $INSTALL_DIR/shfmt https://github.com/mvdan/sh/releases/download/v3.10.0/shfmt_v3.10.0_linux_amd64
    chmod +x $INSTALL_DIR/shfmt
  fi

else
  echo "shfmt is already installed"
fi
