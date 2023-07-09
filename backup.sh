#!/bin/sh

echo $(date '+%Y-%m-%d %H %M %S') 'Create variables'
FILE=$(date '+%Y-%m-%d_%H_%M_%S')
ARCHIVE_TYPE='tgz'
GPG_TYPE='gpg'
PROJECT='private_cloud'
DIRECTORY_SOURCE='/home/volokzhanin/server/repos/cloud/'$PROJECT
DIRECTORY_TARGET='/mnt/backup/backup/backup'
DIRECTORY_S3='/mnt/s3/backup/'$PROJECT
GPG_KEY=634064C6

echo $(date '+%Y-%m-%d %H %M %S') 'Create archive'
tar --create \
    --gzip \
    --file=$DIRECTORY_TARGET/$FILE'_'$PROJECT'_''.'$ARCHIVE_TYPE \
    --ignore-failed-read \
    --preserve-permissions \
    --verbose \
$DIRECTORY_SOURCE

echo $(date '+%Y-%m-%d %H %M %S') 'Create encrypted archive'
gpg --recipient $GPG_KEY \
    --symmetric \
    --batch \
    --passphrase $GPG_PASSPHRASE \
    --encrypt $DIRECTORY_TARGET/$FILE'_'$PROJECT'_''.'$ARCHIVE_TYPE
rm $DIRECTORY_TARGET/$FILE'_'$PROJECT'_''.'$ARCHIVE_TYPE

echo $(date '+%Y-%m-%d %H %M %S') 'Move file'
mv $DIRECTORY_TARGET/$FILE'_'$PROJECT'_''.'$ARCHIVE_TYPE'.'$GPG_TYPE $DIRECTORY_S3

echo $(date '+%Y-%m-%d %H %M %S') 'Delete files older than n days'
find $DIRECTORY_S3 -mtime +20 \
    -type f \
    -delete