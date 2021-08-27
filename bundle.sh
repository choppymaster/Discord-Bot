#!/bin/bash -e
yarn

[ -d "dist" ] && rm -rf dist

echo "[+] Applying patches to accommodate bundler ..."
for i in patches/*.patch; do
    echo "Applying $i ..."
    patch -Np1 --no-backup-if-mismatch -i "$i"
done

yarn run parcel build

echo "[+] Installing non-bundle-able packages ..."
cd "dist"
echo '{"name": "citra-discord-bot","license": "GPL-2.0+"}' > package.json
yarn add discord.js@^13
cd ..

echo "[+] Reversing patches ..."
for i in patches/*.patch; do
    echo "Reversing $i ..."
    patch -Np1 -R -i "$i"
done

echo "[+] Removing patch backup files ..."
find . -name "*.orig" -print -delete
