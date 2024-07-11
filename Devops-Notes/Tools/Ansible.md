

### How does Ansible work?**
- SSH or WinRM
- YAML-based 
- agentless architecture
- push based 

### What is an Ansible playbook?**
- YAML file that contains a series of tasks

### What are the advantages of using Ansible?**
- **Agentless**: .
- **Simple syntax**:
- **Idempotent**
- **Extensible**:
- **Declarative**:

## **Intermediate Ansible Interview Questions**

### What is Ansible Galaxy?**
Ansible Galaxy is a repository for sharing Ansible roles. 

### How do you handle errors in Ansible?**
Errors in Ansible can be handled using:
- **ignore_errors**: Allows the playbook to continue even if a task fails.
- **failed_when**: Custom conditions
- **rescue**: Blocks to define tasks to run if a task fails.
- **always**:

### What is Ansible Vault?**
Ansible Vault is a feature that allows you to encrypt sensitive data such as passwords, keys, and other secrets within Ansible playbooks. 

###  How does the Ansible synchronize module work?**
The synchronize module is a wrapper around rsync to synchronize files and directories between the local machine and remote hosts.

### How does the Ansible firewalld module work?**
The firewalld module manages firewall rules on systems using firewalld. It allows you to add, remove, and configure firewall rules

### What is Ansible Tower?**
Ansible Tower is an enterprise framework for controlling, securing, and managing Ansible automation.

### How do you perform rolling updates using Ansible?**
To perform rolling updates, you can divide the **servers into batches and execute playbook tasks sequentially** on each batch. Use the `serial` keyword to control the number of hosts updated at a time and `delegate_to` to manage dependencies between tasks.

### Explain the key Ansible terms: Inventory, Modules, Roles, and Handlers.**
- **Inventory**: A list of hosts and groups of hosts on which Ansible commands and playbooks operate.
- **Modules**: Reusable, standalone scripts that Ansible runs on remote hosts. Examples include `apt`, `yum`, `copy`, and `template`.
- **Roles**: A way to organize playbooks into reusable components. 
- Roles can include tasks, variables, files, templates, and handlers.
- **Handlers**: Special tasks that are triggered by other tasks using the `notify` directive


### How do you upgrade Ansible?**

```sh
sudo pip install ansible==<version-number>
```

### How to turn off the facts in Ansible?**
`gather_facts: no` 

```yaml
- hosts: all
  gather_facts: no
  tasks:
    - name: Example task
      command: echo "Hello, World!"
```

Alternatively, you can disable fact gathering globally by setting `gathering = explicit` in the `ansible.cfg` file:

```ini
[defaults]
gathering = explicit
```

### How are variables merged in Ansible?**
Variables in Ansible are merged based on the precedence rules. By default, variables defined later override earlier ones. You can use the `hash_behaviour` setting in `ansible.cfg` to control how dictionaries are merged.

```ini
[defaults]
hash_behaviour = merge
```

This setting allows you to merge dictionaries instead of overriding them. For example:

```yaml
# group_vars/all.yml
common_vars:
  key1: value1

# group_vars/webservers.yml
common_vars:
  key2: value2
```

With `hash_behaviour = merge`, the `common_vars` dictionary will contain both `key1` and `key2`.

### What are Cache Plugins in Ansible? Any idea how they are enabled?**
Cache plugins in Ansible allow you to store gathered facts or inventory data to improve performance. 
- The default cache plugin is `memory`, which only caches data for the current execution.
- Persistent cache plugins like `jsonfile`, `redis`, and `memcached` can store data across runs.

To enable a cache plugin, you can set it in the `ansible.cfg` file:

```ini
[defaults]
fact_caching = jsonfile
fact_caching_connection = /path/to/cache/file
```


### What are Registered Variables in Ansible?**
Registered variables are used to capture the output of a task and store it in a variable for later use. They are defined using the `register` keyword.

```yaml
- name: Check if a file exists
  stat:
    path: /path/to/file
  register: file_stat

- name: Print file existence
  debug:
    msg: "File exists: {{ file_stat.stat.exists }}"
```

### How do Network Modules work in Ansible?**
Network modules in Ansible are used to manage network devices. They gather information and configure devices using various protocols like SSH, NETCONF, and REST APIs. 
```yaml
- name: Configure a Cisco IOS device
  cisco.ios.ios_config:
    lines:
      - hostname Router1
      - interface GigabitEthernet0/1
      - ip address 192.168.1.1 255.255.255.0
```

### **20. How does Ansible manage multiple communication protocols?**
Ansible manages multiple communication protocols using connection plugins. The `ansible_connection` variable specifies the connection type, such as `ssh`, `winrm`, `local`, or `network_cli`.

Example inventory file specifying different connection types:

```ini
[linux]
server1 ansible_connection=ssh

[windows]
server2 ansible_connection=winrm

[network]
router1 ansible_connection=network_cli ansible_network_os=ios
```

## **Intermediate Ansible Questions**

### **1. How to handle different machines needing different user accounts or ports to log in with using Ansible?**
You can specify different user accounts and ports in the inventory file or using group variables.

Example inventory file:

```ini
[webservers]
web1 ansible_user=admin ansible_port=2222
web2 ansible_user=root ansible_port=22
```

### **2. How to see a list of all Ansible variables?**
You can see a list of all variables by using the `setup` module or the `debug` module with the `var` parameter.

```sh
ansible all -m setup
```

Or in a playbook:

```yaml
- name: Print all variables
  debug:
    var: hostvars[inventory_hostname]
```

### **3. How to create an AWS EC2 key using Ansible?**
You can create an AWS EC2 key pair using the `ec2_key` module.

```yaml
- name: Create an EC2 key pair
  amazon.aws.ec2_key:
    name: my_key
    state: present
    region: us-west-2
    key_material: "{{ lookup('file', 'path/to/public_key.pub') }}"
```

### **4. How to upgrade the Ansible version to the latest version?**
You can upgrade Ansible using `pip`.

```sh
pip install --upgrade ansible
```

###  How to generate encrypted passwords for the user module in Ansible?**
You can generate encrypted passwords using the `mkpasswd` utility from the `whois` package.
```sh
mkpasswd --method=SHA-512
```

```yaml
- name: Create a user with an encrypted password
  user:
    name: myuser
    password: "{{ 'password' | password_hash('sha512') }}"
```

### How to keep secret data in my playbook in Ansible?**

```sh
ansible-vault encrypt secrets.yml
```

```yaml
- name: Use encrypted variables
  include_vars: secrets.yml
```

### What is the minimum requirement for using Docker modules in Ansible?**
The minimum requirement is to have Docker installed on the target machine.

```sh
ansible-galaxy collection install community.docker
```

### How does the Ansible module connect to Docker API?**
Ansible connects to the Docker API using the `community.docker.docker_container` module, which communicates with the Docker daemon via the Docker API.

```yaml
- name: Run a Docker container
  community.docker.docker_container:
    name: mycontainer
    image: nginx
    state: started
```
