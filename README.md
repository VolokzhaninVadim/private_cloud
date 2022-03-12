![Nextcloud_Logo.svg](https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Nextcloud_Logo.svg/113px-Nextcloud_Logo.svg.png)
# Вход 
Заходим для регистрации: `http://172.24.0.5`

# Создаем базу данных
```
# Получаем container id 
docker ps
# Заходим в контейнер 
docker exec -it container_id   bash
```

Взодим в postgres: `psql -U postgres` и выполняем:
```
CREATE DATABASE nextcloud TEMPLATE template0 ENCODING 'UNICODE';
create user nextcloud with encrypted password 'PASSWORD';
ALTER DATABASE nextcloud OWNER TO nextcloud;
GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud;
\q
```
На странице аутентификации ввести учетные данные базы данных. 

# Proxy
```
sudo rm -rf ./proxy/conf.d/my_custom_proxy_settings.conf
sudo touch ./proxy/conf.d/my_custom_proxy_settings.conf
sudo nano  ./proxy/conf.d/my_custom_proxy_settings.conf 
```
Вставляем: `client_max_body_size 5000m;`

# Редактируем конфиг
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
Копироват и вставлять не все значения.

# Onlyoffice
Устанавливаем: [ONLYOFFICE](https://apps.nextcloud.com/apps/onlyoffice). 

![only_office.png](https://upload.wikimedia.org/wikipedia/commons/d/d9/Logo_light_tl.png)

Адрес службы редактирования документов: `ONLYOFFICE_http://IP/`.
Секретный ключ (оставьте пустым для отключения): вставляем ключ из docker-compose. 

# Backup 
Перемещаем все файлы в целевую папку и изменяем права. 
```
# Получаем container id 
docker ps
# Заходим в контейнер 
docker exec -it container_id   bash
# Переходим в папку
cd data/volokzhanin/files
# Смотрим права 
ls -la
# Меняем права у необходимой папке 
chown -R www-data:www-data /var/www/html/
chown -R www-data:www-data /external_storage/
```
Добавляем в группу пользователя: 
```
# Добавляем нашего пользователя в группу docker
sudo usermod -aG http $USER
# Активируем изменения в группе
newgrp http 
# Проверяем группы пользователя 
groups
# Изменяем права для группы
sudo chown -R http:volokzhanin /mnt/0/backup/vvy_work_backup  
sudo chmod -R 774 /mnt/0/backup/vvy_work_backup 
```

Исходный конфиг взял [отсюда](https://github.com/linuxlifepage/nextcloud).

# Смартфон
Приложение Nextcloud для смартфона устанавливаем через [FDroid](https://f-droid.org/).

# FAQ
## Разблокировка пользователя 
`docker exec -u 33 container_id ./occ user:enable volokzhanin`

## Сбросить пароль пользователя 
```
# Заходим в контейнер
docker exec -it --user 33 <docker id> bash
# Сбрасываем пароль
php occ user:resetpassword YOUR_USER
```

## Fix ошибки в transmisiion "Unable to save resume file: Permission denied"
```
# Получаем container id 
docker ps
# Заходим в контейнер 
docker exec -it container_id   bash
# Изменяем права
chown -R abc:users /downloads
```
## Fix ошибки "Слишком много попыток авторизации":
```
# Входим в docker pg nextcloud
docker exec -ti pg-server /bin/bash

# Запустим psql
psql -U db_user -W --dbname=cloud_db

# Проверим, сколько записей в таблице
select count(*) from oc_bruteforce_attempts;

# Очистищаем таблицу	
truncate oc_bruteforce_attempts RESTART IDENTITY;
```
