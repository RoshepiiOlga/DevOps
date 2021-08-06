# Лабораторная работа 3: Создание изображений в нескольких регионах
В этой лабораторной работе вы узнаете, как обновить шаблон Packer Template для создания образов в нескольких регионах AWS.

Продолжительность: 30 минут

- Задача 1. Обновить шаблон упаковщика для поддержки нескольких регионов.
- Задача 2: проверка шаблона упаковщика.
- Задача 3. Создание образа в нескольких регионах AWS.

### Задача 1. Обновить шаблон упаковщика для поддержки нескольких регионов.
Конструктор Packer AWS поддерживает возможность создания AMI в нескольких регионах AWS. AMI специфичны для регионов, поэтому это гарантирует, что один и тот же образ будет доступен во всех регионах в одном облаке. Мы также будем использовать теги для идентификации нашего изображения.

### Шаг 1.1.1

Обновите ваш файл `aws-ubuntu.pkr.hcl` следующим блоком Packer` source`.

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

### Задача 2: Проверка шаблона упаковщика
Шаблоны упаковщика можно автоматически форматировать и проверять через командную строку упаковщика.

### Шаг 2.1.1

Отформатируйте и проверьте конфигурацию с помощью команд packer fmt и packer validate.

```shell
packer fmt aws-ubuntu.pkr.hcl
packer validate aws-ubuntu.pkr.hcl
```

### Задача 3. Создание образа в нескольких регионах AWS
Команда packer build используется для запуска процесса сборки образа для данного шаблона Packer.

### Шаг 3.1.1
Запустите `packer build` для шаблона` aws-ubuntu.pkr.hcl`.

```shell
packer build aws-ubuntu.pkr.hcl
```

Packer распечатает выходные данные, аналогичные показанным ниже.

```bash
➜  packer build aws-ubuntu.pkr.hcl
amazon-ebs.ubuntu: output will be in this color.

==> amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu: Prevalidating AMI Name: packer-ubuntu-aws
    amazon-ebs.ubuntu: Found Image ID: ami-*
==> amazon-ebs.ubuntu: Creating temporary keypair: packer_*
==> amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_*
==> amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs.ubuntu: Launching a source AWS instance...
==> amazon-ebs.ubuntu: Adding tags to source instance
    amazon-ebs.ubuntu: Adding tag: "Name": "Packer Builder"
    amazon-ebs.ubuntu: Instance ID: i-*
==> amazon-ebs.ubuntu: Waiting for instance (i-*) to become ready...
==> amazon-ebs.ubuntu: Using ssh communicator to connect: 11.111.111.111
==> amazon-ebs.ubuntu: Waiting for SSH to become available...
==> amazon-ebs.ubuntu: Connected to SSH!
==> amazon-ebs.ubuntu: Stopping the source instance...
    amazon-ebs.ubuntu: Stopping instance
==> amazon-ebs.ubuntu: Waiting for the instance to stop...
==> amazon-ebs.ubuntu: Creating AMI packer-ubuntu-aws from instance i-*
    amazon-ebs.ubuntu: AMI: ami-*
==> amazon-ebs.ubuntu: Waiting for AMI to become ready...
==> amazon-ebs.ubuntu: Copying/Encrypting AMI (ami-*) to other regions...
    amazon-ebs.ubuntu: Copying to: us-east-1
    amazon-ebs.ubuntu: Copying to: eu-central-1
    amazon-ebs.ubuntu: Waiting for all copies to complete...
==> amazon-ebs.ubuntu: Adding tags to AMI (ami-*)...
==> amazon-ebs.ubuntu: Tagging snapshot: snap-*
==> amazon-ebs.ubuntu: Creating AMI tags
    amazon-ebs.ubuntu: Adding tag: "Name": "MyUbuntuImage"
    amazon-ebs.ubuntu: Adding tag: "Version": "Latest"
    amazon-ebs.ubuntu: Adding tag: "Environment": "Production"
==> amazon-ebs.ubuntu: Creating snapshot tags
==> amazon-ebs.ubuntu: Adding tags to AMI (ami-*)...
==> amazon-ebs.ubuntu: Tagging snapshot: snap-*
==> amazon-ebs.ubuntu: Creating AMI tags
    amazon-ebs.ubuntu: Adding tag: "Environment": "Production"
    amazon-ebs.ubuntu: Adding tag: "Name": "MyUbuntuImage"
    amazon-ebs.ubuntu: Adding tag: "Version": "Latest"
==> amazon-ebs.ubuntu: Creating snapshot tags
==> amazon-ebs.ubuntu: Adding tags to AMI (ami-*)...
==> amazon-ebs.ubuntu: Tagging snapshot: snap-*
==> amazon-ebs.ubuntu: Creating AMI tags
    amazon-ebs.ubuntu: Adding tag: "Environment": "Production"
    amazon-ebs.ubuntu: Adding tag: "Name": "MyUbuntuImage"
    amazon-ebs.ubuntu: Adding tag: "Version": "Latest"
==> amazon-ebs.ubuntu: Creating snapshot tags
==> amazon-ebs.ubuntu: Terminating the source AWS instance...
==> amazon-ebs.ubuntu: Cleaning up any extra volumes...
==> amazon-ebs.ubuntu: No volumes to clean up, skipping
==> amazon-ebs.ubuntu: Deleting temporary security group...
==> amazon-ebs.ubuntu: Deleting temporary keypair...
Build 'amazon-ebs.ubuntu' finished after 8 minutes 39 seconds.

==> Wait completed after 8 minutes 39 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.ubuntu: AMIs were created:
eu-central-1: ami-*
us-east-1: ami-*
us-west-2: ami-*
```

Обратите внимание, что теперь мы создали такое же изображение в регионах «eu-central-1», «us-east-1» и «us-west-2».

##### Resources
* Packer [Docs](https://www.packer.io/docs/index.html)
* Packer [CLI](https://www.packer.io/docs/commands/index.html)
