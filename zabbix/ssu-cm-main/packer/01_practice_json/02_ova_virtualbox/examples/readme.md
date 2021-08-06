## Prepare local Debian 10 OVA image

1. Grab an [debian-10.*.*-amd64-netinst.iso](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/) from official site
2. Create VM in VirtualBox with this image mounted as CD
3. During a setup specify local user `test` with password `test`. This image would never be exposed and
would be used locally for Ansible configuration debugging.
4. Run resulting VM, login, install `sudo`, modify `/etc/sudoers` to not ask for password for `sudo` group, and
add user `test` to group `sudo`

```
usermod -a -G sudo test
echo "%sudo ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/sudo-group
```

5. Shutdown VM and export it to OVA v.2 format as `debian-local.ova`
6. Put resulting OVA image to this directory so packer configuration can reference it

## AWS Debian 10 images

[Debian Buster](https://wiki.debian.org/Cloud/AmazonEC2Image/Buster)

## Example

```
packer build base-vbox.json
AWS_PROFILE=ssu-cm packer build base.json
```

[VirtualBox Builder (from an ISO)](https://www.packer.io/docs/builders/virtualbox/iso)
