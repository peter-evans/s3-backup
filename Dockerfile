FROM chainguard/minio-client:latest-dev@sha256:39768db4c3fa811bc8f2e2a3e0add8ea391648b1c980de179985e1c353dc1805

USER root

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
