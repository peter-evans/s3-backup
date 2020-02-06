FROM minio/mc:RELEASE.2020-02-05T20-07-22Z

LABEL maintainer="Peter Evans <mail@peterevans.dev>"
LABEL repository="https://github.com/peter-evans/s3-backup"
LABEL homepage="https://github.com/peter-evans/s3-backup"

LABEL com.github.actions.name="S3 Backup"
LABEL com.github.actions.description="Mirror a repository to S3 compatible object storage"
LABEL com.github.actions.icon="upload-cloud"
LABEL com.github.actions.color="yellow"

COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]