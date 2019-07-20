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
  uses = "./"
  secrets = ["ACCESS_KEY_ID", "SECRET_ACCESS_KEY"]
  env = {
    MIRROR_TARGET = "s3-backup.s3-backup"
  }
  args = "--overwrite --remove"
}
