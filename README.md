# webdl_infra
webdl Infra repository

## Homework #3
### Подключение к хосту someinternalhost в одну строку
#### Добавляем ключ к ssh агенту (делается один раз после старта системы)
```
cd ~/Documents/otus/
ssh-add id_rsa_export.ppk
```
Если во время добавления ключа появляется ошибка `Could not open a connection to your authentication agent.`, то перед использованием команды `ssh-add` введите команду:
```
eval `ssh-agent -s`
```

#### Подключаемся к someinternalhost через bastion instanse
После предварительной настройки можно проводить подключение:
```
ssh -A -t tk@35.204.92.194 ssh 10.164.0.3
```

### Настройка подключения к someinternalhost с использованием alias
Откройте на редактирование файл `/etc/ssh/ssh_config`:
```
sudo vim /etc/ssh/ssh_config
```
Добавьте в конец файла следующие настройки:
```
Host someinternalhost
   User tk
   Port 22
   HostName 10.164.0.3
   ProxyCommand ssh -t tk@35.204.92.194 nc %h %p
```
Проверьте работу с помощью команды `ssh someinternalhost`, должно быть выполнено подключение к someinternalhost.

### Подключение к VPN-серверу
#### Описание
Подключение осуществялется с помощью клиента OpenVPN. Панель управления VPN-серверов расположена по адресу: https://pritunl.35.204.92.194.nip.io

#### Данные для подключения
```
bastion_IP = 35.204.92.194
someinternalhost_IP = 10.164.0.3
```
## Homework #4
### Команды для запуска инстанса VM
#### С использованием startup-script
```
gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure \
--zone europe-west4-a \
--metadata startup-script="#! /bin/bash
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo \"deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse\" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

apt update
apt install -y mongodb-org ruby-full ruby-bundler build-essential

systemctl start mongod.service
systemctl enable mongod.service

git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
puma -d"
```
#### С использованием startup-script-url
```
gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure \
--zone europe-west4-a \
--metadata startup-script-url='https://raw.githubusercontent.com/Otus-DevOps-2018-09/webdl_infra/master/startup_script.sh'
```
### Создание правила для Firewall через gcloud
```
gcloud compute firewall-rules create default-puma-server --action allow --target-tags puma-server --source-ranges 0.0.0.0/0 --rules tcp:9292
```
### Данные для подключения
```
testapp_IP = 35.204.234.7
testapp_port = 9292
```

