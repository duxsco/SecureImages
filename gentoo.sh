#!/bin/bash

FULL_PATH="$(curl -fsSL https://ftp.fau.de/gentoo/releases/amd64/autobuilds/latest-stage3-amd64.txt | grep -v "^#" | awk '{print $1}')"
FILE="$(echo "${FULL_PATH}" | awk -F"/" '{print $2}')"
curl --remote-name-all -fsSL "https://ftp.fau.de/gentoo/releases/amd64/autobuilds/${FULL_PATH}{,.DIGESTS.asc}" && \
gpg --status-fd 1 --verify "${FILE}.DIGESTS.asc" 2>/dev/null | sort | grep -e "TRUST_ULTIMATE" -e "VALIDSIG" | xargs | grep -q "\[GNUPG:\] TRUST_ULTIMATE 0 pgp \[GNUPG:\] VALIDSIG 534E4209AB49EEE1C19D96162C44695DB9F6043D " && \
grep -A 1 "^# SHA512 HASH$" "${FILE}.DIGESTS.asc" | grep "${FILE}$" | sha512sum -c - && \
xz -c -d "${FILE}" > rootfs.tar && \
rm -f "${FILE}" "${FILE}.DIGESTS.asc" && \
bash pack.sh gentoo
