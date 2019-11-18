#!/bin/bash

curl --remote-name-all -fsSL "https://github.com/CentOS/sig-cloud-instance-images/raw/CentOS-8-x86_64/docker/centos-8-container.tar.xz{,.asc}" && \
gpg --status-fd 1 --verify centos-8-container.tar.xz.asc 2>/dev/null | sort | grep -e "TRUST_ULTIMATE" -e "VALIDSIG" | xargs | grep -q "\[GNUPG:\] TRUST_ULTIMATE 0 pgp \[GNUPG:\] VALIDSIG 99DB70FAE1D7CE227FB6488205B555B38483C65D " && \
xz -c -d centos-8-container.tar.xz > rootfs.tar && \
rm -f centos-8-container.tar.xz{,.asc} && \
bash pack.sh centos
