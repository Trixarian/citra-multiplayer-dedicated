#!/bin/bash -ex

if [ -z "$1" ]; then
  echo "Please specify where to extract the source archive!"
  exit 1
fi

LATEST_TARBALL="$(wget -O- https://api.github.com/repos/citra-emu/citra-nightly/releases/latest | jq -rc '.assets[] | .browser_download_url | match("https://.+citra-unified-source-.+.xz$") | .string')"

wget -c "${LATEST_TARBALL}" -O citra-unified.tar.xz
mkdir -pv "$1"
tar --strip-components=1 -C "$1" -xf citra-unified.tar.xz
