# Лабораторная работа: Написать шаблон упаковщика
Эта лабораторная работа проведет вас через обновление шаблона Packer HCL. Он использует исходный код amazon-ebs для создания пользовательского образа в регионе AWS us-west-2.

Продолжительность: 5 минут

- Задача 1. Создание исходного блока.
- Задача 2: Проверка шаблона упаковщика.
- Задача 3: Создание строительного блока.
- Задача 4. Создайте новый образ с помощью Packer.

## Создание шаблона упаковщика

```bash
mkdir packer_templates
cd packer_templates
```

### Задача 1: Создать исходный блок
Исходные блоки определяют, какой тип виртуализации использовать для изображения, как запустить изображение и как подключиться к нему. Источники можно использовать в нескольких сборках. Мы будем использовать исходную конфигурацию `amazon-ebs` для запуска AMI `t2.micro` в регионе `eu-west-2`.
### Шаг 1.1.1

Создайте файл `aws-ubuntu.pkr.hcl` со следующим блоком `source`.
Найдите более новую версию базового AMI.

```hcl
source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-ubuntu-aws-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-west-2"
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
}
```

### Задача 2: Проверить шаблон упаковщика
Шаблоны упаковщика можно автоматически форматировать и проверять через командную строку упаковщика.

### Шаг 2.1.1

Отформатируйте и проверьте свою конфигурацию с помощью команд `packer fmt` и `packer validate`.

```shell
packer fmt aws-ubuntu.pkr.hcl
packer validate aws-ubuntu.pkr.hcl
```

### Задача 3: Создайте Блок Builders
Builders несут ответственность за создание машин и создание из них образов для различных платформ. Они используются вместе с исходным блоком в шаблоне.

### Шаг 3.1.1
Добавьте блок Builders в `aws-ubuntu.pkr.hcl` со ссылкой на источник, указанный выше. На источник можно ссылаться, используя синтаксис интерполяции HCL.

```hcl
build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}
```

### Задача 4: Создайте новый образ с помощью Packer
Команда `packer build` используется для запуска процесса сборки образа для данного шаблона Packer. Обратите внимание, что для этой лабораторной работы вам потребуются учетные данные для вашей учетной записи AWS, чтобы правильно выполнить сборку упаковщика. Вы можете установить свои учетные данные, используя [переменные среды](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html#linux), используя [aws configure](https://docs.aws.amazon.com/cli/latest/reference/configure/), если у вас установлен AWSCLI, или [вставьте учетные данные](https://www.packer.io/docs/builders/amazon/ebsvolume#access-configuration) в шаблоне.

### Шаг 4.1.1
Запустите `packer build` для шаблона` aws-ubuntu.pkr.hcl`.

```shell
packer build aws-ubuntu.pkr.hcl
```

Packer покажет аналогичное показанному ниже.

```bash
amazon-ebs.ubuntu: output will be in this color.

==> amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu: Prevalidating AMI Name: packer-ubuntu-aws-*
    amazon-ebs.ubuntu: Found Image ID: ami-*
==> amazon-ebs.ubuntu: Creating temporary keypair: packer_*
==> amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_609bdf00-c182-00a1-e516-32aea832ff9e
==> amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs.ubuntu: Launching a source AWS instance...
==> amazon-ebs.ubuntu: Adding tags to source instance
    amazon-ebs.ubuntu: Adding tag: "Name": "Packer Builder"
    amazon-ebs.ubuntu: Instance ID: i-*
==> amazon-ebs.ubuntu: Waiting for instance (i-*) to become ready...
==> amazon-ebs.ubuntu: Using ssh communicator to connect: 11.111.11.11
==> amazon-ebs.ubuntu: Waiting for SSH to become available...
==> amazon-ebs.ubuntu: Connected to SSH!
==> amazon-ebs.ubuntu: Stopping the source instance...
    amazon-ebs.ubuntu: Stopping instance
==> amazon-ebs.ubuntu: Waiting for the instance to stop...
==> amazon-ebs.ubuntu: Creating AMI packer-ubuntu-aws-* from instance i-*
    amazon-ebs.ubuntu: AMI: ami-*
==> amazon-ebs.ubuntu: Waiting for AMI to become ready...
==> amazon-ebs.ubuntu: Terminating the source AWS instance...
==> amazon-ebs.ubuntu: Cleaning up any extra volumes...
==> amazon-ebs.ubuntu: No volumes to clean up, skipping
==> amazon-ebs.ubuntu: Deleting temporary security group...
==> amazon-ebs.ubuntu: Deleting temporary keypair...
Build 'amazon-ebs.ubuntu' finished after 3 minutes 16 seconds.

==> Wait completed after 3 minutes 16 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.ubuntu: AMIs were created:
us-west-2: ami-*
```

** Примечание. ** В этой лабораторной работе предполагается, что в вашей учетной записи доступен VPC по умолчанию. Если вы этого не сделаете, вам нужно будет добавить [`vpc_id`](https://www.packer.io/docs/builders/amazon/ebs#vpc_id) и [`subnet_id`](https://www.packer.io/docs/builders/amazon/ebs#subnet_id). Подсеть должна иметь общий доступ и действующий маршрут к Интернет-шлюзу.

##### Ресурсы
* Packer [Docs](https://www.packer.io/docs/index.html)
* Packer [CLI](https://www.packer.io/docs/commands/index.html)
