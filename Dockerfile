FROM ubuntu:18.04

RUN apt-get update -y && \ 
    apt-get install -y mongodb

RUN apt-get install -y curl

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
