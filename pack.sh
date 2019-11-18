#!/bin/bash

TAR_HASH=$(sha256sum rootfs.tar | awk '{print $1}') && \
mv -v rootfs.tar "${TAR_HASH}"

echo "Directory Transport Version: 1.1" > version

TIME="$(date --rfc-3339=ns | sed 's/ /T/')"

cat <<EOF > temp.json
{
  "created": "${TIME}",
  "architecture": "amd64",
  "os": "linux",
  "config": {},
  "rootfs": {
    "type": "layers",
    "diff_ids": [
      "sha256:${TAR_HASH}"
    ]
  },
  "history": [
    {
      "created": "${TIME}",
      "created_by": "/bin/sh"
    }
  ]
}
EOF
JSON_HASH="$(sha256sum temp.json | awk '{print $1}')"
mv -v temp.json "${JSON_HASH}"

cat <<EOF > manifest.json
{
  "schemaVersion": 2,
  "config": {
    "mediaType": "application/vnd.oci.image.config.v1+json",
    "digest": "sha256:${JSON_HASH}",
    "size": $(du -b "${JSON_HASH}" | awk '{print $1}')
  },
  "layers": [
    {
      "mediaType": "application/vnd.oci.image.layer.v1.tar",
      "digest": "sha256:${TAR_HASH}",
      "size": $(du -b "${TAR_HASH}" | awk '{print $1}')
    }
  ]
}
EOF

skopeo copy dir:. "containers-storage:localhost/$1:latest"
