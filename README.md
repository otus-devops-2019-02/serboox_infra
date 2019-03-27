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
