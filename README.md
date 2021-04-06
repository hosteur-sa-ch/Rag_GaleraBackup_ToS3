#Ragnarokkr : How to Installation Backup Galera to S3 Bucket

## Prerequist

* Add new Storage node into Galera Cluster installation
>If Galera is already installed on env. and Storage node too, add new Folder into /data/ on storage node (like galera_backup)

### On Storage Node

*Install rclone tool*

<code>curl https://rclone.org/install.sh | sudo bash</code>

*Configure rclone tool*

<code>rclone config</code>

### Create Sync Script and Cronjob




