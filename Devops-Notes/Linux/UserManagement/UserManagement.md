Here are detailed notes on **User Management**, **Password Management**, **Sudo and Privilege Escalation**, and **ACLs** (Access Control Lists) for SRE preparation:

### 1. **User Management**

Managing users is a crucial part of system administration, especially for ensuring security and appropriate access in a multi-user environment.

#### **Key Commands for User Management**:

- **`useradd`**: Adds a new user to the system.
  - Common options:
    - `-m`: Creates the user's home directory.
    - `-s`: Specifies the login shell.
    - `-G`: Adds the user to additional groups.
    - `-d`: Specifies a custom home directory.

- **`usermod`**: Modifies an existing user's account.
  - Common options:
    - `-aG`: Adds the user to supplementary groups without removing them from existing groups.
    - `-s`: Changes the login shell.
    - `-d`: Changes the user's home directory.

- **`userdel`**: Removes a user from the system.
  - Syntax: `userdel [options] username`
  - Common options:
    - `-r`: Removes the user's home directory and mail spool in addition to the user.

#### **Group Management**:
- **`groupadd`**: Adds a new group.
  - Syntax: `groupadd groupname`
- **`groupmod`**: Modifies an existing group.
  - Syntax: `groupmod [options] groupname`
    - `-n`: Renames the group.
- **`groupdel`**: Deletes an existing group.
  - Syntax: `groupdel groupname`


---

### 2. **Password Management**


#### **Key Commands for Password Management**:

- **`passwd`**: Changes a user's password.
  - Syntax: `passwd [username]`
  - If no username is specified, it changes the password for the current user.

- **Password Aging Policies**: Linux allows administrators to enforce password aging, ensuring users change their passwords periodically.
  - **`chage`**: Modifies password aging settings for a user.
    - Syntax: `chage [options] username`
    - Options:
      - `-m`: Sets the minimum number of days between password changes.
      - `-M`: Sets the maximum number of days a password is valid.
      - `-W`: Specifies the number of days before password expiration to warn the user.

#### Account Locking:
- **Locking an account**: Disables a user account so that they cannot log in.
  - Syntax: `passwd -l username`
- **Unlocking an account**:
  - Syntax: `passwd -u username`

---

### 3. **Sudo and Privilege Escalation**

**Sudo** allows users to execute commands with superuser (root) privileges, based on configurations in the `/etc/sudoers` file. 

#### **Sudoers Configuration**:

- **`/etc/sudoers`**: The main configuration file that defines which users can run commands with root privileges. It should be edited with the `visudo` command to prevent syntax errors.
  - **Example sudoers entry**:
    ```
    username ALL=(ALL) ALL
    ```
    This allows `username` to execute any command as any user on the system.

  - **Limiting permissions**: You can restrict which commands a user can execute:
    ```
    username ALL=(ALL) /usr/bin/systemctl, /usr/sbin/service
    ```
    This restricts `username` to only run `systemctl` and `service`.

  - **NOPASSWD option**: Allows a user to run specific commands without being prompted for a password:
    ```
    username ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
    ```

---

### 4. **ACLs (Access Control Lists)**

ACLs provide more granular file permissions than the traditional Linux file permissions (owner, group, others). ACLs allow you to specify permissions for individual users and groups on a per-file or per-directory basis.

#### **Key Commands for ACL Management**:

- **`setfacl`**: Sets ACLs on a file or directory.
  - Syntax: `setfacl [options] filename`
  - Options:
    - `-m`: Modify an ACL entry.
    - `-x`: Remove an ACL entry.
    - `-R`: Apply ACLs recursively to a directory and its contents.

  - **Example**: Give `user1` read and write permissions on `file.txt`:
    ```bash
    setfacl -m u:user1:rw file.txt
    ```

  - **Example**: Give the group `devs` read access to `file.txt`:
    ```bash
    setfacl -m g:devs:r file.txt
    ```

  - **Recursive ACLs**: Set ACLs for all files in a directory:
    ```bash
    setfacl -R -m u:user1:rw /path/to/directory
    ```

- **`getfacl`**: Views the ACLs of a file or directory.
  - Syntax: `getfacl filename`
  - Example output:
    ```bash
    # file: file.txt
    # owner: root
    # group: root
    user::rw-
    user:user1:rw-
    group::r--
    mask::rw-
    other::r--
    ```

#### Default ACLs:
- You can set **default ACLs** on a directory so that newly created files and directories inherit the same ACLs.
  - **Example**: Set a default ACL for all files in `/shared` to give `user1` read-write access:
    ```bash
    setfacl -d -m u:user1:rw /shared
    ```

---

### Summary for SRE Role:
- **User Management**: Control who can access the system, and ensure users are assigned appropriate groups and privileges.
- **Password Management**: Enforce security policies like password aging and ensure that accounts are locked if necessary.
- **Sudo**: Grant users limited, specific root-level access using the sudoers file, following the principle of least privilege.
- **ACLs**: Use ACLs to fine-tune file and directory permissions, especially in multi-user environments where traditional permissions are insufficient.

