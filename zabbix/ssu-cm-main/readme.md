[![CodeFactor](https://www.codefactor.io/repository/github/nulconaux/ssu-cm/badge)](https://www.codefactor.io/repository/github/nulconaux/ssu-cm) [![Lint Repository Source Code](https://github.com/nulconaux/ssu-cm/actions/workflows/linters.yml/badge.svg)](https://github.com/nulconaux/ssu-cm/actions/workflows/linters.yml) [![Sonar Cloud](https://github.com/nulconaux/ssu-cm/actions/workflows/sonarcloud.yml/badge.svg)](https://github.com/nulconaux/ssu-cm/actions/workflows/sonarcloud.yml)


<p align="center">
 <img src="https://user-images.githubusercontent.com/29449749/125477424-0a05ad03-20a0-4e6b-85e1-58b683d823df.png">
 <br><br>
 <a href="https://docs.google.com/presentation/d/1NmYV6Mon-ZOvfmNns8_j4nLCUwK3TS7aZPncHUZvncs/edit?usp=sharing">SSU Configuration Management: Packer & Ansible</a>
</p>

## Prepare

* Export samples
```bash
$ echo "export EDITOR=vim" >> ~/.bashrc
$ source ~/.bashrc
$ export AWS_PROFILE=
$ export AWS_ACCESS_KEY_ID=
$ export AWS_SECRET_ACCESS_KEY=
$ export AWS_DEFAULT_REGION=eu-west-1

$ echo "127.0.0.1" > ~ansible/inventory/hosts
$ export ANSIBLE_ANSIBLE_SSH_KEYDIR=`pwd`
$ export ANSIBLE_INVENTORY_ENABLED=amazon.aws.aws_ec2

$ ANSIBLE_PIPELINING(/etc/ansible/ansible.cfg) = True
$ DEFAULT_HOST_LIST(/etc/ansible/ansible.cfg) = ['/etc/ansible/hosts']
$ DEFAULT_REMOTE_USER(/etc/ansible/ansible.cfg) = myuser
$ RETRY_FILES_ENABLED(/etc/ansible/ansible.cfg) = False
$ ANSIBLE_VAULT_PASSWORD_FILE(/etc/ansible/ansible.cfg) =~/bin/ansible-vault-pass

$ export PACKER_LOG_PATH="packer.log"
$ export PACKER_LOG=1
```


* AWS Account and Cli

```bash
pip install awscli
aws configure --profile ssu-cm
export  AWS_PROFILE=ssu-cm
aws get-caller-identity
```


* [Packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli#installing-packer)

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
sudo cp /usr/bin/packer /usr/local/bin/packer
```

```bash
which packer
/usr/local/bin/packer
packer version
Packer v1.7.2
```

```
packer -autocomplete-install
```

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)


* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

[Install Ansible by using virtualenv](https://clouddocs.f5.com/products/orchestration/ansible/devel/usage/virtualenv.html)

```bash
$ sudo easy_install pip
$ sudo pip install -r ./requirements.txt
$ ansible --version
```

##  Troubleshooting SSH Connections
Sometimes when attempting an initial Ansible ping, it can fail in a very confusing way. If this happens, try adding something like this to your `~/.ssh/config` file:

```yaml
Host <hostname-prefix>*
  Port 22
  User <ssh-login-username>
  StrictHostKeyChecking=no
  UserKnownHostsFile=/dev/null
```

## Limiting Playbook/Task Runs
When writing Ansible, sometimes it is tedious to make a change in a playbook or task, then run the playbook It can sometimes be very helpful to run a module directly as shown above, but only against a single development host.

Limit to one or more hosts
This is required when one wants to run a playbook against a host group, but only against one or more members of that group.

Limit to one host

```sh
ansible-playbook playbooks/PLAYBOOK_NAME.yml --limit "host1"
```

Limit to multiple hosts

```sh
ansible-playbook playbooks/PLAYBOOK_NAME.yml --limit "host1,host2"
```

Negated limit. NOTE: Single quotes MUST be used to prevent bash interpolation.

```sh
ansible-playbook playbooks/PLAYBOOK_NAME.yml --limit 'all:!host1'
```

Limit to host group

```sh
ansible-playbook playbooks/PLAYBOOK_NAME.yml --limit 'group1'
```

## Limiting Tasks with Tags
Limit to all tags matching install

```sh
ansible-playbook playbooks/PLAYBOOK_NAME.yml --tags 'install'
```

Skip any tag matching sudoers

```sh
ansible-playbook playbooks/PLAYBOOK_NAME.yml --skip-tags 'sudoers'
```

Troubleshooting Ansible
http://docs.ansible.com/ansible/playbooks_checkmode.html


* Pre-commit

```bash
pip3 install pre-commit pre-commit-hooks setup-cfg-fmt
sudo apt install shellcheck
curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | sudo bash
pre-commit install
pre-commit run -a
```


Run GitHub SuperLinter localy
https://github.com/github/super-linter

```bash
export cm_repo_path=`pwd` \
    && echo "set cm_repo_path to $cm_repo_path" \
    && docker run -e RUN_LOCAL=true -v $cm_repo_path:/tmp/lint github/super-linter
```
