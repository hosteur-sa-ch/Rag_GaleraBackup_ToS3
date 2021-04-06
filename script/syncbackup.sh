#!/bin/bash
bzip2 /data/(add-sub-here)*.sql
rclone sync --ignore-existing /data/(add-sub-here) S3BACKUP:[BUCKET]/[FOLDER]/