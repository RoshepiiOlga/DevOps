# What is Ansible in DevOps?

In DevOps, as we know development and operations work is integrated. This integration is very important for modern test-driven application design. Hence, Ansible integrates this by providing a stable environment to both development and operations resulting in smooth orchestration.

Let us discuss now how Ansible manages the entire DevOps infrastructure. When developers begin to think of infrastructure as part of their application i.e as Infrastructure as code (IaC), stability and performance become normative. Infrastructure as Code is the process of managing and provisioning computing infrastructure (processes, bare-metal servers, virtual servers, etc.) and their configuration through machine-processable definition files, rather than physical hardware configuration or the use of interactive configuration tools. This is where Ansible automation plays a major role and stands out among its peers.

In DevOps, Sysadmins work tightly with developers, development velocity is improved, and more time is spent doing activities like performance tuning, experimenting, and getting things done, and less time is spent fixing problems.

Managing an organization’s many tools and business processes is becoming increasingly complicated as technology expands. Whether your teams are performing their weekly system reboot, or looking to configure instances to a desired state, it’s no secret that automation is critical to increase speed, efficiency, productivity, and accuracy. Listed below are several instances where automation can help across your enterprise.


- Weekly system reboot: There’s nothing worse than doing the same thing for 8 hours a day! Eliminate repetitive, manual processes with automation.
- Enforce security guidelines: Rules are rules. It’s best to automate in an effort to achieve strict security standards.
- Monitor configuration drift: Use check mode with Ansible tasks to enforce desired settings and see if your configuration has drifted.
- Disaster recovery: Disaster recovery can involve a wide range of components. Act across different variables of the technology stack to identify problems and eliminate cross team dependencies.
- Command blaster: Remarkably easy to write, you can run commands across your environment for any number of servers.
- Database binary patching: Several databases use outdated binary sets. Patch the binaries in accordance with the release of the latest patch.
- Instance provisioning: Use modules for several cloud providers to create new instances and tailor their configuration.
- Service license agreements: Mistakes cost time and money. Eliminate errors that can crop up in detailed software contracts.

## Use Cases Examples

### Security Patching

Ansible is an incredibly powerful and robust configuration management system. My favorite feature? Its simplicity. This can be seen by how easy it is to patch vulnerable servers.

#### Shellshock

The following playbook was run against 100+ servers and patched the bash vulnerability in less than 10 minutes. The below example updates both Debian and Red Hat Linux variants. It will first run on half of all the hosts that are defined in an inventory file.


``` yaml
- hosts: all
  gather_facts: yes
  remote_user: craun
  serial: "50%"
  sudo: yes
  tasks:
    - name: Update Shellshock (Debian)
      apt: name=bash
           state=latest
           update_cache=yes
      when: ansible_os_family == "Debian"

    - name: Update Shellshock (RedHat)
      yum: name=bash
           state=latest
           update_cache=yes
      when: ansible_os_family == "RedHat"
```

#### Heartbleed and SSH

The following playbook was run against 100+ servers patching the HeartBleed vulnerability. At the time, I also noticed that the servers needed an updated version of OpenSSH. The below example updates both Debian and RedHat linux variants. It will patch and reboot 25% of the servers at a time until all of the hosts defined in the inventory file are updated.

```yaml
- hosts: all
  gather_facts: yes
  remote_user: craun
  serial: "25%"
  sudo: yes
  tasks:
    - name: Update OpenSSL and OpenSSH (Debian)
      apt: name={{ item }}
           state=latest
           update_cache=yes
      with_items:
        - openssl
        - openssh-client
        - openssh-server
      when: ansible_os_family == "Debian"

    - name: Update OpenSSL and OpenSSH (RedHat)
      yum: name={{ item }}
           state=latest
           update_cache=yes
      with_items:
        - openssl
        - openssh-client
        - openssh-server
      when: ansible_os_family == "RedHat"
  post_tasks:
    - name: Reboot servers
      command: reboot
```

### Everything Else
Ansible has many more use cases than I have mentioned in this article so far, like provisioning cloud infrastructure, deploying application code, managing SSH keys, configuring databases, and setting up web servers.

## Why do we like Ansible?
Ansible helps in modeling the cloud IT infrastructure with a description of inter-relation between all systems. Ansible does not implement any agents or additional custom security infrastructure. Furthermore, Ansible also offers flexibility for deployment and uses the simple YAML language in its Playbooks. Therefore, the user could easily describe automation jobs in simple English.

