# serboox_infra
serboox Infra repository

# HW5.Знакомство с облачной инфраструктурой и облачными сервисами. 
#### Для локального подключения к someinternalhost можно использовать команду
``` bash
ssh -A -J serboox@gcp-bastion serboox@10.132.0.3
```
> А ip адрес для **gcp-bastion** указать в поле HostName файла ~/.ssh/config

IP адреса виртуальных машин:
``` text
bastion_IP = 35.195.211.230
someinternalhost_IP = 10.132.0.3
```

# HW6.Основные сервисы Google Cloud Platform (GCP).
Для получения готового инстанса с express42/reddit на борту следует использовать команду:
``` bash
gcloud compute instances create reddit-app-2 \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--metadata-from-file startup-script=install.sh \
--restart-on-failure
```

IP адреса виртуальных машин:
``` text
testapp_IP = 35.228.155.241
testapp_port = 9292
```

# HW7.Модели управления инфраструктурой.
* Подготовлен шаблон ubuntu16.json для Packer.
* На основании шаблона ubuntu16.json создан custom image.
* Подготовлен immutable.json для Packer. Build образа можно запустить командой:
``` bash
packer build -var-file=variables.json immutable.json
```
* На основании шаблона immutable.json создан custom image.
* Подготовлен script file create-reddit-vm.sh для создания инстанса на основании image-family=reddit-full.
``` bash
#!/bin/bash
set -e

# Create instance with
gcloud compute instances create reddit-app-7 \
--boot-disk-size=10GB \
--image-family=reddit-full \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure
```
