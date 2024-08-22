## ANSIBLE VARS
To supply variables while running an Ansible playbook, you can use the `--extra-vars` or `-e` option in the command line.

### Passing Variables via Command Line

1. **Single Variable**:
   For example:
   ```bash
   ansible-playbook example.yml --extra-vars "fruit=apple"
   ```

2. **Multiple Variables**:
```bash
   ansible-playbook deploy-apache.yaml --extra-vars "apache_listen_port=8080 apache_listen_port_ssl=443"
   ```

3. **Using JSON Format**:
   ```bash
   ansible-playbook your_playbook.yml --extra-vars '{"car": "Tesla"}'
   ```

4. **Variables with Spaces**:
   ```bash
   ansible-playbook your_playbook.yml --extra-vars "my_var='value with spaces'"
   ```

5. **Using a Variable File**:
    ```bash
    ansible-playbook your_playbook.yml --extra-vars "@path_to_file.yml"
    ```

## ANSIBLE PLAYBOOK FAILURE
1. **Run the original playbook**:
   ```bash
   ansible-playbook original_playbook.yml
   ```
   If the playbook fails on any tasks, Ansible will generate a `.retry` file containing the failed hosts.

2. **Fix the error in the original playbook**.

3. **Run the playbook again, but only for the failed hosts**:
   ```bash
   ansible-playbook original_playbook.yml --limit @original_playbook.retry
   ```
   The `--limit` option with `@` reads the failed hosts from the `.retry` file and runs the playbook only against those hosts.

4. **If the playbook fails again, repeat steps 2 and 3 until all hosts are successfully provisioned**.


```bash
ansible-playbook original_playbook.yml --start-at-task="name_of_failed_task"
```

However, this approach has some limitations:

- It doesn't work with tasks inside roles or includes.
- It doesn't handle conditional tasks that depend on previous tasks' results.


```yaml
- block:
    # Tasks that may fail
  rescue:
    # Tasks to execute if any block task fails
```

The `rescue` section will run if any task in the `block` fails, allowing you to perform cleanup or notification actions. However, this won't automatically rerun the failed tasks.

In summary, using the `.retry` file with `--limit` is the simplest way.


## HOW TO PRINT SOMETHING ON THE ANSIBLE MASTER WHEN AFTER EVERY TASKS
`ansible debug module`
### Using the `debug` Module

1. **Basic Usage**:
   You can add a `debug` task after each task to print a message. For example:

   ```yaml
   - name: Install a package
     apt:
       name: nginx
       state: present

   - name: Print message after installing nginx
     debug:
       msg: "Nginx has been installed successfully."
   ```

2. **Printing Variable Values**:
   If you want to print the value of a variable after a task, you can do it like this:

   ```yaml
   - name: Create a user
     user:
       name: johndoe
       state: present
     register: user_creation

   - name: Print user creation result
     debug:
       msg: "User creation status: {{ user_creation }}"
   ```


  ```yaml
  ---
  - name: Example Playbook
    hosts: all
    tasks:
      - name: Install nginx
        apt:
          name: nginx
          state: present

      - name: Print message after installing nginx
        debug:
          msg: "Nginx has been installed successfully."

      - name: Start nginx service
        service:
          name: nginx
          state: started

      - name: Print message after starting nginx
        debug:
          msg: "Nginx service has been started."
  ```