## Advantages of Ansible
- Easy and Understandable: Ansible is very simple and easy to understand and has a very simple syntax that can be used by human-readable data serialization language. It is very good for beginners to understand especially for those who design infrastructure.
- Powerful and Versatile: it is a very powerful and versatile tool that helps in real orchestration and manages the entire application or configuration management environment.
- Efficient: It is very efficient in the sense it can be customized according to your need like modules can be called with the help of a playbook for where the applications are deployed.
- Agentless: Completely independent tool without the use of third-party vendors or agent’s software and agentless.
- Provisioning: Applications in need of orchestration get a total aid from ansible as it helps in provisioning of resources according to the need of the project requirement.
- Application Deployment: Easy for teams to manage the entire lifecycle from development to deployment.
- Orchestration: ONAP orchestration and all cloud-native platforms very well make use of ansible tool in its use.
- Secured: Security is the key to maintain the ansible infrastructure as all applications require it to get applications free from security breaches.

## Disadvantages of Ansible

Here are couple of what I can think of at the moment:

- OS restrictions: Ansible is OS dependent, code working for one OS will not necessarily work for others, apart from that, you can’t use a windows box as your Management Server.
- Once a playbook is running, you can’t add or remove hosts from the inventory file (Terraform has the ability to do this), this can be crucial if your use case is such that you have a real time code which generates IP addresses where the same script is supposed to run. This holds true for variables too, i.e. you can’t add variables to global vars file at runtime.
- Ansible makes fresh connections to remote hosts for each and every module it executes. (In an ansible script modules couple with tasks), the disadvantage of this is that making so many connection attempts makes it prone to connection failures. And one connection failure can put the execution of the entire play in jeopardy.
- If you compute some variable at run-time, and want to reuse it across hosts, Ansible does not provide a direct/simple way to do it, you need to go through a lot of pain to be able to do it. You need to literally copy that value to all desired hosts.
- Running Ansible script manually is one thing, but I assume anyone picking up ansible is aiming for more than that, i.e. invocation level automation(a piece of code invoking ansible playbook for you): ansible does support this, but the last time I checked, that library was available only for python, also here’s a thing: couple of things that work for manually invoked ansible just don’t work in invoked version, like delegate_to feature, verbose logging etc.
- Error reporting isn’t great to say the least. If your playbook fails because of some syntax issue, ansible points you to the line number and adds a generic syntax issue msg. You need to figure out where exactly the issue is, is it a semi colon or parenthesis or space. This can be frustrating.



# Ansible

Ansible is a radically simple IT automation engine that automates cloud provisioning, configuration management, application deployment, intra-service orchestration, and many other IT needs.

Being designed for multi-tier deployments since day one, Ansible models your IT infrastructure by describing how all of your systems interrelate, rather than just managing one system at a time.

It uses no agents and no additional custom security infrastructure, so it’s easy to deploy - and most importantly, it uses a very simple
language (YAML, in the form of Ansible Playbooks) that allow you to describe your automation jobs in a way that approaches plain English.

No other client software is installed on the node machines. It uses SSH to connect to the nodes. Ansible only needs to be installed on the control machine (the machine from which you will be running commands) which can even be your laptop. It is a simple solution to a complicated problem.

## Ansible Terms
- Controller Machine: The machine where Ansible is installed, responsible for running the provisioning on the servers you are managing.
- Inventory: An initialization file that contains information about the servers you are managing.
- Playbook: The entry point for Ansible provisioning, where the automation is defined through tasks using YAML format.
- Task: A block that defines a single procedure to be executed, e.g. Install a package.
- Module: A module typically abstracts a system task, like dealing with packages or creating and changing files. Ansible has a multitude of built-in modules, but you can also create custom ones.
- Role: A predefined way for organizing playbooks and other files in order to facilitate sharing and reusing portions of a provisioning.
- Play: A provisioning executed from start to finish is called a play. In simple words, execution of a playbook is called a play.
- Facts: Global variables containing information about the system, like network interfaces or operating system.
- Handlers: Used to trigger service status changes, like restarting or stopping a service.


## Ansible Architecture

Ansible works by connecting to your nodes and pushing out small programs, called "Ansible modules" to them. These programs are written to be resource models of the desired state of the system. Ansible then executes these modules (over SSH by default), and removes them when finished.


Your library of modules can reside on any machine, and there are no servers, daemons, or databases required. Typically, you'll work with your favorite terminal program, a text editor, and probably a version control system to keep track of changes to your content.

In this section, we’ll give you a really quick overview of how Ansible works so you can see how the pieces fit together.

- Modules
- Module utilities
- Plugins
- Inventory
- Playbooks
- The Ansible search path

### Modules

