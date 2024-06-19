#!/usr/bin/bash

set -eux

BUILDNO=0
SOURCE=$(cygpath -m /home/mold)
BINARY=$(cygpath -m /home/mold-bin)
NAME=win-mold-${BUILDNO}

git clone --branch stable https://github.com/rui314/mold.git
cd mold
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${BINARY} -DCMAKE_CXX_COMPILER=c++ -B build
cmake --build build -j$(nproc)
cmake --build build --target install

7zr a -mx9 -mqs=on -mmt=on ${BINARY}/${NAME}.7z ${BINARY}/*

if [[ -v GITHUB_WORKFLOW ]]; then
  echo "OUTPUT_BINARY=${BINARY}/${NAME}.7z" >> $GITHUB_OUTPUT
  echo "RELEASE_NAME=win-mold-r${CBREV_NO}" >> $GITHUB_OUTPUT
  echo "BUILDNO=${BUILDNO}" >> $GITHUB_OUTPUT
  echo "OUTPUT_NAME=${NAME}.7z" >> $GITHUB_OUTPUT
fi
