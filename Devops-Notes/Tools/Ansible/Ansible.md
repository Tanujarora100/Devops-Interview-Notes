### Ansible Architechture
- Ansible Master or Control Node
- Ansible Slave Nodes.

### Why Ansible Over Puppet and Chef?
- Python based
- Agentless
- SSH Keys 
- Push Arch
- Dynamic Inventory in ansible 

### Ansible Inventory Types:
- Static Inventory: INI, YAML file.
- Dynamic Inventory: YAML file, JSON File.
- Inventory file can be anywhere on the machine you just need to pass the file path.
- **etc/ansible/hosts** is acting as the default inventory file.
- Recommended Approach to have a separate inventory file for each project.

### Ansible Modules
- Core Modules
- Extra Modules: Can be stable or not

### How You Will Copy Files Recursively:


```yaml
- name: Copy directory with permissions
  hosts: all
  tasks:
    - name: Copy directory and set permissions
      ansible.builtin.copy:
        src: /path/to/source_directory/
        dest: /path/to/destination_directory/
        directory_mode: '0755'
        remote_src : yes
        mode: '0644'
        owner: root
        group: root
```

### Using `synchronize` Module

For large sets of files or directories, consider using the `ansible.builtin.synchronize` module, which is a wrapper around `rsync` and is more efficient for large-scale recursive copying.

```yaml
- name: Synchronize directory
  hosts: all
  tasks:
    - name: Synchronize directory on remote machine
      ansible.builtin.synchronize:
        src: /path/to/source_directory/
        dest: /path/to/destination_directory/
        delegate_to: "{{ inventory_hostname }}"
```

### What are the advantages of using Ansible?**
- **Agentless**: .
- **Simple syntax**:
- **Idempotent**
- **Declarative**:

### Creating an Encrypted File

```bash
ansible-vault create secret.yml
```

After running this command, you will be prompted to enter and confirm a password. Once the password is set/

### Encrypting an Existing File
```bash
ansible-vault encrypt existing_file.yml
```
### Viewing an Encrypted File

```bash
ansible-vault view secret.yml
```

### Editing an Encrypted File

To edit an encrypted file, use the `ansible-vault edit` command:

```bash
ansible-vault edit secret.yml
```
### Decrypting a File
```bash
ansible-vault decrypt secret.yml
```
### Changing the Password of an Encrypted File

```bash
ansible-vault rekey secret.yml
```

### Example Playbook Using Encrypted Variables
1. Encrypt a variable:

```bash
ansible-vault encrypt_string 'my_secret_password' --name 'db_password'
```
2. Use the encrypted variable in a playbook:

```yaml
- name: Example playbook using encrypted variable
  hosts: localhost
  vars:
    db_password: !vault |
      $ANSIBLE_VAULT;1.1;AES256
      62313365396662343061393464336163383764373764613633653634306231386433626436623361
      6134333665353966363534333632666535333761666131620a663537646436643839616531643561
      63396265333966386166373632626539326166353965363262633030333630313338646335303630
      3438626666666137650a353638643435666633633964366338633066623234616432373231333331
      6564
  tasks:
    - name: Print the encrypted variable
      debug:
        msg: "The database password is {{ db_password }}"
```


### How do you handle errors in Ansible?**
- **ignore_errors**: Allows the playbook to continue even if a task fails.
- **failed_when**: Custom conditions
- **rescue**: Blocks to define tasks to run if a task fails.

### What is Ansible Vault?**
- Ansible Vault is a feature that allows you to encrypt sensitive data such as passwords, keys, and other secrets within Ansible playbooks. 

###  How does the Ansible synchronize module work?
- The synchronize module is a wrapper around rsync to synchronize files and directories between the local machine and remote hosts.


### What is Ansible Tower?**
- By Redhat
- Allow fine grained access control
- Log Management
- Collaboration with other teams.

### How do you perform rolling updates using Ansible?**
- To perform rolling updates, you can divide the **servers into batches and execute playbook tasks sequentially** on each batch. 
- Use the `serial` keyword to control the number of hosts updated at a time and `delegate_to` to manage dependencies between tasks.
```yaml
---
- name: Rolling update of web servers
  hosts: webservers
  serial: 2
  tasks:
    - name: Take web server out of load balancer rotation
      command: /usr/bin/take_out_of_pool {{ inventory_hostname }}
      delegate_to: 127.0.0.1

    - name: Update web server
      yum:
        name: acme-web-stack
        state: latest

    - name: Add web server back to load balancer rotation
      command: /usr/bin/add_back_to_pool {{ inventory_hostname }}
      delegate_to: 127.0.0.1
```
### Explain the key Ansible terms: Inventory, Modules, Roles, and Handlers.**
- **Inventory**: A list of hosts and groups of hosts on which Ansible commands and playbooks operate.
- **Modules**: Reusable, standalone scripts that Ansible runs on remote hosts.
- **Roles**: A way to organize playbooks into reusable components. 
  - Roles can include tasks, variables, files, templates, and handlers.
