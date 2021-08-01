variable "ami_prefix" {
  type    = string
  default = "my-ubuntu"
}

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

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  ami_regions   = var.ami_regions
  access_key    = "AKIA2MZKXLEWXTICON73"
  secret_key    = "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"
  #  vpc_id        = "vpc-003b5c6a"
  #  subnet_id     = "subnet-9e55dcd2"

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

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    inline = [
      "echo Installing Updates",
      "sudo apt-get update"
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
  post-processor "manifest" {}
}