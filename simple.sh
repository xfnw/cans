#!/bin/sh
set -e
echo '=== git clone ===

'
git clone --single-branch --depth 1 --progress $@ checkout

cd checkout


echo '=== configure ===

'

./configure

echo '=== make -j2 ===

'

make -j2


echo '=== make install ===

'

make install

echo '=== done ===

'
