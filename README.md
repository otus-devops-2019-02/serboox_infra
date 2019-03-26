# serboox_infra
serboox Infra repository

# Подключение к VM
#### Для локального подключения к someinternalhost из можно использовать команду
``` bash
ssh -A -J serboox@gcp-bastion serboox@10.132.0.3
```
> А ip адрес для **gcp-bastion** указать в поле HostName файла ~/.ssh/config

IP адреса виртуальных машин:
``` text
bastion_IP = 35.195.211.230
someinternalhost_IP = 10.132.0.3
```
