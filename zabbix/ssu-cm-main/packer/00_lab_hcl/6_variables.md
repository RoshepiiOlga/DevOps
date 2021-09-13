# Лабораторная работа 6: Управление секретами сборок упаковщика

Продолжительность: 35 минут

- Задача 1: добавить переменный блок
- Задача 2: добавить локальный блок
- Задача 3: обновить шаблон упаковщика для использования переменных.
- Задача 4: создать образ с переменными.
- Задача 5: создать образ с помощью файла переменных.
- Задача 6: создать образ с флагом командной строки.
- Задача 7. Измените всю конфигурацию вашего пакера.

### Переменные упаковщика
Пользовательские переменные Packer позволяют дополнительно настраивать ваши шаблоны с использованием переменных из командной строки, переменных среды, хранилища или файлов. Это позволяет вам параметризовать ваши шаблоны, чтобы вы могли хранить секретные токены, данные, относящиеся к среде, и другие типы информации из ваших шаблонов. Это максимизирует переносимость шаблона.

Значения переменных можно установить несколькими способами:

- Значения по умолчанию
- Встраивание с использованием параметра `-var`
- Через файл переменных и указав параметр `-var-file`

```bash
-var 'key=value'       Variable for templates, can be used multiple times
-var-file=path         JSON or HCL2 file containing user variables
```

### Задача 1: Добавить переменный блок
Чтобы установить пользовательскую переменную, вы должны определить ее либо в определении переменной вашего шаблона, либо с помощью флагов командной строки «-var» или «-var-file». Блоки переменных предоставляются в шаблоне конфигурации Packer для определения переменных.


Добавьте следующий блок переменных в ваш файл `aws-ubuntu.pkr.hcl`.

```hcl
variable "ami_prefix" {
  type    = string
  default = "my-ubuntu"
}
```

Блоки переменных объявляют имя переменной (ami_prefix), тип данных (строка) и значение по умолчанию (my-ubuntu). Хотя тип переменной и значения по умолчанию не являются обязательными, мы рекомендуем вам определять эти атрибуты при создании новых переменных.


### Task 2: Add a local variable block

Добавьте следующий блок локальной переменной в ваш файл `aws-ubuntu.pkr.hcl`.

```hcl
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}
```

Локальные блоки объявляют имя локальной переменной (метку времени) и значение (regex_replace (timestamp (), «[- TZ:]», «»)). Вы можете установить любое локальное значение, включая другие переменные и локальные переменные. Локальные переменные полезны, когда вам нужно отформатировать часто используемые значения.

### Задача 3: Обновить шаблон упаковщика для использования переменных
В шаблоне Packer обновите исходный блок, чтобы он ссылался на переменную ami_prefix. Обратите внимание, как шаблон ссылается на переменную как на `var.ami_prefix`

```hcl
 ami_name      = "${var.ami_prefix}-${local.timestamp}"
```

### Задача 4: Создайте новый образ с помощью Packer
Отформатируйте и проверьте свою конфигурацию с помощью команд packer fmt и packer validate.
```bash
packer fmt aws-ubuntu.pkr.hcl
packer validate aws-ubuntu.pkr.hcl
```

```bash
packer build aws-ubuntu.pkr.hcl
```

### Задача 5. Создайте новое изображение с помощью файла переменных.
Создайте файл с именем `example.pkrvars.hcl` и добавьте в него следующий фрагмент.

```hcl
ami_prefix = "my-ubuntu-var"
```

Создайте образ с флагом `--var-file`.

```bash
packer build --var-file=example.pkrvars.hcl aws-ubuntu.pkr.hcl
```


Packer автоматически загрузит любой файл переменных, который соответствует имени * .auto.pkrvars.hcl, без необходимости передавать файл через командную строку.

Переименуйте файл переменных, чтобы Packer автоматически загружал его.
```bash
mv example.pkrvars.hcl example.auto.pkrvars.hcl
```

```bash
packer build .
```

### Задача 6. Создайте новый образ с флагом командной строки.

```bash
packer build --var ami_prefix=my-ubuntu-var-flag .
```

### Задача 7. Измените всю конфигурацию упаковщика.

Добавьте следующие блоки переменных:

```hcl
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_regions" {
  type    = list(string)
  default = ["us-west-2", "us-east-1", "eu-central-1"]
}

variable "tags" {
  type = map(string)
  default = {
    "Name"        = "MyUbuntuImage"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 16.04"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}
```

Обновите свой блок `source`, чтобы использовать определенные переменные

```hcl
source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  ami_regions   = var.ami_regions
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
  tags         = var.tags
}
```

Отформатируйте и проверьте конфигурацию после замены элементов с помощью переменных.

```bash
packer fmt aws-ubuntu.pkr.hcl
packer validate aws-ubuntu.pkr.hcl
```
