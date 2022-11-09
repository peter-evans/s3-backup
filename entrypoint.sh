#!/bin/sh -l

curl https://dl.min.io/client/mc/release/linux-amd64/mc \
    --create-dirs \
    -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/
  
AWS_BACKUP_USER_STORAGE_SERVICE_ALIAS=${STORAGE_SERVICE_ALIAS:="s3"}
AWS_BACKUP_USER_STORAGE_SERVICE_URL=${STORAGE_SERVICE_URL:="https://s3.amazonaws.com"}
AWS_BACKUP_USER_AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN:=""}
AWS_BACKUP_USER_AWS_REGION=${AWS_REGION:=""}
MONGODB_URI=${MONGODB_URI:=""}
MONGODB_NAME=${MONGODB_NAME:=""}


# Check mirror target is set
if [ -z "$AWS_BACKUP_USER_MIRROR_TARGET" ]; then
  echo "MIRROR_TARGET is not set"
  exit 1
fi

# Set mc configuration
if [ -z "$AWS_BACKUP_USER_AWS_SESSION_TOKEN" ]; then
  mc alias set "$AWS_BACKUP_USER_STORAGE_SERVICE_ALIAS" "$AWS_BACKUP_USER_STORAGE_SERVICE_URL" "$AWS_BACKUP_USER_ACCESS_KEY_ID" "$AWS_BACKUP_USER_SECRET_ACCESS_KEY"
else
  export MC_HOST_${AWS_BACKUP_USER_STORAGE_SERVICE_ALIAS}=https://${AWS_BACKUP_USER_ACCESS_KEY_ID}:${AWS_BACKUP_USER_SECRET_ACCESS_KEY}:${AWS_BACKUP_USER_AWS_SESSION_TOKEN}@s3.${AWS_BACKUP_USER_AWS_REGION}.amazonaws.com
fi

# Execute mc pipe mongodump output to s3 bucket
mongodump --archive --oplog --uri=$MONGODB_URI | mc pipe "$AWS_BACKUP_USER_STORAGE_SERVICE_ALIAS/$AWS_BACKUP_USER_MIRROR_TARGET/$AWS_BACKUP_USER_MONGODB_NAME"
