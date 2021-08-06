# Лабораторная работа 7. Создание образов для различных операционных систем.
Эта лабораторная работа проведет вас через обновление шаблона Packer Template для создания разных образов для каждой операционной системы.

Продолжительность: 15 минут

- Задача 1. Обновить шаблон упаковщика для поддержки нескольких сборок операционной системы.
- Задача 2: проверка шаблона упаковщика.
- Задача 3. Создание образов для разных операционных систем.

### Задача 1. Обновление шаблона упаковщика для поддержки нескольких операционных систем.
Компоновщик Packer AWS поддерживает возможность создания AMI для нескольких операционных систем. Исходные AMI специфичны для развертываемой операционной системы, поэтому нам нужно будет указать уникальный источник для каждого уникального образа операционной системы.

### Шаг 1.1.1

Добавьте следующие блоки в файл `aws-ubuntu.pkr.hcl` со следующим блоком Packer` source`.

```hcl
source "amazon-ebs" "centos" {
  ami_name      = "packer-centos-aws-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  ami_regions   = ["us-west-2"]
  source_ami_filter {
    filters = {
      name                = "CentOS Linux 7 x86_64 HVM EBS *"
      product-code        = "aw0evgkw8e5c1q413zgy5pjce"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["679593333241"]
  }
  ssh_username = "centos"
  tags = {
    "Name"        = "MyCentosImage"
    "Environment" = "Production"
    "OS_Version"  = "Centos 7"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}
```

Добавьте отдельный блок сборки для создания образа `centos` с использованием источника `source.amazon-ebs.centos`.

```hcl
build {
  name = "centos"
  sources = [
    "source.amazon-ebs.centos"
  ]

  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo yum -y update",
      "sudo yum install -y epel-release",
      "sudo yum install -y nginx"
    ]
  }

  post-processor "manifest" {}

}
```

### Задача 2: Проверка шаблона упаковщика
Переименуйте шаблоны упаковщика `aws-ubuntu.pkr.hcl` в` aws-linux.pkr.hcl`, поскольку теперь он поддерживает несколько разновидностей Linux. Этот шаблон можно автоматически форматировать и проверять с помощью командной строки Packer.

### Шаг 2.1.1

Отформатируйте и проверьте конфигурацию с помощью команд packer fmt и packer validate.

```shell
packer fmt aws-linux.pkr.hcl
packer validate aws-linux.pkr.hcl
```

### Задача 3. Создайте новый образ с помощью Packer.
Команда packer build используется для запуска процесса сборки образа для данного шаблона Packer.

### Шаг 3.1.1
Запустите `packer build` для шаблона `aws-linux.pkr.hcl`.

```shell
> packer build aws-linux.pkr.hcl
```

Packer распечатает результат, аналогичный показанному ниже..

```bash
amazon-ebs.ubuntu: output will be in this color.
centos.amazon-ebs.centos: output will be in this color.
==> amazon-ebs.ubuntu: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu: Prevalidating AMI Name: my-ubuntu-*
==> centos.amazon-ebs.centos: Prevalidating any provided VPC information
==> centos.amazon-ebs.centos: Prevalidating AMI Name: packer-centos-aws-*
    amazon-ebs.ubuntu: Found Image ID: ami-0ee02acd56a52998e
==> amazon-ebs.ubuntu: Creating temporary keypair: packer_*
==> amazon-ebs.ubuntu: Creating temporary security group for this instance: packer_*
==> amazon-ebs.ubuntu: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups..
==> amazon-ebs.ubuntu: Launching a source AWS instance...
==> amazon-ebs.ubuntu: Adding tags to source instance
    amazon-ebs.ubuntu: Adding tag: "Name": "Packer Builder"
...
Build 'amazon-ebs.ubuntu' finished after 8 minutes 38 seconds.
==> centos.amazon-ebs.centos: Adding tags to AMI (ami-*)...
==> centos.amazon-ebs.centos: Tagging snapshot: snap-*
==> centos.amazon-ebs.centos: Creating AMI tags
    centos.amazon-ebs.centos: Adding tag: "Environment": "Production"
    centos.amazon-ebs.centos: Adding tag: "Name": "MyCentosImage"
    centos.amazon-ebs.centos: Adding tag: "OS_Version": "Centos 7"
    centos.amazon-ebs.centos: Adding tag: "Release": "Latest"
    centos.amazon-ebs.centos: Adding tag: "Created-by": "Packer"
==> centos.amazon-ebs.centos: Creating snapshot tags
==> centos.amazon-ebs.centos: Terminating the source AWS instance...
==> centos.amazon-ebs.centos: Cleaning up any extra volumes...
==> centos.amazon-ebs.centos: Destroying volume (vol-*)...
==> centos.amazon-ebs.centos: Deleting temporary security group...
==> centos.amazon-ebs.centos: Deleting temporary keypair...
==> centos.amazon-ebs.centos: Running post-processor:  (type manifest)
Build 'centos.amazon-ebs.centos' finished after 12 minutes 54 seconds.

==> Wait completed after 12 minutes 54 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.ubuntu: AMIs were created:
eu-central-1: ami-*
us-east-1: ami-*
us-west-2: ami-*

--> amazon-ebs.ubuntu: AMIs were created:
eu-central-1: ami-*
us-east-1: ami-*
us-west-2: ami-*

--> centos.amazon-ebs.centos: AMIs were created:
us-west-2: ami-*

--> centos.amazon-ebs.centos: AMIs were created:
us-west-2: ami-*
```
