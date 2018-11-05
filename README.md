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

if [ -f /.startup_script_completed ]; then
    exit 0
fi

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo \"deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse\" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

apt update
apt install -y mongodb-org ruby-full ruby-bundler build-essential

systemctl start mongod.service
systemctl enable mongod.service

git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
puma -d

touch /.startup_script_completed"
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
testapp_IP = 35.204.144.232
testapp_port = 9292
```

## Homework #5
### Что было сделано
* Выполнено домашнее задание
* Выполнена самостоятельная работа
* Выполнено задание со *
### Как запустить проект:
Выполнить команды:
```
cd packer/
cp variables.json.example variables.json
```
В файле variables.json заполнить project_id.
Выполните команды для сборки образов:
```
packer build -var-file=variables.json ubuntu16.json
packer build -var-file=variables.json immutable.json
```
Выполните команду для запуска инстанса:
```
cd ../config-scripts/
./create-redditvm.sh
```
### Как проверить работоспособность:
 - Перейти по ссылке http://<EXTERNAL_IP>:9292

## Homework #6
### Задание со *
#### Добавление нескольких ключей к проекту
```
resource "google_compute_project_metadata" "default" {
  metadata {
    ssh-keys = <<EOF
    appuser:${file(var.public_key_path)}
    appuser1:${file(var.public_key_path)}EOF
  }
}
```
##### Обратите внимание
* Завершающая директива EOF не должна находиться на новой строке. Иначе в GCP будет создана пустая запись в секции SSH Keys.
* Использование EOF не нравится пакету tfint!
* Все добавленные ключи в секцию SSH Keys через WEB-интерфейс, которые не учтены в конфигурации Terraform - будут удалены.
### Задание с **
#### Обратите внимание
* Балансировка происходит между двумя независимымы инстансами, не имеющих единую базу данных. Поэтому в случае выключения первого инстанса, данные с него будут не доступны на втором инстансе.

## Homework #7
### Задание со *
Для выполнения задания был создан вручную Google Cloud Storage Bucket. После чего разной конфигурацией файлов backend.tf состояние terraform было вынесено в каталоги terrarorm/stage и terraform/prod соответственно.
#### Одновременное выполнение terraform apply с одним state файлом
В результате получаем ошибку:
```
$ terraform apply
Acquiring state lock. This may take a few moments...

Error: Error locking state: Error acquiring the state lock: writing "gs://webdl-tf-state/terraform/stage/default.tflock" failed: googleapi: Error 412: Precondition Failed, conditionNotMet
Lock Info:
  ID:        1541373424497035
  Path:      gs://webdl-tf-state/terraform/stage/default.tflock
  Operation: OperationTypeApply
  Who:       ubuntu@home-pc-win8
  Version:   0.11.10
  Created:   2018-11-04 23:17:05.4240959 +0000 UTC
  Info:


Terraform acquires a state lock to protect the state from being written
by multiple users at the same time. Please resolve the issue above and try
again. For most commands, you can disable locking with the "-lock=false"
flag, but this is not recommended.
```