- **Handlers**: Special tasks that are triggered by other tasks using the `notify` directive
```yaml

---
- name: Update all Hosts
  hosts: webservers
  become: yes
  tasks:
    - name: Update all packages to the latest version
      ansible.builtin.yum:
        name: '*'
        state: latest
        update_cache: yes
      notify:
        - echo_handler

handlers:
  - name: echo_handler
    ansible.builtin.command:
      cmd: echo "Update completed"
```

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
- The default cache plugin is `memory`, which only caches.
- Persistent cache plugins like `jsonfile`, `redis`, and `memcached`.

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
- Network modules in Ansible are used to manage network devices. 
- They gather information and configure devices using various protocols like SSH, NETCONF, and REST APIs. 
```yaml
- name: Configure a Cisco IOS device
  cisco.ios.ios_config:
    lines:
      - hostname Router1
      - interface GigabitEthernet0/1
      - ip address 192.168.1.1 255.255.255.0
```

### How does Ansible manage multiple communication protocols?**
Ansible manages multiple communication protocols using connection plugins. The `ansible_connection` variable specifies the connection type, such as `ssh`, `winrm`.
```ini
[linux]
server1 ansible_connection=ssh
[windows]
server2 ansible_connection=winrm
[network]
router1 ansible_connection=network_cli 
```
###  How to handle different machines needing different user accounts or ports to log in with using Ansible?**
You can specify different user accounts and ports in the inventory file or using group variables.
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


###  How to generate encrypted passwords for the user module in Ansible?**
using the `mkpasswd` utility from the `whois` package.
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
## Dynamic Inventory in Ansible

Dynamic inventory in Ansible allows for real-time, automated management of infrastructure resources, which is particularly useful in cloud environments where resources frequently change.

### **Key Concepts**

1. **Dynamic Inventory Sources**
   - Dynamic inventory sources can include cloud providers (AWS, Azure, GCP), LDAP directories.
2. **Inventory Plugins vs. Inventory Scripts**
   - **Inventory Plugins**: These are the preferred method for dynamic inventory in Ansible.
   - **Inventory Scripts**: These are custom scripts that output inventory data in JSON format. While still supported, they are less efficient and more complex to manage compared to plugins.

### **How Dynamic Inventory Works**

1. **Configuration**
   - Dynamic inventory is configured through inventory files, which can be written in `YAML or JSON`. 
   - Example configuration for AWS EC2 using the `aws_ec2` plugin:
     ```yaml
     plugin: aws_ec2
     regions:
       - us-west-2
     keyed_groups:
       - key: tags
         prefix: tag
       - key: instance_type
         prefix: instance_type
       - key: placement.region
         prefix: aws_region
     ```
3. **Caching**
   - To improve performance, dynamic inventory plugins can cache results.
   - Example of enabling caching in the `aws_ec2` plugin:
     ```yaml
     plugin: aws_ec2
     cache: yes
     cache_plugin: jsonfile
     cache_timeout: 7200
     cache_connection: /tmp/aws_inventory
     ```

### **Benefits of Dynamic Inventory**

1. **Real-Time Updates**

2. **Scalability**
3. **Flexibility**
   - Can integrate with various external system
2. **Basic Structure of a Custom Script**
     ```python
     import json

     def get_inventory():
         inventory = {
             "webprod": {
                 "hosts": ["web1", "web2"],
                 "vars": {"http_port": "80"}
             },
             "_meta": {
                 "hostvars": {
                     "web1": {"http_port": "80"},
                     "web2": {"http_port": "80"}
                 }
             }
         }
         return inventory
     if __name__ == "__main__":
         print(json.dumps(get_inventory()))
     ```
3. **Using the Custom Script**
     ```sh
     ansible-playbook -i /path/to/custom_inventory_script.py playbook.yml
     ```

The `async` keyword in Ansible allows you to run tasks asynchronously, meaning the tasks are executed in the background without blocking the execution of subsequent tasks. This is particularly useful for long-running operations that would otherwise cause delays or timeouts if run synchronously. Here’s a detailed explanation of how to use the `async` keyword in Ansible:

