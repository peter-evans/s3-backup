#!/bin/sh -l
# set -euo pipefail

curl https://dl.min.io/client/mc/release/linux-amd64/mc \
    --create-dirs \
    -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/
  
STORAGE_SERVICE_ALIAS=${STORAGE_SERVICE_ALIAS:="s3"}
STORAGE_SERVICE_URL=${STORAGE_SERVICE_URL:="https://s3.amazonaws.com"}
AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN:=""}
MIRROR_SOURCE=${MIRROR_SOURCE:="."}
AWS_REGION=${AWS_REGION:=""}
MONGODB_URI=${MONGODB_URI:=""}
MONGODB_NAME=${MONGODB_NAME:=""}


# Check mirror target is set
if [ -z "$MIRROR_TARGET" ]; then
  echo "MIRROR_TARGET is not set"
  exit 1
fi

# Set mc configuration
if [ -z "$AWS_SESSION_TOKEN" ]; then
  mc alias set "$STORAGE_SERVICE_ALIAS" "$STORAGE_SERVICE_URL" "$ACCESS_KEY_ID" "$SECRET_ACCESS_KEY"
else
  export MC_HOST_${STORAGE_SERVICE_ALIAS}=https://${ACCESS_KEY_ID}:${SECRET_ACCESS_KEY}:${AWS_SESSION_TOKEN}@s3.${AWS_REGION}.amazonaws.com
fi

# Execute mc pipe mongodump output to s3 bucket

# mongodump --help

echo $MONGODB_NAME

# mongodump --archive --oplog --uri=$MONGODB_URI

# mc pipe "$STORAGE_SERVICE_ALIAS/$MIRROR_TARGET/$MONGODB_NAME"
