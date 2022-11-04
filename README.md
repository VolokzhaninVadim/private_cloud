![Nextcloud_Logo.svg](https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Nextcloud_Logo.svg/113px-Nextcloud_Logo.svg.png)
# Launch 
Launch: `http://172.24.0.5`

# Create data base
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

# Proxy
```
sudo rm -rf ./proxy/conf.d/my_custom_proxy_settings.conf
sudo touch ./proxy/conf.d/my_custom_proxy_settings.conf
sudo nano  ./proxy/conf.d/my_custom_proxy_settings.conf 
```
Set: `client_max_body_size 5000m;`

# Edit the congig
`sudo nano ./app/config/config.php`

```
  <?php
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' =>
  array (
    0 =>
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 =>
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'filelocking.enabled' => false,
  'instanceid' => '<instanceid>',
  'passwordsalt' => '<passwordsalt>',
  'secret' => '<secret>',
  'trusted_domains' =>
  array (
    0 => '172.24.0.5',
    1 => '<external IP>',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'pgsql',
  'version' => '21.0.2.1',
  'overwrite.cli.url' => 'http://<external IP>',
  'dbname' => 'nextcloud',
  'dbuser' => 'nextcloud',
  'dbpassword' => '<nextcloud password>',
  'dbhost' => '172.24.0.7',
  'dbtableprefix' => 'oc_',
  'dbport' => '',
  'installed' => true,
  'check_data_directory_permissions' => false,
  'allow_local_remote_servers' => true,
  'onlyoffice' => array (
    'verify_peer_off' => true
)
);
```
Note: copy and insert not all values.

# Backup 
Moving all files in 1 folder and change access rights. 

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
Add user in group:
```
# Add our user in docker group 
sudo usermod -aG http $USER
# Apply access rights in group
newgrp http 
# Check user groups 
groups
# Change access rights for group 
sudo chown -R http:volokzhanin /mnt/0/backup/vvy_work_backup  
sudo chmod -R 774 /mnt/0/backup/vvy_work_backup 
```

[Сource  config](https://github.com/linuxlifepage/nextcloud).

# Smartphone
1. Nextcloud app for smartphone install via [FDroid](https://f-droid.org/).
1. App for syncing [DAVx⁵](https://www.davx5.com/tested-with/nextcloud) устанавливаем также через [FDroid](https://f-droid.org/).
1. App for two-factor authorization [FreeOTP+ ](https://f-droid.org/ru/packages/org.liberty.android.freeotpplus/). Install via [FDroid](https://f-droid.org/).

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
