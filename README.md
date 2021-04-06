# Ragnarokkr : How to Installation Backup Galera to S3 Bucket

## Prerequist

* Add new Storage node into Galera Cluster installation
>If Galera is already installed on env. and Storage node too, add new Folder into /data/ on storage node (like galera_backup)

### On Storage Node

*Install rclone tool*

<code>curl https://rclone.org/install.sh | sudo bash</code>

*Configure rclone tool*

<code>rclone config</code>

#### Configuration for rClone (S3 On Prem Hosteur)

```bash
2021/04/06 09:24:23 NOTICE: Config file "/root/.config/rclone/rclone.conf" not found - using defaults
No remotes found - make a new one
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n
name> S3BACKUP

Type of storage to configure.
Enter a string value. Press Enter for the default ("").
Choose a number from below, or type in your own value
...
Storage> 4

Choose your S3 provider.
Enter a string value. Press Enter for the default ("").
Choose a number from below, or type in your own value
...
provider> 13

Get AWS credentials from runtime (environment variables or EC2/ECS meta data if no env vars).
Only applies if access_key_id and secret_access_key is blank.
Enter a boolean value (true or false). Press Enter for the default ("false").
Choose a number from below, or type in your own value
...
env_auth> 1

AWS Access Key ID.
Leave blank for anonymous access or runtime credentials.
Enter a string value. Press Enter for the default ("").
access_key_id> [CLIENT AK]

AWS Secret Access Key (password)
Leave blank for anonymous access or runtime credentials.
Enter a string value. Press Enter for the default ("").
secret_access_key> [CLIENT SK]

Region to connect to.
Leave blank if you are using an S3 clone and you don't have a region.
Enter a string value. Press Enter for the default ("").
Choose a number from below, or type in your own value
 1 / Use this if unsure. Will use v4 signatures and an empty region.
   \ ""
 2 / Use this only if v4 signatures don't work, e.g. pre Jewel/v10 CEPH.
   \ "other-v2-signature"
region> 1

Endpoint for S3 API.
Required when using an S3 clone.
Enter a string value. Press Enter for the default ("").
Choose a number from below, or type in your own value
endpoint> s3.hosteur.io

Location constraint - must be set to match the Region.
Leave blank if not sure. Used when creating buckets only.
Enter a string value. Press Enter for the default ("").
location_constraint>

Canned ACL used when creating buckets and storing or copying objects.

This ACL is used for creating objects and if bucket_acl isn't set, for creating buckets too.

For more info visit https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl

Note that this ACL is applied when server-side copying objects as S3
doesn't copy the ACL from the source but rather writes a fresh one.
Enter a string value. Press Enter for the default ("").
Choose a number from below, or type in your own value
...
acl> 1

Edit advanced config? (y/n)
y) Yes
n) No (default)
y/n> n

Remote config
--------------------
[S3BACKUP]
type = s3
provider = Other
env_auth = false
access_key_id = [AK]
secret_access_key = [SK]
endpoint = s3.hosteur.io
acl = private
--------------------
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
y/e/d> y

Current remotes:

Name                 Type
====                 ====
S3BACKUP             s3

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> q
```

*To test the configuration use command line below to list bucket and folder*

<code>rclone ls S3BACKUP:[BUCKET]</code>
>Should list all objects in the bucket.


### On Galera Volumes

Change /var/lib/jelastic/backup volume from local to NFS

![volume](https://github.com/hosteur-sa-ch/Rag_GaleraBackup_ToS3/blob/main/img/Conf_Vol_Galera.png)

### Create Sync Script and Cronjob

<code>curl https://raw.githubusercontent.com/hosteur-sa-ch/Rag_GaleraBackup_ToS3/main/script/syncbackup.sh > /root/syncbackup.sh</code>
>Change bucket and folders on this.

<code>echo "10 * * * * /root/syncbackup.sh" >> /etc/crontab && chmod +x /root/syncbackup.sh</code>

## Activate Jelastic Backup crontjob

*on one galera node (named it BACKUP)*

Go to cron folder and activate the jelastic default backup script like this.

*Backup every hour the database*
<code>0 * * * * /var/lib/jelastic/bin/backup_script.sh -m dump -c 15 -u jelastic-XXXX -p [database-pass] -d [db_to_backup]</code>
**!!! Save only on this instance !!!**

Get New Backup Script from https://raw.githubusercontent.com/hosteur-sa-ch/Rag_GaleraBackup_ToS3/main/script/backup_script.sh and replace current one.
>The modification is only to remove bzip feature as default, this compression will be apply by storage node and node load galera node for it.