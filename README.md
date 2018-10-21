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
#### Данные для подключения
```
testapp_IP = 35.204.144.232
testapp_port = 9292 
```
