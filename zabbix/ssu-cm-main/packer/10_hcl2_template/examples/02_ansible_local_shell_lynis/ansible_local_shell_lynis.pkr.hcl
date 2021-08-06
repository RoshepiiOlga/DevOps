# -*- mode: utf-8 -*-
# vi: ft=pkr.hcl.packer

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "base_ami" {
  type    = string
  default = "ami-07563b76f95e4dc63"
}

variable "instance_size" {
  type    = string
  default = "t4g.micro"
}

variable "subnet_id" {
  type    = string
  default = "subnet-e1f651bb"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  ami_name = "amazon-linux-2-arm-${local.timestamp}"
}

source "amazon-ebs" "aws" {
  ami_name                    = local.ami_name
  ami_regions                 = [var.aws_region]
  ami_virtualization_type     = "hvm"
  associate_public_ip_address = true
  ebs_optimized               = true
  ena_support                 = true
  force_delete_snapshot       = true
  force_deregister            = true
  instance_type               = var.instance_size
  region                      = var.aws_region
  run_tags = {
    role = "packer"
  }
  source_ami   = var.base_ami
  ssh_username = "ec2-user"
  subnet_id    = var.subnet_id
  tags = {
    Name    = local.ami_name
    Purpose = "base image"
    Tool    = "Packer"
  }
}

build {
  sources = ["source.amazon-ebs.aws"]

  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo amazon-linux-extras install ansible2",
      "sudo yum install -y python3-pip ansible"]
  }

  provisioner "ansible-local" {
    galaxy_file = "../ansible/requirements.yml"
    playbook_file           = "../ansible/run_playbook.yaml"
    role_paths              = ["../ansible/roles"]
    playbook_dir            = "../../ansible"
    clean_staging_directory = true
  }

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /opt/lynis && cd /opt/lynis",
      "sudo  git clone https://github.com/CISOfy/lynis .",
      "echo '\nlynis Results:\n'",
      "sudo chown -R 0:0 /opt/lynis/",
      "sudo bash /opt/lynis/lynis audit system --reverse-colors --verbose"
    ]
  }

}

## https://github.com/mablanco/ansible-lynis
