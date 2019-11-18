#!/bin/bash

VERSION="$(curl -fsSL https://alpine.global.ssl.fastly.net/alpine/latest-stable/releases/x86_64/latest-releases.yaml | grep -i "^[[:space:]]*version" | awk '{print $NF}' | sort | uniq)"
curl --remote-name-all -fsSL "https://alpine.global.ssl.fastly.net/alpine/latest-stable/releases/x86_64/alpine-minirootfs-${VERSION}-x86_64.tar.gz{,.asc}" && \
gpg --status-fd 1 --verify "alpine-minirootfs-${VERSION}-x86_64.tar.gz.asc" 2>/dev/null | sort | grep -e "TRUST_ULTIMATE" -e "VALIDSIG" | xargs | grep -q "\[GNUPG:\] TRUST_ULTIMATE 0 pgp \[GNUPG:\] VALIDSIG 0482D84022F52DF1C4E7CD43293ACD0907D9495A " && \
gzip -c -d "alpine-minirootfs-${VERSION}-x86_64.tar.gz" > rootfs.tar && \
rm -f "alpine-minirootfs-${VERSION}-x86_64.tar.gz" "alpine-minirootfs-${VERSION}-x86_64.tar.gz.asc" && \
bash pack.sh alpine
