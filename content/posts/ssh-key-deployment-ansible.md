+++
date = "2015-08-05T14:58:53+05:30"
title = "Automating ssh key deployment in Rails apps with Ansible"
+++

> Reposted from [SupportBee's Dev Blog](https://devblog.supportbee.com/2015/08/05/automate-ssh-key-deployment-with-ansible/)

I decided to automate ssh key management on servers last week, after having done it manually for a couple of days. I typically used Capistrano to automate server configuration but had been searching for a tool which had a declarative style and works over SSH (just like Capistrano). Fortunately, I found Ansible via a friend’s tweet.

Ansible is written in python and easiest way to install it is with pip (a package manager for python packages).

```
pip install ansible
```
or
```
pip install ansible==1.9.2 # I used Ansible 1.9.2 at the time of writing
```

Once installed, a user can describe the setup he’d like to have on his servers by writing an Ansible script (Ansible calls them playbooks). These playbooks are just YAML files. Here’s a playbook I wrote for the Rails servers at work to automate ssh key management. It adds ssh keys of current employees and removes ssh keys of interns and former employees. Copy the playbook and edit it according to your needs.

{{< highlight yaml >}}
# MyRailsApp/config/ansible/maintain_ssh_keys.yml
---
- hosts: all
  remote_user: deploy # Login in as deploy user
  tasks:
  - name: setup ssh keys
    authorized_key:
      user: deploy # Configure ssh keys for deploy user
      key: |
        ssh-rsa AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA john@gmail.com
        ssh-rsa BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB jane@Jane-Does-iMac.local
  - name: remove ssh keys of former employees 
    authorized_key:
      user: deploy # Configure ssh keys for deploy user
      key: |
        ssh-rsa CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC jack@gmail.com
        ssh-rsa DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD jill@gmail.com
      state: absent
{{< /highlight >}}

Ansible will need the ip addresses or hostnames of your servers. Add a file which lists all your servers. Ansible calls this the inventory file.

```
; MyRailsApp/config/ansible/production
web1.mysite.com
web2.mysite.com
db.mysite.com
```

Run the playbook and the ssh keys should be setup on your servers.

```
cd MyRailsApp/config/ansible/
ansible-playbook -i production maintain_ssh_keys.yml
```

If you wish to know more about Ansible, [Ansible documentation](http://docs.ansible.com/ansible/index.html#) is a good place to start. There are also a lot of Ansible playbooks on GitHub to borrow configuration from.
