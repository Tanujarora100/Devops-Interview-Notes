
## ANSIBLE BLOCKS
Ansible blocks are a powerful feature that allows you to group tasks logically and manage error handling in a way similar to exception handling in programming languages.

### What are Ansible Blocks?
Blocks in Ansible enable the grouping of multiple tasks, allowing you to apply directives and handle errors more effectively. 
- You can define a block using the `block` keyword, and it can include several tasks, along with optional `rescue` and `always` sections.

### Key Features of Ansible Blocks

1. **Logical Grouping**:
   - Blocks allow you to group related tasks together, making your playbooks more organized and readable
   - For example, you can group installation, configuration, and service management tasks within a single block.

2. **Inheritance of Directives**:
   - Any directives applied at the block level (like `when`, `become`, etc.) are inherited by all tasks within the block. 
   - This means you can set conditions or privilege escalation for multiple tasks without repeating yourself.

3. **Error Handling**:
   - Blocks provide a mechanism to handle errors using the `rescue` section. If any task within the block fails, the tasks in the `rescue` section will execute.

4. **Always Section**:
   - The `always` section allows you to specify tasks that should run regardless of whether the tasks in the block or the rescue section succeed or fail. This is useful for cleanup tasks or notifications.

### Example of Using Blocks

Here’s a simple example that demonstrates how to use blocks in an Ansible playbook:

```yaml
tasks:
  - name: Install and configure Apache
    block:
      - name: Install httpd and memcached
        yum:
          name:
            - httpd
            - memcached
          state: present

      - name: Apply the configuration template
        template:
          src: templates/src.j2
          dest: /etc/foo.conf

      - name: Start the Apache service
        service:
          name: httpd
          state: started
          enabled: true

    rescue:
      - name: Handle installation failure
        debug:
          msg: "Installation failed, performing cleanup..."

    always:
      - name: Notify completion
        debug:
          msg: "This task always runs."
```
