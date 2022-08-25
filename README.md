# S3 Backup
[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-S3%20Backup-blue.svg?colorA=24292e&colorB=0366d6&style=flat&longCache=true&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAM6wAADOsB5dZE0gAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAERSURBVCiRhZG/SsMxFEZPfsVJ61jbxaF0cRQRcRJ9hlYn30IHN/+9iquDCOIsblIrOjqKgy5aKoJQj4O3EEtbPwhJbr6Te28CmdSKeqzeqr0YbfVIrTBKakvtOl5dtTkK+v4HfA9PEyBFCY9AGVgCBLaBp1jPAyfAJ/AAdIEG0dNAiyP7+K1qIfMdonZic6+WJoBJvQlvuwDqcXadUuqPA1NKAlexbRTAIMvMOCjTbMwl1LtI/6KWJ5Q6rT6Ht1MA58AX8Apcqqt5r2qhrgAXQC3CZ6i1+KMd9TRu3MvA3aH/fFPnBodb6oe6HM8+lYHrGdRXW8M9bMZtPXUji69lmf5Cmamq7quNLFZXD9Rq7v0Bpc1o/tp0fisAAAAASUVORK5CYII=)](https://github.com/marketplace/actions/s3-backup)

A GitHub action to mirror a repository to S3 compatible object storage.

## Usage

This example will mirror your repository to an S3 bucket called `repo-backup-bucket` and at the optional key `/at/some/path`. Objects at the target will be overwritten, and extraneous objects will be removed. This default usage keeps your S3 backup in sync with GitHub.

```yml
    - name: S3 Backup
      uses: peter-evans/s3-backup@v1
      env:
        ACCESS_KEY_ID: ${{ secrets.ACCESS_KEY_ID }}
        SECRET_ACCESS_KEY: ${{ secrets.SECRET_ACCESS_KEY }}
        MIRROR_TARGET: repo-backup-bucket/at/some/path
      with:
        args: --overwrite --remove
```

S3 Backup uses the `mirror` command of [MinIO Client](https://github.com/minio/mc).
Additional arguments may be passed to the action via the `args` parameter.

#### Secrets and environment variables

The following variables may be passed to the action as secrets or environment variables. `MIRROR_TARGET`, for example, if considered sensitive should be passed as a secret.

- `ACCESS_KEY_ID` (**required**) - The storage service access key id.
- `SECRET_ACCESS_KEY` (**required**) - The storage service secret access key.
- `MIRROR_TARGET` (**required**) - The target bucket, and optionally, the key within the bucket.
- `AWS_SESSION_TOKEN` - When using temporary credentials (Amazon S3)
- `AWS_REGION` (required with AWS_SESSION_TOKEN) - the region where the s3 bucket is located for Amazon S3. **Mandatory** when using SESSION_TOKEN.
- `MIRROR_SOURCE` - The source defaults to the repository root. If required a path relative to the root can be set.
- `STORAGE_SERVICE_URL` - The URL to the object storage service. Defaults to `https://s3.amazonaws.com` for Amazon S3.
- `STORAGE_SERVICE_ALIAS` - Defaults to `s3`. See [MinIO Client](https://github.com/minio/mc) for other options such as S3 compatible `minio`, and `gcs` for Google Cloud Storage.

#### IAM user policy

The IAM user associated with the `ACCESS_KEY_ID` and `SECRET_ACCESS_KEY` should have `s3:*` policy access.

If required you can create a policy to restrict access to specific resources.
The following policy grants the user access to the bucket `my-restricted-bucket` and its contents.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowBucketStat",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::my-restricted-bucket"
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

```yml
name: Mirror repo to S3
on:
  push:
    branches:
      - master
jobs:
  s3Backup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: S3 Backup
        uses: peter-evans/s3-backup@v1
        env:
          ACCESS_KEY_ID: ${{ secrets.ACCESS_KEY_ID }}
          MIRROR_TARGET: ${{ secrets.MIRROR_TARGET }}
          SECRET_ACCESS_KEY: ${{ secrets.SECRET_ACCESS_KEY }}
        with:
          args: --overwrite --remove
```

## License

[MIT](LICENSE)

