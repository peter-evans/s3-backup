# S3 Backup
[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-S3%20Backup-blue.svg?colorA=24292e&colorB=0366d6&style=flat&longCache=true&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAM6wAADOsB5dZE0gAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAERSURBVCiRhZG/SsMxFEZPfsVJ61jbxaF0cRQRcRJ9hlYn30IHN/+9iquDCOIsblIrOjqKgy5aKoJQj4O3EEtbPwhJbr6Te28CmdSKeqzeqr0YbfVIrTBKakvtOl5dtTkK+v4HfA9PEyBFCY9AGVgCBLaBp1jPAyfAJ/AAdIEG0dNAiyP7+K1qIfMdonZic6+WJoBJvQlvuwDqcXadUuqPA1NKAlexbRTAIMvMOCjTbMwl1LtI/6KWJ5Q6rT6Ht1MA58AX8Apcqqt5r2qhrgAXQC3CZ6i1+KMd9TRu3MvA3aH/fFPnBodb6oe6HM8+lYHrGdRXW8M9bMZtPXUji69lmf5Cmamq7quNLFZXD9Rq7v0Bpc1o/tp0fisAAAAASUVORK5CYII=)](https://github.com/marketplace/actions/s3-backup)

A GitHub action to mirror a repository to S3 compatible object storage.

## Usage

This example will mirror your repository to an S3 bucket called `repo-backup-bucket` and at the optional key `/at/some/path`. Objects at the target will be overwritten, and extraneous objects will be removed. This default usage keeps your S3 backup in sync with GitHub.

```hcl
action "S3 Backup" {
  uses = "peter-evans/s3-backup@v1.0.0"
  secrets = ["ACCESS_KEY_ID", "SECRET_ACCESS_KEY"]
  env = {
    MIRROR_TARGET = "repo-backup-bucket/at/some/path"
  }
  args = "--overwrite --remove"
}
```

S3 Backup uses the `mirror` command of [MinIO Client](https://github.com/minio/mc).
Additionl arguments may be passed to the action via the `args` parameter.

#### Secrets and environment variables

The secrets `ACCESS_KEY_ID` and `SECRET_ACCESS_KEY` are required and the associated IAM user should have `s3:*` policy access.

- `MIRROR_TARGET` (**required**) - The target bucket and an optional key.
- `MIRROR_SOURCE` - The source defaults to the repository root. If required a path relative to the root can be set.
- `STORAGE_SERVICE_URL` - The URL to the object storage service. Defaults to `https://s3.amazonaws.com` for Amazon S3.
- `STORAGE_SERVICE_ALIAS` - Defaults to `s3`. See [MinIO Client](https://github.com/minio/mc) for other options such as S3 compatible `minio`, and `gcs` for Google Cloud Storage.

#### Restricted IAM policy

IAM users need full S3 access. However, you can create a policy to restrict access to specific resources if required.
This policy grants the user access to the bucket `my-restricted-bucket` and its contents.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowBucketStat",
            "Effect": "Allow",
            "Action": [
                "s3:HeadBucket"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowThisBucketOnly",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::my-restricted-bucket/*",
                "arn:aws:s3:::my-restricted-bucket"
            ]
        }
    ]
}
```

## Complete workflow example

The workflow below filters `push` events for the `master` branch before mirroring to S3.

```hcl
workflow "Mirror repo to S3" {
  resolves = ["S3 Backup"]
  on = "push"
}

action "Filter master branch" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "S3 Backup" {
  needs = ["Filter master branch"]
  uses = "peter-evans/s3-backup@v1.0.0"
  secrets = ["ACCESS_KEY_ID", "SECRET_ACCESS_KEY"]
  env = {
    MIRROR_TARGET = "my-repo-backup"
  }
  args = "--overwrite --remove"
}
```

## License

MIT License - see the [LICENSE](LICENSE) file for details