Ansible works by connecting to your nodes and pushing out scripts called “Ansible modules” to them. Most modules accept parameters that describe the desired state of the system. Ansible then executes these modules (over SSH by default), and removes them when finished. Your library of modules can reside on any machine, and there are no servers, daemons, or databases required.

You can write your own modules, though you should first consider whether you should. Typically you’ll work with your favorite terminal program, a text editor, and probably a version control system to keep track of changes to your content. You may write specialized modules in any language that can return JSON (Ruby, Python, bash, and so on).
Module utilities

When multiple modules use the same code, Ansible stores those functions as module utilities to minimize duplication and maintenance. For example, the code that parses URLs is lib/ansible/module_utils/url.py. You can write your own module utilities as well. Module utilities may only be written in Python or in PowerShell.

### Plugins

Plugins augment Ansible’s core functionality. While modules execute on the target system in separate processes (usually that means on a remote system), plugins execute on the control node within the /usr/bin/ansible process.
Plugins offer options and extensions for the core features of Ansible - transforming data, logging output, connecting to inventory, and more.

Ansible ships with a number of handy plugins, and you can easily write your own. For example, you can write an inventory plugin to connect to any datasource that returns JSON. Plugins must be written in Python.

### Inventory

By default, Ansible represents the machines it manages in a file (INI, YAML, and so on) that puts all of your managed machines in groups of your own choosing.

To add new machines, there is no additional SSL signing server involved, so there’s never any hassle deciding why a particular machine didn’t get linked up due to obscure NTP or DNS issues.

If there’s another source of truth in your infrastructure, Ansible can also connect to that. Ansible can draw inventory, group, and variable information from sources like EC2, Rackspace, OpenStack, and more.
Here’s what a plain text inventory file looks like:

```ini
---
[webservers]
www1.example.com
www2.example.com

[dbservers]
db0.example.com
db1.example.com
```


Once inventory hosts are listed, variables can be assigned to them in simple text files (in a subdirectory called ‘group_vars/’ or ‘host_vars/’ or directly in the inventory file.

Or, as already mentioned, use a dynamic inventory to pull your inventory from data sources like EC2, Rackspace, or OpenStack.

### Playbooks

Playbooks can finely orchestrate multiple slices of your infrastructure topology, with very detailed control over how many machines to tackle at a time. This is where Ansible starts to get most interesting.
Ansible’s approach to orchestration is one of finely-tuned simplicity, as we believe your automation code should make perfect sense to you years down the road and there should be very little to remember about special syntax or features.
Here’s what a simple playbook looks like:

```yaml
---
- hosts: webservers
  serial: 5 # update 5 machines at a time
  roles:
  - common
  - webapp

- hosts: content_servers
  roles:
  - common
  - content
```


### The Ansible search path

Modules, module utilities, plugins, playbooks, and roles can live in multiple locations. If you write your own code to extend Ansible’s core features, you may have multiple files with similar or the same names in different locations on your Ansible control node. The search path determines which of these files Ansible will discover and use on any given playbook run.

Ansible’s search path grows incrementally over a run. As Ansible finds each playbook and role included in a given run, it appends any directories related to that playbook or role to the search path. Those directories remain in scope for the duration of the run, even after the playbook or role has finished executing. Ansible loads modules, module utilities, and plugins order.

Directories adjacent to a playbook specified on the command line. If you run Ansible with ansible-playbook /path/to/play.yml, Ansible appends these directories if they exist:

- /path/to/modules
- /path/to/module_utils
- /path/to/plugins
- Directories adjacent to a playbook that is statically imported by a playbook specified on the command - line. If play.yml includes - import_playbook: /path/to/subdir/play1.yml, Ansible appends these - directories if they exist:
- /path/to/subdir/modules
- /path/to/subdir/module_utils
- /path/to/subdir/plugins
- Subdirectories of a role directory referenced by a playbook. If play.yml runs myrole, Ansible appends - these directories if they exist:
- /path/to/roles/myrole/modules
- /path/to/roles/myrole/module_utils
- /path/to/roles/myrole/plugins
- Directories specified as default paths in ansible.cfg or by the related environment variables, including - the paths for the various plugin types. See Ansible Configuration Settings for more information. Sample - ansible.cfg fields:
- DEFAULT_MODULE_PATH
- DEFAULT_MODULE_UTILS_PATH
- DEFAULT_CACHE_PLUGIN_PATH
- DEFAULT_FILTER_PLUGIN_PATH
- Sample environment variables:
- ANSIBLE_LIBRARY
- ANSIBLE_MODULE_UTILS
- ANSIBLE_CACHE_PLUGINS
- ANSIBLE_FILTER_PLUGINS
- The standard directories that ship as part of the Ansible distribution.
