#!/bin/sh -l

curl https://dl.min.io/client/mc/release/linux-amd64/mc \
    --create-dirs \
    -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/
  
MONGOBACKUP_STORAGE_SERVICE_ALIAS=${STORAGE_SERVICE_ALIAS:="s3"}
MONGOBACKUP_STORAGE_SERVICE_URL=${STORAGE_SERVICE_URL:="https://s3.amazonaws.com"}
MONGOBACKUP_AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN:=""}
MONGOBACKUP_AWS_REGION=${AWS_REGION:=""}
MONGODB_URI=${MONGODB_URI:=""}
MONGODB_NAME=${MONGODB_NAME:=""}


# Check mirror target is set
if [ -z "$MONGOBACKUP_MIRROR_TARGET" ]; then
  echo "MIRROR_TARGET is not set"
  exit 1
fi

# Set mc configuration
if [ -z "$MONGOBACKUP_AWS_SESSION_TOKEN" ]; then
  mc alias set "$MONGOBACKUP_STORAGE_SERVICE_ALIAS" "$MONGOBACKUP_STORAGE_SERVICE_URL" "$MONGOBACKUP_ACCESS_KEY_ID" "$MONGOBACKUP_SECRET_ACCESS_KEY"
else
  export MC_HOST_${MONGOBACKUP_STORAGE_SERVICE_ALIAS}=https://${MONGOBACKUP_ACCESS_KEY_ID}:${MONGOBACKUP_SECRET_ACCESS_KEY}:${MONGOBACKUP_AWS_SESSION_TOKEN}@s3.${MONGOBACKUP_AWS_REGION}.amazonaws.com
fi

# Execute mc pipe mongodump output to s3 bucket
mongodump --archive --oplog --uri=$MONGODB_URI | mc pipe "$MONGOBACKUP_STORAGE_SERVICE_ALIAS/$MONGOBACKUP_MIRROR_TARGET/$MONGOBACKUP_MONGODB_NAME"
