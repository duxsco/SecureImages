#!/bin/bash
buildah from --name "$1" scratch
mnt=$(buildah mount "$1")
tar -C "${mnt}/" "${TAR_OPTIONS}" --selinux --xattrs --same-owner --numeric-owner -xpf "$2"
buildah umount "$1"
buildah commit --rm "$1" "$1"
