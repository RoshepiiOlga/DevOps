# Лабораторная работа 2: Packer CLI
Интерфейс командной строки Packer (CLI) - это то, как пользователи/приложения взаимодействуют с Packer. Для Packer нет пользовательского интерфейса или API.

Продолжительность: 15 минут

- Задача 1. Изучите интерфейс командной строки Packer.
- Задача 2: Версия упаковщика
- Задача 3: включить автозаполнение для Packer CLI.
- Задача 4: изучить подкоманды и флаги.
- Задача 5: Packer fmt

### Задача 1. Использование интерфейса командной строки Packer для получения справки

Выполните следующую команду, чтобы отобразить доступные команды:

```bash
packer -help
```

```bash
Usage: packer [--version] [--help] <command> [<args>]

Available commands are:
    build           build image(s) from template
    console         creates a console for testing variable interpolation
    fix             fixes templates from old versions of packer
    fmt             Rewrites HCL2 config files to canonical format
    hcl2_upgrade    transform a JSON template into an HCL2 configuration
    init            Install missing plugins or upgrade plugins
    inspect         see components of a template
    validate        check that a template is valid
    version         Prints the Packer version
```

Или вы можете использовать сокращение:

```shell
packer -h
```

### Задача 2: Версия упаковщика
Выполните следующую команду, чтобы проверить версию Packer:

```shell
packer -version
```

You should see:

```bash
packer -version
1.7.2
```

Мы будем строить конфигурацию Packer с использованием HCL. Ваша версия Packer должна быть новее 1.7.0, чтобы использовать конфигурацию HCL. Если ваша версия старше 1.7.0, переустановите Packer с более новой версией.

### Задача 3: включить автозаполнение для Packer CLI
Команда packer включает автозаполнение подкоманды opt-in, которое вы можете включить для своей оболочки с помощью `packer -autocomplete-install`. После этого вы можете вызвать новую оболочку и использовать эту функцию.

```bash
packer -autocomplete-install
```

Если автозаполнение уже было включено, эта команда укажет, что оно уже установлено.

### Задача 4: изучить подкоманды и флаги
Подобно многим другим инструментам командной строки, инструмент упаковщика принимает для выполнения подкоманду, и эта подкоманда также может иметь дополнительные параметры. Подкоманды выполняются упаковщиком SUBCOMMAND, где «SUBCOMMAND» - это фактическая команда, которую вы хотите выполнить.

Вы можете запустить любую команду упаковщика с флагом -h, чтобы вывести более подробную справку по конкретной подкоманде.

```bash
packer validate -h
```

```bash
Usage: packer validate [options] TEMPLATE

   Проверяет правильность шаблона, анализируя шаблон, а также
   проверка конфигурации с различными сборщиками, провайдерами и т. д.

   Если он недействителен, будут показаны ошибки, и команда завершится с ненулевым статусом выхода.
   Если он действителен, он выйдет с нулемвым статусом выхода.

Options:

  -syntax-only           Only check syntax. Do not verify config of the template.
  -except=foo,bar,baz    Validate all builds other than these.
  -machine-readable      Produce machine-readable output.
  -only=foo,bar,baz      Validate only these builds.
  -var 'key=value'       Variable for templates, can be used multiple times.
  -var-file=path         JSON or HCL2 file containing user variables.
```

```bash
packer validate aws-ubuntu.pkr.hcl
```

### Задача 5: упаковщик fmt
Команда packer fmt Packer используется для форматирования файлов конфигурации HCL2 в канонический формат и стиль. Файлы JSON (.json) не изменяются. packer fmt отобразит имя файла (ов) конфигурации, нуждающегося в форматировании, и запишет все отформатированные изменения обратно в исходный файл (ы) конфигурации.

```bash
packer fmt -diff aws-ubuntu.pkr.hcl
```

Если в результате выполнения команды `packer fmt` произошли отформатированные изменения, эти изменения будут выделены при указании флага` -diff`.
```
aws-ubuntu.pkr.hcl
--- old/aws-ubuntu.pkr.hcl
+++ new/aws-ubuntu.pkr.hcl
@@ -6,9 +6,9 @@
     filters = {
       name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
       root-device-type    = "ebs"
-    virtualization-type = "hvm"
+      virtualization-type = "hvm"
     }
-        most_recent = true
+    most_recent = true
     owners      = ["099720109477"]
   }
   ssh_username = "ubuntu"
```

### Задача 5: Осмотр упаковщика
Команда `packer inspect` показывает все компоненты шаблона Packer, включая переменные, сборки, источники, средства обеспечения и постпроцессоры.

```bash
packer inspect aws-ubuntu.pkr.hcl
```

```bash
Packer Inspect: HCL2 mode

> input-variables:


> local-variables:


> builds:

  > <unnamed build 0>:

    sources:

      amazon-ebs.ubuntu

    provisioners:

      <no provisioner>

    post-processors:

      <no post-processor>
```

Обратите внимание, что в настоящее время в нашей конфигурации нет никаких переменных, инициаторов или постпроцессоров. Мы добавим эти элементы в будущих лабораторных работах.
