#!/bin/bash

curl --remote-name-all -fsSL "https://cloud-images.ubuntu.com/minimal/daily/bionic/current/{bionic-minimal-cloudimg-amd64-root.tar.xz,SHA256SUMS,SHA256SUMS.gpg}" && \
gpg --status-fd 1 --verify SHA256SUMS.gpg SHA256SUMS 2>/dev/null | sort | grep -e "TRUST_ULTIMATE" -e "VALIDSIG" | xargs | grep -q "\[GNUPG:\] TRUST_ULTIMATE 0 pgp \[GNUPG:\] VALIDSIG 4A3CE3CD565D7EB5C810E2B97FF3F408476CF100 " && \
grep bionic-minimal-cloudimg-amd64-root.tar.xz SHA256SUMS | sha256sum -c - && \
xz -c -d bionic-minimal-cloudimg-amd64-root.tar.xz > rootfs.tar && \
rm -f bionic-minimal-cloudimg-amd64-root.tar.xz SHA256SUMS{,.gpg} && \
bash pack.sh ubuntu
