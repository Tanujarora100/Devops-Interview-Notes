
## Role Directory Structure

An Ansible role has a defined directory structure with several standard directories, At minimum, a role must include one of these directories, while others can be omitted if not used:

**tasks/** - Contains the main list of tasks for the role in `main.yml`[1][2]

**handlers/** - Handlers that are triggered by tasks and run at the end of a play

**defaults/** - Default variables for the role with the lowest priority

**vars/** - Other variables for the role

**files/** - Files that can be deployed via the role[1][2]

**templates/** - Templates that can be rendered and deployed by the role

**meta/** - Defines role dependencies

The `ansible-galaxy init <role_name>` command creates this standard directory structure skeleton for a new role[1][3].

## Playbook Usage

To use a role in a playbook, simply list it under the `roles` keyword[2]:

```yaml
- hosts: webservers
  roles:
     - common
     - webserver
     - postgres
```


## Role Dependencies

Role dependencies allow automatically pulling in other roles when using a role. They are stored in the `meta/main.yml` file and have a lower precedence than variables from other sources.
Ansible tags are metadata that you can attach to tasks in an Ansible playbook. They allow you to selectively run or skip certain tasks at runtime, giving you more control over your playbook execution.