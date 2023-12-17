#!/bin/bash
set -e
 
if which podman &> /dev/null; then
  container=podman
elif which docker &> /dev/null; then
  container=docker
else
  echo "Podman or docker have to be in \$PATH"
  exit 1
fi

function build_linux_sdk() {

  cp config-badgeros .config
  toolchain_prefix=riscv32-badgeros-linux-gnu

  ${container} build -f Dockerfile.linux-builder -t badgeros-buildroot-builder-linux
  ${container} run -it --rm -v $(pwd):/tmp/buildroot:z -w /tmp/buildroot -e FORCE_UNSAFE_CONFIGURE=1 --userns=keep-id badgeros-buildroot-builder-linux bash -c "make clean; make syncconfig; make sdk"
}

build_linux_sdk

echo
echo "***************************************"
echo "Build succesful your toolchain is in output/images/${toolchain_prefix}_sdk-buildroot.tar.gz"
