#/usr/bin/env bash

set -euo pipefail

echo "Cloning argobots sources..."
git clone --depth 1 https://github.com/pmodels/argobots.git argobots-src | awk '{print "[cloning] " $0}'

INSTALL_DIR=$(pwd)/abt
mkdir ${INSTALL_DIR}

echo "Setup and make argobots..."
cd $(pwd)/argobots-src
./autogen.sh | awk '{print "[abt:gen] " $0}'
./configure --prefix=${INSTALL_DIR} | awk '{print "[abt:conf] " $0}'
make -j | awk '{print "[abt:build] " $0}'
make -j install | awk '{print "[abt:install] ", $0}'
