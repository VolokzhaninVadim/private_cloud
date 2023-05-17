#!/bin/bash

#sudo apt-get install p7zip-full
# Создаем резервную копию
cd /home/volokzhanin/docker/private_cloud
tar cvpzf /mnt/backup/backup/private_cloud/"$(date '+%Y-%m-%d').tar.gz" ./
7za a -tzip -p$ARCHIVE_PRIVATE_CLOUD -mem=AES256  /mnt/backup/backup/private_cloud/"$(date '+%Y-%m-%d').zip" /mnt/backup/backup/private_cloud/"$(date '+%Y-%m-%d').tar.gz"
rm /mnt/backup/backup/private_cloud/"$(date '+%Y-%m-%d').tar.gz"
# Удаляем архивы резервной копии старше n дней
find /mnt/backup/backup/private_cloud/ -mtime +0 -type f -delete

# restore
# 7za e /mnt/backup/backup/private_cloud/2021-10-09.zip
# cd /home/volokzhanin/docker/private_cloud/ & tar xpvzf /mnt/backup/backup/private_cloud/2021-10-09.tar.gz