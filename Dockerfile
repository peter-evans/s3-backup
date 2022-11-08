FROM minio/mc:RELEASE.2022-05-04T06-07-55Z
RUN apk add -y mongodb

LABEL maintainer="Nnadozie Okeke <dozie@fronte.io>"
LABEL repository="https://github.com/VNDRMKT/mongodump-s3-backup"
LABEL homepage="https://github.com/VNDRMKT/mongodump-s3-backup"

LABEL com.github.actions.name="Mongodump S3 Backup"
LABEL com.github.actions.description="Mongodump a db to S3 compatible object storage"
LABEL com.github.actions.icon="upload-cloud"
LABEL com.github.actions.color="yellow"

COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
