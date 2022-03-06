#!/bin/sh
set -e
echo '=== git clone ===

'
git clone --single-branch --depth 1 --progress $@ solanum

cd solanum

echo '=== autogen ===

'

./autogen.sh

echo '=== configure ===

'

CFLAGS="-Werror -Wno-unused-value -Wno-unused-parameter" ./configure --enable-assert=hard --enable-warnings

echo '=== make ===

'

make -j2

echo '=== make check ===

'

#make check

echo '=== make install ===

'

make install

echo '=== done ===

'
