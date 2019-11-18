#!/bin/bash
VERSION=$1
if [ -z "${VERSION}" ]; then
  echo "Version not given"
  exit 1
fi

curl --remote-name-all -fsSL "https://ftp.fau.de/archlinux/iso/latest/archlinux-bootstrap-${VERSION}-x86_64.tar.gz{,.sig}" && \
gpg --status-fd 1 --verify "archlinux-bootstrap-${VERSION}-x86_64.tar.gz.sig" 2>/dev/null | sort | grep -e "TRUST_ULTIMATE" -e "VALIDSIG" | xargs | grep -q "\[GNUPG:\] TRUST_ULTIMATE 0 pgp \[GNUPG:\] VALIDSIG 4AA4767BBC9C4B1D18AE28B77F2D434B9741E8AC " && \
TAR_OPTIONS="--strip-components=1" buildah unshare bash buildah.sh arch "archlinux-bootstrap-${VERSION}-x86_64.tar.gz"
