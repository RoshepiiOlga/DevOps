# Лабораторная работа 4: Поставщики упаковщиков (Provisioners)
Эта лабораторная работа проведет вас через добавление провайдера в ваш шаблон Packer HCL. Провайдеры используют встроенное и стороннее программное обеспечение для установки и настройки образа машины после загрузки.

Продолжительность: 30 минут

- Задача 1. Добавьте средство Packer Provisioner для установки всех обновлений и службы nginx.
- Задача 2: проверка шаблона упаковщика.
- Задача 3. Создайте новый образ с помощью Packer.
- Задача 4: установить веб-приложение.

### Задача 1. Обновить шаблон упаковщика для поддержки нескольких регионов.
Конструктор Packer AWS поддерживает возможность создания AMI в нескольких регионах AWS. AMI специфичны для регионов, поэтому это гарантирует, что один и тот же образ будет доступен во всех регионах в одном облаке. Мы также будем использовать теги для идентификации нашего изображения.

### Шаг 1.1.1

Убедитесь, что в вашем файле `aws-ubuntu.pkr.hcl` есть следующий блок Packer` source`.

```hcl
source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-ubuntu-aws-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  ami_regions   = ["us-west-2", "us-east-1", "eu-central-1"]
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags = {
    "Name"        = "MyUbuntuImage"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 16.04"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}
```

Добавьте провайдер в блок `builder` вашего` aws-ubuntu.pkr.hcl`

```hcl
build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }
}
```

### Задача 2: Проверка шаблона упаковщика
Шаблоны упаковщика можно автоматически форматировать и проверять через командную строку упаковщика.

### Шаг 2.1.1

Отформатируйте и проверьте конфигурацию с помощью команд packer fmt и packer validate.

```shell
packer fmt aws-ubuntu.pkr.hcl
packer validate aws-ubuntu.pkr.hcl
```

### Задача 3. Создайте новый образ с помощью Packer.
Команда packer build используется для запуска процесса сборки образа для данного шаблона Packer.

### Шаг 3.1.1
Запустите `packer build` для шаблона` aws-ubuntu.pkr.hcl`.

```shell
packer build aws-ubuntu.pkr.hcl
```

Packer распечатает выходные данные, аналогичные показанным ниже. Обратите внимание на подключение к SSH и предоставление обновлений и служб до того, как образ будет завершен.

