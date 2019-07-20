#!/bin/sh -l
set -euo pipefail

STORAGE_SERVICE_ALIAS=${STORAGE_SERVICE_ALIAS:="s3"}
STORAGE_SERVICE_URL=${STORAGE_SERVICE_URL:="https://s3.amazonaws.com"}
MIRROR_SOURCE=${MIRROR_SOURCE:="."}

# Set mc configuration
mc config host add "$STORAGE_SERVICE_ALIAS" "$STORAGE_SERVICE_URL" "$ACCESS_KEY_ID" "$SECRET_ACCESS_KEY"

# Execute mc mirror
mc mirror $* "$MIRROR_SOURCE" "$STORAGE_SERVICE_ALIAS/$MIRROR_TARGET"
