![Nextcloud_Logo.svg](https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Nextcloud_Logo.svg/113px-Nextcloud_Logo.svg.png)

# Create database
```
# Get container id
docker ps
# Log in container
docker exec -it container_id   bash
```

Log in postgres: `psql -U postgres` and execute:
```
CREATE DATABASE nextcloud TEMPLATE template0 ENCODING 'UNICODE';
create user nextcloud with encrypted password 'PASSWORD';
ALTER DATABASE nextcloud OWNER TO nextcloud;
GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud;
\q
```
In authentication page set yor access data.

# Edit the config
`sudo nano ./app/config/config.php`

View access rights
```
# Get container id
docker ps
# Log in container
docker exec -it container_id   bash
# Pass in folder
cd data/volokzhanin/files
# View access rights
ls -la
# Change access rights on necessary folder
chown -R www-data:www-data /var/www/html/
chown -R www-data:www-data /external_storage/
```
Change access rights for files:
```
sudo chown -R www-data:volokzhanin /mnt/0/backup/vvy_work_backup
sudo chmod -R 774 /mnt/0/backup/vvy_work_backup
```

# Smartphone (Android)
1. Nextcloud app for smartphone install via [FDroid](https://f-droid.org/).
1. App for syncing [DAVx⁵](https://www.davx5.com/tested-with/nextcloud) install via [FDroid](https://f-droid.org/).
1. App for two-factor authorization [FreeOTP+ ](https://f-droid.org/ru/packages/org.liberty.android.freeotpplus/). Install via [FDroid](https://f-droid.org/).

# PC (Manjaro Linux)
1. Install syncthing: `sudo pacman -S syncthing`

# Cron
```
# Nextcloud
@daily docker exec -u www-data nextcloud-app php /var/www/html/occ maps:scan-photos
@daily docker exec -u www-data nextcloud-app php -f /var/www/html/cron.php
```

# FAQ
## Unblocking user
`docker exec -u 33 container_id ./occ user:enable volokzhanin`

## Reset user password
```
# Log in container
docker exec -it --user 33 <docker id> bash
# Reset user password
php occ user:resetpassword YOUR_USER
```

## Fix error in transmisiion "Unable to save resume file: Permission denied"
```
# Get container id
docker ps
# Log in container
docker exec -it container_id   bash
# Change access rights
chown -R abc:users /downloads
```
## Fix error "Слишком много попыток авторизации":
```
# Log in docker pg nextcloud
docker exec -ti pg-server /bin/bash

# Launch psql
psql -U db_user -W --dbname=cloud_db

# Check count rows in table
select count(*) from oc_bruteforce_attempts;

# Truncate table
truncate oc_bruteforce_attempts RESTART IDENTITY;
```
## Fix upgrade occ (upgrade nextcloud version)
```
# Log in container
docker exec -it --user 33 <docker id> bash
# Upgrade occ
php occ upgrade
php occ maintenance:mode --off
```