## **Using the `async` Keyword**

### **Basic Syntax**

To run a task asynchronously, you need to specify two parameters:
- `async`: The maximum runtime for the task in seconds.
- `poll`: The interval in seconds at which Ansible checks the status of the task. Setting `poll: 0` makes the task run in a "fire and forget" mode, where Ansible does not wait for the task to complete.

### **Example: Fire and Forget**

In this example, the task will run for up to 45 seconds, but Ansible will not wait for it to complete:

```yaml
- hosts: all
  tasks:
    - name: Simulate long running operation
      command: /bin/sleep 15
      async: 45
      poll: 0
```

### **Example: Polling for Status**

In this example, the task will run for up to 45 seconds, and Ansible will check its status every 5 seconds:

```yaml
- hosts: all
  tasks:
    - name: Simulate long running operation
      command: /bin/sleep 15
      async: 45
      poll: 5
```

### **Checking the Status of Asynchronous Tasks**

If you need to check the status of an asynchronous task later, you can use the `async_status` module. Here’s how to do it:

1. **Run the Asynchronous Task and Register the Job ID**:

    ```yaml
    - hosts: all
      tasks:
        - name: Start long running operation
          command: /bin/sleep 1000
          async: 1000
          poll: 0
          register: long_running_task
    ```

2. **Check the Status of the Asynchronous Task**:

    ```yaml
    - hosts: all
      tasks:
        - name: Check the status of the long running operation
          async_status:
            jid: "{{ long_running_task.ansible_job_id }}"
          register: job_result
          until: job_result.finished
          retries: 30
          delay: 10
    ```

### **Handling Multiple Asynchronous Tasks**

To handle multiple asynchronous tasks, you can loop over them and register each task's job ID. Here’s an example:

```yaml
- hosts: all
  tasks:
    - name: Start multiple long running tasks
      command: /bin/sleep 1000
      async: 1000
      poll: 0
      register: async_tasks
      loop: "{{ range(1, 5) | list }}"
      loop_control:
        loop_var: item

    - name: Check the status of all long running tasks
      async_status:
        jid: "{{ item.ansible_job_id }}"
      register: job_result
      until: job_result.finished
      retries: 30
      delay: 10
      loop: "{{ async_tasks.results }}"
      loop_control:
        loop_var: item
```

### **Important Considerations**

- **Exclusive Locks**: Avoid using `poll: 0` for tasks that require exclusive locks (e.g., package installations) if you plan to run other commands against the same resources later in the playbook.
- **Cleanup**: When running with `poll: 0`, Ansible does not automatically clean up the async job cache file. You may need to use the `async_status` module with `mode: cleanup` to clean up manually.

## Ansible Role Directory Structure

Ansible roles are a way to organize and reuse Ansible code. They allow you to group related tasks, handlers, variables, files, and templates into a single unit that can be easily shared and reused. Here’s a detailed overview of the standard directory structure for an Ansible role:

### Standard Role Directory Structure

When you create a role using the `ansible-galaxy init <role_name>` command, it generates a directory structure like the one below:

```plaintext
roles/
├── <role_name>/
│   ├── defaults/
│   │   └── main.yml
│   ├── files/
│   ├── handlers/
│   │   └── main.yml
│   ├── meta/
│   │   └── main.yml
│   ├── tasks/
│   │   └── main.yml
│   ├── templates/
│   ├── tests/
│   │   ├── inventory
│   │   └── test.yml
│   └── vars/
│       └── main.yml
```

### Explanation of Each Directory

#### 1. `defaults/`
- **File**: `main.yml`
- **Purpose**: Contains default variables for the role. These variables have the lowest priority and can be easily overridden by other variable sources.

#### 2. `files/`
- **Purpose**: Contains static files that are used by the role. These files are typically referenced in tasks using the `copy` or `fetch` module.

#### 3. `handlers/`
- **File**: `main.yml`
- **Purpose**: Contains handlers, which are tasks that are triggered by notifications from other tasks. Handlers are typically used to restart services or perform other actions that should only occur once after a series of changes.

#### 4. `meta/`
- **File**: `main.yml`
- **Purpose**: Contains metadata about the role, including author information, license, supported platforms, and role dependencies.

#### 5. `tasks/`
- **File**: `main.yml`
- **Purpose**: Contains the main list of tasks to be executed by the role. This is where most of the role's logic is defined. Tasks can be broken down into smaller files and included in `main.yml`.

