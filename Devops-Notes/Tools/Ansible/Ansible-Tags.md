
## ANSIBLE TAGS

### Adding Tags to Tasks
- You can apply one or more tags to individual tasks in your playbook using the `tags` keyword.
- The same tag can be applied to multiple tasks.

### Running Tasks with Tags
- When executing a playbook, you can use the `--tags` flag to only run tasks with the specified tags.
- For example, `ansible-playbook playbook.yml --tags "packages,configuration"`.

### Skipping Tasks with Tags 
- For example, `ansible-playbook playbook.yml --skip-tags "packages"` 

### Tag Inheritance
- Adding tags to plays, imported tasks, or roles applies those tags to all the tasks they contain, known as tag inheritance.
- Tags are inherited down the dependency chain, so tags on role declarations or static imports are applied to that role's tasks.

### Special Tags
- Ansible reserves some tag names for special behavior, such as `always`, `never`, `tagged`, `untagged` and `all`.
- The `always` tag ensures a task always runs, while `never` prevents a task from running.