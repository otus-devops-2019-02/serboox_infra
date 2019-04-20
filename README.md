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

# HW8.Практика Infrastructure as a Code (IaC).
1) Создал ветку terraform-1 в infra репе
2) Удалил SSH ключ appuser из метаданных проекта
3) Засетапил terraform и google provider
4) Поднял инстанс на terraform
5) Добавил public key для доступа на инстанс через SSH
6) Создал файл *outputs.tf* для отображения переменных
7) Определил firewall rule *firewall_puma* для GCP VPC Network
8) Добавил тег "reddit-app" к инстансу
9) Добавил два provisioners файла для создания service в systemd и деплоя свежей верии приложения https://github.com/express42/reddit.git
10) Определил connection параметры для работы provisioner команд
11) Определил input переменные в файле *variables.tf* и terraform.tfvars
12) Определил input переменную "private_key_path" для приватного ключа
13) Определил input переменную "zone" для задания зоны
14) Отформатировал все файлы с помощью
``` bash
    terraform fmt ./..
```
P.S. Terraform extension для Vscode итак все форматировал)
15) Создал файл *terraform.tfvars.example*
16) * Добавил в поле ssh-keys ключи для appuser1 и appuser2. Вывод консоли показывал change однако ~/.ssh/authorized_keys содержал лишь один ключ, а войти на инстанс используя логин appuser1 невозможно т.к. в системе есть только appuser
``` bash
    appuser@reddit-app:~/.ssh$ users
    appuser
```
17) Добавил в metadata публичный ключ appuser_web, команда terraform apply показала:
``` bash
    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```
Вероятно ключ добавляется лишь на этапе создания инстанса.

# HW9.Принципы организации инфраструктурного кода и работа над инфраструктурой в команде на примере Terraform.
1) Создал ветку terraform-2
2) Создал ресурс firewall_ssh
3) Создал ресурс для статического IP и сделал привязку к ресурсу app
4) Используя packer и образ ubuntu-16.04 создал два образа reddit-db-* и reddit-app-*
5) Разбил конфигурацию по файлам
6) Перенес конфигурацию в два модуля: app и db
7) Создал модуль vpc
8) Создал две папки с конфигурацией для двух вариантов окружений: prod и stage
9) Попробовал создать backet при помощи модуля storage-bucket взятого из registry
10) Перенес terraform stage в GCP backet, проверил его работоспособность из другой директории и работу лока.

# HW10.Управление конфигурацией.
1) Создал ветку ansible-1
2) Создал файлы *inventory* и *ansible.cfg*
3) Выполнил несколько команд используя модули *ping*, *command*, *shell*, *git*, *systemd*, *service*
4) У меня не получалось сделать git clone, через -m command и  через playbook т.к. в provisioners у packer все скрипты выполнялись под sudo:
``` json
    {
        "type": "shell",
        "script": "scripts/deploy_reddit.sh",
        "execute_command": "sudo {{.Path}}"
    }
```
После,
``` bash
    ansible app -m command -a 'sudo rm -rf ~/reddit'
```
все заработало)

# HW11.Продолжение знакомства с Ansible: templates, handlers, dynamic inventory, vault, tags.
> Лучше напишу с чем столкнулся)
1) Когда делал
``` bash
    ansible-playbook reddit_app.yml --limit app --tags deploy-tag
```
 cтолкнулся с тем, что мой app image был запровиженен в том числе с ./packer/scripts/deploy_reddit.sh, поэтому необходимо было писать дополнительные таски, в первую очередь для удаления репозитерия, а во вторую для остановки работающего reddit application. К сожалению
``` bash
    sudo systemctl stop reddit
```
не останавливал приложение и 9292 порт продолжал быть занят. Поэтому пришлось придумывать дополнительный workaround
``` yaml
  tasks:
    - name: Stopped and disabled reddit unit in systemcd
        systemd:
        name: reddit
        state: stopped
        enabled: no
        register: service_reddit_status

    - name: Kill reddit process
        shell: "lsof -t -i:9292 | xargs kill -9"
        when: service_reddit_status.changed == True
```
При первом прогоне когда status.changed был True, старое приложение убивалось, а во последующих нет, это в итоге позволило сохранить идемпотентность)
2) При билде images с использованием packer получил вот это:
```
    ==> googlecompute: Timeout waiting for SSH.
```
Потом вспомнил, что мы через terraform убиваем доступ к 22 порту для default networks. Это исправило положение:
``` bash
    cd ./terraform/stage
    terraform apply -target=module.vpc
```
3) Когда доступ к ssh был получен возникли новые сложности) Packer не желал билдить image сославшись на это:
```
    googlecompute:  [WARNING]: Updating cache and auto-installing missing dependency: python-apt
    googlecompute: fatal: [default]: FAILED! => {"changed": false, "cmd": "apt-get update", "msg": "E: Could not get lock /var/lib/apt/lists/lock - open (11: Resource temporarily unavailable)\nE: Unable to lock directory /var/lib/apt/lists/", "rc": 100, "stderr": "E: Could not get lock /var/lib/apt/lists/lock - open (11: Resource temporarily unavailable)\nE: Unable to lock directory /var/lib/apt/lists/\n", "stderr_lines": ["E: Could not get lock /var/lib/apt/lists/lock - open (11: Resource temporarily unavailable)", "E: Unable to lock directory /var/lib/apt/lists/"], "stdout": "Reading package lists...\n", "stdout_lines": ["Reading package lists..."]}
```
Видимо provisioning каких-то внутренних компонентов гугла давал лок на apt, поэтому пришлост придумывать вот такой workaround:

``` yaml
    - name: Wait for automatic system updates
      wait_for: path=/var/lib/apt/lists/lock state=absent
```
or
``` yaml
    - name: Clean dpkg lock file
      file:
        state: absent
        path: /var/lib/apt/lists/lock
```
Но в итоге все отвисло и перестало выдавать ошибку)
