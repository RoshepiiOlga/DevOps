# About

Packer template example that creates Ubuntu 20.04 image for VirtualBox with baked Consul 1.10.0 in it.

## Prerequisites

- [VirtualBox](https://www.virtualbox.org)
- [Packer](https://www.packer.io)

## Build

 `packer build ubuntu-consul-template.json`

Few minutes later `output-ubuntu-consul` directory will contain VirtualBox OVF file, which can be imported into VirtualBox as new VM.

Login and password for it is `ubuntu`.