#### 6. `templates/`
- **Purpose**: Contains Jinja2 templates that are used by the role. Templates are processed by Ansible to produce configuration files or other content that can be dynamically generated based on variables.

#### 7. `tests/`
- **Files**: `inventory`, `test.yml`
- **Purpose**: Contains files for testing the role. This can include a sample inventory file and a test playbook to verify that the role works as expected.

#### 8. `vars/`
- **File**: `main.yml`
- **Purpose**: Contains variables that are meant to be used internally by the role. These variables have a higher priority than those in the `defaults` directory.

### Example Role Directory Structure

Here’s an example of a role directory structure for a role named `webserver`:

```plaintext
roles/
├── webserver/
│   ├── defaults/
│   │   └── main.yml
│   ├── files/
│   │   └── index.html
│   ├── handlers/
│   │   └── main.yml
│   ├── meta/
│   │   └── main.yml
│   ├── tasks/
│   │   └── main.yml
│   ├── templates/
│   │   └── httpd.conf.j2
│   ├── tests/
│   │   ├── inventory
│   │   └── test.yml
│   └── vars/
│       └── main.yml
```

### Creating a Role Using `ansible-galaxy`

To create a new role with the standard directory structure, use the `ansible-galaxy init` command:

#### List all the hosts
```bash
ansible all --list-hosts
```
```bash
ansible all -i /path/to/inventory/file --list-hosts
```
```bash
ansible-inventory --list all | jq -r '.all.hosts | keys[]'
```
Here is a concise explanation of the main directories in an Ansible role and their purposes:



### Error Handling with Blocks

- If any task within the block fails, the `rescue` section will execute, allowing you to handle the error gracefully. 
- The `always` section will run after the `rescue`, ensuring that certain tasks are executed regardless of previous outcomes.
To encrypt a playbook or specific variables within a playbook using Ansible Vault, you can use the `ansible-vault encrypt` command. Here’s how to do it:

## Encrypting a Playbook
1. **Encrypting the Entire Playbook**:
   ```bash
   ansible-vault encrypt your_playbook.yml
   ```

2. **Encrypting a Specific String**:
   If you want to encrypt just a specific variable within a playbook, you can use the `encrypt_string` command:

   ```bash
   ansible-vault encrypt_string --vault-id your_vault_id@path_to_password_file 'your_string' --name 'your_variable_name'
   ```

   For example, to encrypt a password string:

   ```bash
   ansible-vault encrypt_string --vault-id dev@a_password_file 'mypassword' --name 'db_password'
   ```

   ```yaml
   db_password: !vault |
     $ANSIBLE_VAULT;1.1;AES256;dev
     30613233633461343837653833666333643061636561303338373661313838333565653635353162
   ```

### Running the Encrypted Playbook
```bash
ansible-playbook your_playbook.yml --ask-vault-pass
```
```bash
ansible-playbook your_playbook.yml --vault-password-file path_to_password_file
`

## SAMPLE INVENTORY FILE
```ini
# Define hosts
host1 ansible_host=192.168.1.10 ansible_user=ubuntu
host2 ansible_host=192.168.1.11 ansible_user=ubuntu
host3 ansible_host=192.168.1.12 ansible_user=centos

# Define groups
[webservers]
host1
host2

[databases]
host3

[centos]
host3

[ubuntu]
host1
host2

# Define groups of groups
[production:children]
webservers
databases

[development:children]
webservers

[linux:children]
centos
ubuntu

# Set variables for groups
[webservers:vars]
http_port=80
https_port=443

[databases:vars]
db_port=5432

# Set variables for individual hosts
host1 ansible_port=2222

`

### Command to Gather Facts

You can run the following command in your terminal:

```bash
ansible all -i inventory_file -m ansible.builtin.setup
```

### Breakdown of the Command


- **`-m ansible.builtin.setup`**: This tells Ansible to use the `setup` module, which is responsible for gathering facts about the remote hosts.

### Example Output

When you run this command, Ansible will connect to each host in the inventory and gather facts such as:

- Hostname
- Operating system
- CPU architecture
- Memory and disk information
- Network interfaces
- Installed packages


### Additional Options

- If you want to gather facts from a specific group of hosts, you can replace `all` with the group name, for example, `webservers` or `dbservers`.

- To save the gathered facts to a file for later analysis, you can redirect the output to a file:

```bash
ansible all -i inventory_file -m ansible.builtin.setup > facts_output.json
```


### WHAT IS ANSIBLE DOC
- To get information about modules
```bash
ansible doc -l | grep -i file

```
![alt text](image-1.png)
### ANSIBLE GALAXY