```bash
amazon-ebs.ubuntu: output will be in this color.

==> amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu: Prevalidating AMI Name: packer-ubuntu-aws-*
    amazon-ebs.ubuntu: Found Image ID: ami-0dd273d94ed0540c0
==> amazon-ebs.ubuntu: Creating temporary keypair: packer_*
==> amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_*
==> amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups..
==> amazon-ebs.ubuntu: Launching a source AWS instance...
==> amazon-ebs.ubuntu: Adding tags to source instance
    amazon-ebs.ubuntu: Adding tag: "Name": "Packer Builder"
    amazon-ebs.ubuntu: Instance ID: i-*
==> amazon-ebs.ubuntu: Waiting for instance (i-*) to become ready...
==> amazon-ebs.ubuntu: Using ssh communicator to connect: 11.11.111.111
==> amazon-ebs.ubuntu: Waiting for SSH to become available...
==> amazon-ebs.ubuntu: Connected to SSH!
==> amazon-ebs.ubuntu: Provisioning with shell script: /tmp/packer-shell794569831
    amazon-ebs.ubuntu: Installing Updates
    amazon-ebs.ubuntu: Get:1 http://security.ubuntu.com/ubuntu xenial-security InRelease [109 kB]
    amazon-ebs.ubuntu: Hit:2 http://archive.ubuntu.com/ubuntu xenial InRelease
    amazon-ebs.ubuntu: Get:3 http://archive.ubuntu.com/ubuntu xenial-updates InRelease [109 kB]
    amazon-ebs.ubuntu: Get:4 http://security.ubuntu.com/ubuntu xenial-security/main amd64 Packages [1646 kB]
    amazon-ebs.ubuntu: Get:5 http://archive.ubuntu.com/ubuntu xenial-backports InRelease [107 kB]
    amazon-ebs.ubuntu: Get:6 http://archive.ubuntu.com/ubuntu xenial/universe amd64 Packages [7532 kB]
    amazon-ebs.ubuntu: Get:7 http://security.ubuntu.com/ubuntu xenial-security/universe amd64 Packages [786 kB]
    amazon-ebs.ubuntu: Get:8 http://security.ubuntu.com/ubuntu xenial-security/universe Translation-en [226 kB]
    amazon-ebs.ubuntu: Get:9 http://security.ubuntu.com/ubuntu xenial-security/multiverse amd64 Packages [7864 B]
    amazon-ebs.ubuntu: Get:10 http://security.ubuntu.com/ubuntu xenial-security/multiverse Translation-en [2672 B]
    amazon-ebs.ubuntu: Get:11 http://archive.ubuntu.com/ubuntu xenial/universe Translation-en [4354 kB]
    amazon-ebs.ubuntu: Get:12 http://archive.ubuntu.com/ubuntu xenial/multiverse amd64 Packages [144 kB]
    amazon-ebs.ubuntu: Get:13 http://archive.ubuntu.com/ubuntu xenial/multiverse Translation-en [106 kB]
    amazon-ebs.ubuntu: Get:14 http://archive.ubuntu.com/ubuntu xenial-updates/main amd64 Packages [2048 kB]
    amazon-ebs.ubuntu: Get:15 http://archive.ubuntu.com/ubuntu xenial-updates/main Translation-en [482 kB]
    amazon-ebs.ubuntu: Get:16 http://archive.ubuntu.com/ubuntu xenial-updates/universe amd64 Packages [1220 kB]
    amazon-ebs.ubuntu: Get:17 http://archive.ubuntu.com/ubuntu xenial-updates/universe Translation-en [358 kB]
    amazon-ebs.ubuntu: Get:18 http://archive.ubuntu.com/ubuntu xenial-updates/multiverse amd64 Packages [22.6 kB]
    amazon-ebs.ubuntu: Get:19 http://archive.ubuntu.com/ubuntu xenial-updates/multiverse Translation-en [8476 B]
    amazon-ebs.ubuntu: Get:20 http://archive.ubuntu.com/ubuntu xenial-backports/main amd64 Packages [9812 B]
    amazon-ebs.ubuntu: Get:21 http://archive.ubuntu.com/ubuntu xenial-backports/main Translation-en [4456 B]
    amazon-ebs.ubuntu: Get:22 http://archive.ubuntu.com/ubuntu xenial-backports/universe amd64 Packages [11.3 kB]
    amazon-ebs.ubuntu: Get:23 http://archive.ubuntu.com/ubuntu xenial-backports/universe Translation-en [4476 B]
    amazon-ebs.ubuntu: Fetched 19.3 MB in 8s (2362 kB/s)
    amazon-ebs.ubuntu: Reading package lists...
    amazon-ebs.ubuntu: Reading package lists...
    amazon-ebs.ubuntu: Building dependency tree...
    amazon-ebs.ubuntu: Reading state information...
    amazon-ebs.ubuntu: The following additional packages will be installed:
    amazon-ebs.ubuntu:   nginx-common nginx-light
    amazon-ebs.ubuntu: Suggested packages:
    amazon-ebs.ubuntu:   fcgiwrap nginx-doc ssl-cert
    amazon-ebs.ubuntu: The following NEW packages will be installed:
    amazon-ebs.ubuntu:   nginx nginx-common nginx-light
    amazon-ebs.ubuntu: 0 upgraded, 3 newly installed, 0 to remove and 10 not upgraded.
    amazon-ebs.ubuntu: Need to get 345 kB of archives.
    amazon-ebs.ubuntu: After this operation, 1,098 kB of additional disk space will be used.
    amazon-ebs.ubuntu: Get:1 http://security.ubuntu.com/ubuntu xenial-security/main amd64 nginx-common all 1.10.3-0ubuntu0.16.04.5 [26.9 kB]
    amazon-ebs.ubuntu: Get:2 http://security.ubuntu.com/ubuntu xenial-security/universe amd64 nginx-light amd64 1.10.3-0ubuntu0.16.04.5 [315 kB]
    amazon-ebs.ubuntu: Get:3 http://security.ubuntu.com/ubuntu xenial-security/main amd64 nginx all 1.10.3-0ubuntu0.16.04.5 [3,494 B]
==> amazon-ebs.ubuntu: debconf: unable to initialize frontend: Dialog
==> amazon-ebs.ubuntu: debconf: (Dialog frontend will not work on a dumb terminal, an emacs shell buffer, or without a controlling terminal.)
==> amazon-ebs.ubuntu: debconf: falling back to frontend: Readline
==> amazon-ebs.ubuntu: debconf: unable to initialize frontend: Readline
==> amazon-ebs.ubuntu: debconf: (This frontend requires a controlling tty.)
==> amazon-ebs.ubuntu: debconf: falling back to frontend: Teletype
==> amazon-ebs.ubuntu: dpkg-preconfigure: unable to re-open stdin:
    amazon-ebs.ubuntu: Fetched 345 kB in 0s (651 kB/s)
    amazon-ebs.ubuntu: Selecting previously unselected package nginx-common.
    amazon-ebs.ubuntu: (Reading database ... 51474 files and directories currently installed.)
    amazon-ebs.ubuntu: Preparing to unpack .../nginx-common_1.10.3-0ubuntu0.16.04.5_all.deb ...
    amazon-ebs.ubuntu: Unpacking nginx-common (1.10.3-0ubuntu0.16.04.5) ...
    amazon-ebs.ubuntu: Selecting previously unselected package nginx-light.
    amazon-ebs.ubuntu: Preparing to unpack .../nginx-light_1.10.3-0ubuntu0.16.04.5_amd64.deb ...
    amazon-ebs.ubuntu: Unpacking nginx-light (1.10.3-0ubuntu0.16.04.5) ...
    amazon-ebs.ubuntu: Selecting previously unselected package nginx.
    amazon-ebs.ubuntu: Preparing to unpack .../nginx_1.10.3-0ubuntu0.16.04.5_all.deb ...
    amazon-ebs.ubuntu: Unpacking nginx (1.10.3-0ubuntu0.16.04.5) ...
    amazon-ebs.ubuntu: Processing triggers for ureadahead (0.100.0-19.1) ...
    amazon-ebs.ubuntu: Processing triggers for systemd (229-4ubuntu21.31) ...
    amazon-ebs.ubuntu: Processing triggers for ufw (0.35-0ubuntu2) ...
    amazon-ebs.ubuntu: Processing triggers for man-db (2.7.5-1) ...
    amazon-ebs.ubuntu: Setting up nginx-common (1.10.3-0ubuntu0.16.04.5) ...
    amazon-ebs.ubuntu: debconf: unable to initialize frontend: Dialog
    amazon-ebs.ubuntu: debconf: (Dialog frontend will not work on a dumb terminal, an emacs shell buffer, or without a controlling terminal.)
    amazon-ebs.ubuntu: debconf: falling back to frontend: Readline
    amazon-ebs.ubuntu: Setting up nginx-light (1.10.3-0ubuntu0.16.04.5) ...
    amazon-ebs.ubuntu: Setting up nginx (1.10.3-0ubuntu0.16.04.5) ...
    amazon-ebs.ubuntu: Processing triggers for ureadahead (0.100.0-19.1) ...
    amazon-ebs.ubuntu: Processing triggers for systemd (229-4ubuntu21.31) ...
    amazon-ebs.ubuntu: Processing triggers for ufw (0.35-0ubuntu2) ...
==> amazon-ebs.ubuntu: Stopping the source instance...
    amazon-ebs.ubuntu: Stopping instance
==> amazon-ebs.ubuntu: Waiting for the instance to stop...
==> amazon-ebs.ubuntu: Creating AMI packer-ubuntu-aws-* from instance i-*
    amazon-ebs.ubuntu: AMI: ami-040bd66b2e79ccb64
==> amazon-ebs.ubuntu: Waiting for AMI to become ready...
==> amazon-ebs.ubuntu: Copying/Encrypting AMI (ami-*) to other regions...
    amazon-ebs.ubuntu: Copying to: eu-central-1
    amazon-ebs.ubuntu: Copying to: us-east-1
    amazon-ebs.ubuntu: Waiting for all copies to complete...
==> amazon-ebs.ubuntu: Adding tags to AMI (ami-*)...
==> amazon-ebs.ubuntu: Tagging snapshot: snap-*
==> amazon-ebs.ubuntu: Creating AMI tags
    amazon-ebs.ubuntu: Adding tag: "OS_Version": "Ubuntu 16.04"
    amazon-ebs.ubuntu: Adding tag: "Release": "Latest"
    amazon-ebs.ubuntu: Adding tag: "Created-by": "Packer"
    amazon-ebs.ubuntu: Adding tag: "Environment": "Production"
    amazon-ebs.ubuntu: Adding tag: "Name": "MyUbuntuImage"
==> amazon-ebs.ubuntu: Creating snapshot tags
==> amazon-ebs.ubuntu: Adding tags to AMI (ami-*)...
==> amazon-ebs.ubuntu: Tagging snapshot: snap-*
==> amazon-ebs.ubuntu: Creating AMI tags
    amazon-ebs.ubuntu: Adding tag: "Created-by": "Packer"
    amazon-ebs.ubuntu: Adding tag: "Environment": "Production"
    amazon-ebs.ubuntu: Adding tag: "Name": "MyUbuntuImage"
    amazon-ebs.ubuntu: Adding tag: "OS_Version": "Ubuntu 16.04"
    amazon-ebs.ubuntu: Adding tag: "Release": "Latest"
==> amazon-ebs.ubuntu: Creating snapshot tags
==> amazon-ebs.ubuntu: Adding tags to AMI (ami-*)...
==> amazon-ebs.ubuntu: Tagging snapshot: snap-*
==> amazon-ebs.ubuntu: Creating AMI tags
    amazon-ebs.ubuntu: Adding tag: "Name": "MyUbuntuImage"
    amazon-ebs.ubuntu: Adding tag: "OS_Version": "Ubuntu 16.04"
    amazon-ebs.ubuntu: Adding tag: "Release": "Latest"
    amazon-ebs.ubuntu: Adding tag: "Created-by": "Packer"
    amazon-ebs.ubuntu: Adding tag: "Environment": "Production"
==> amazon-ebs.ubuntu: Creating snapshot tags
==> amazon-ebs.ubuntu: Terminating the source AWS instance...
==> amazon-ebs.ubuntu: Cleaning up any extra volumes...
==> amazon-ebs.ubuntu: No volumes to clean up, skipping
==> amazon-ebs.ubuntu: Deleting temporary security group...
==> amazon-ebs.ubuntu: Deleting temporary keypair...
Build 'amazon-ebs.ubuntu' finished after 8 minutes 45 seconds.

==> Wait completed after 8 minutes 45 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.ubuntu: AMIs were created:
eu-central-1: ami-*
us-east-1: ami-*
us-west-2: ami-*
```


### Задача 4: Установить веб-приложение

#### Шаг 4.1.1
Скопируйте ресурсы веб-приложения в рабочий каталог нашего упаковщика.

```bash
mkdir assets
cp -R /workstation/terraform/assets/ .
```

#### Step 4.1.2
Замените существующий блок builder в вашем aws-ubuntu.pkr.hcl приведенным ниже кодом. Это добавит инициализатор `file` и дополнительный провайдер` shell`.

```hcl
build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update",
    ]
  }

  provisioner "file" {
    source      = "assets"
    destination = "/tmp/"
  }

   provisioner "shell" {
    inline = [
      "sudo sh /tmp/assets/setup-web.sh",
    ]
  }
}
```

Отформатируйте и проверьте конфигурацию с помощью команд packer fmt и packer validate.

```shell
packer fmt aws-ubuntu.pkr.hcl
packer validate aws-ubuntu.pkr.hcl
```

Запустите `packer build` для шаблона` aws-ubuntu.pkr.hcl`.

```shell
packer build aws-ubuntu.pkr.hcl
```
