#### High Disk Usage Issue
- If root volume then check logs and clear some mount points
1. EC2 ASG is Going Down- `top` Command or `ps aux --sort=-%cpu | head -n 11`

8. How to see the partition sizes :
    1. `fdisk -l`
    2. check linux version - `uname -a` or `'cat /etc/*release`
9. Limit the memory usage of the process - `ulimit -Sv 1000`
10. Check the full path of file `readlink -f file.txt`

13. A user cannot telnet or ssh to the server:
    1. server might be down
    2. Server sshd service is not running
    3. firewall can be blocking it.

14. Difference in tar and .gz
    1. tar puts multiple files in a tar file
    2. gzip compress that archive file
    3. To get a compressed archive we need to use the tar and gzip together
15. List directory only inside a directory
    1. `find . -type d`
17. check disk space - `df -h` 
18. Check Swap Memory `free -gh` 
19. hostname check - `hostname` 
20. check ip of the machine - `ip addr show or hostname -i`
21. How to check a certain port for traffic - `tcpdump -i eth0`
22. check current user - `whoami`
22. Create file - `touch`, `vim,nano`
23. grep and egrep - egrep can search multiple words at one time also.
24. read file without cat command - `less` , `head` , `more`,  `nano or vim`
25. advantage of less command: forward and backward search is easy, navigation is easier.
26. check file permission:  `ls -l` or `getfacl filename`
27. inode: `ls -li` to check the inode
    1. Serves as unique identifier for a specific piece of metadata
    2. This is a type of data-structure which stores the metadata.
28. finding files on linux - `find` or `locate` command
29. counting words or lines - `wc` or `wc -l` for lines.
30. shred command: permanently delete a file which cannot be recovered - `shred -u abc.txt`
31. check architecture of the system - `lsblk` and `lscpu`
    1. `dmidecode is also used to check`
32. check the type of file - `file abc.txt or stat command`
33. How to sort the data of file - `sort` or `cat abc.txt|sort`
34. how to sort in reverse - `sort -r`
35. how to sort and remove duplicates - `sort -u`
36. how to sort by months - `sort -M`
37. How to redirect the error also - `2>` 
38. How to redirect the error and output- `2>&1`
39. how to check crontab - `crontab -l`
40. `* * * * *` what does this mean- run every minute, every hour, every day of the month, every month, every day of the week
    ![alt text](image.png)
    
41. How to check crontab did not work
    1. `check system time`
    2. `crontab -e`
    3. check `/var/log/messages`
42. Check cpu usage for a process - `ps aux` or `top`
43. check if process is running - `ps -ef | grep -i httpd`
44. How to kill a process - `kill -9 pid`
45. What is Kernel: Kernel is the core component between hardware and the process, it is like a `middleware which is responsible for communication.`
46. Search a word in file and replace it in entire file: 
    1. `sed` command is used to replace the word in entire file
    2. `sed -i.bak 's/MAINTAINCE_ENABLED/MAINTAINCE_DISABLED/g' config.cfg`
47. FTP Command is used for: To exchange the file to and from a remote computer.
48. How to setup alias : `vim .bashrc` file and set the alias
49. Default Ports:
    1. SSH -22
    2. DNS -53
    3. SMTP -25
    4. HTTP-80
    5. HTTPS-443
    6. FTP-21
50. How to check if a package is installed or not: `rpm -qa | grep -i net-tools`
51. Difference in Upgrade and Update Command:
    1. update: install new packages
    2. upgrade: perform same as update but removes older packages.
52. What is Swap Space: Swap space is used in linux if the system needs more memory and RAM is full, then linux uses this swap space.
    1. check swap space - `free -h`
53. Difference in kill and kill -9 - kill -9 forcefully terminates the process.
54. Which command has the value of exit status of previously executed command - `$?`
55. Check the usb devices - `lsusb`
56. How to check IP Server is accessible or not - `ping` or `telnet`
57. How to check the info of the ports - `netstat -tulpn`
58. How to check route table of the Machine- `netstat -route`
59. How to check network interfaces - `netstat -i` 
60.  All Connections- `netstat -a`
61. Process Vs Daemon: Daemon is a special process which runs in the background.

60. Difference in SSH and telnet: 
- Telnet is not secured.
- Data is not encrypted.
61. How to set a username and password that never expires `chage -M -1 Tanuj`
62. Why etc/passwd and etc/shadow file cannot be merged : existence of two files as passwd file is a text file and the shadow file is the hashed file
- shadow file is accessible by root only
63. List files opened by a specific process - `lsof -p PID`
64. Taking alot of time after reboot: filesystem can be corrupted or ext2 does not have journaling feature.
65. File is unable to be created on a mount point
    1. check space - `df -h`
    2. check inode usage - `df -i`
66. How to set a sticky bit and difference in small s and capital S
    1. Sticky bit is a special permissions for file and directory and superuser can delete or rename the file only even if other users have the write permission to the directory

68. Explain Booting Process of Linux.
    1. **BIOS/UEFI Initialisation:**
        - BIOS or UEFI firmware initialises hardware components like CPU, RAM, and storage devices.
        - Executes Power-On Self-Test (POST) to check hardware integrity.
    2. **Boot Loader Stage:**
        - BIOS/UEFI loads the boot loader from the Master Boot Record (MBR) or EFI System Partition (ESP).
        - Common boot loaders include GRUB (Grand Unified Bootloader) for BIOS systems and GRUB2 for UEFI systems.
    3. **GRUB Stage:**
        - GRUB loads its configuration file from **`/boot/grub/grub.cfg`**.
        - Presents boot options if multiple kernels are installed.
        - Loads the selected kernel and initial RAM disk (initrd).
    4. **Kernel Initialization:**
        - Kernel starts executing and initializes essential hardware components.
        - Mounts the root filesystem specified in the boot parameters.
        - Executes user-space init program (**`/sbin/init`** or its alternatives).
    5. **Init Process:**
        - Init process becomes the parent process (PID 1) and spawns other system processes.
        - Depending on the distribution, init can be traditional SysV init, Upstart, or systemd.
    6. **User Space Initialisation:**
        - System initialisation scripts and services start running.
        - System daemons like networking, logging, and device management are initialised.
    7. **User Login:**
        - Once initialisation is complete, the system presents a login prompt or graphical login screen.
        - Users can log in and start using the system

### If you have accidentally deleted the root user on a Linux system, you can regain access by following these steps:

#### 1. Boot into Single-User Mode

1. **Reboot the System**: Restart your machine.
2. **Access GRUB Menu**: Hold down the `Shift` key (for BIOS-based systems) or press `Esc` repeatedly (for UEFI-based systems) during boot to access the GRUB menu.
3. **Edit GRUB Entry**: Highlight the default boot entry and press `e` to edit it.
4. **Modify Boot Parameters**: Find the line that starts with `linux` and append `init=/bin/bash` at the end of this line.
5. **Boot with Modified Parameters**: Press `Ctrl + X` or `F10` to boot with these parameters.

### 2. Remount the Filesystem

Once you have booted into single-user mode, the root filesystem is mounted as read-only. You need to remount it as read-write to make changes.

```bash
mount -o remount,rw /
```

### 3. Recreate the Root User
You can recreate the root user by editing the `/etc/passwd` and `/etc/shadow` files.
#### Example `/etc/passwd` Entry for Root
Open the `/etc/passwd` file with an editor like `vi` or `nano`:
```bash
nano /etc/passwd
```
Add the following line if it does not exist:
```plaintext
root:x:0:0:root:/root:/bin/bash
```
#### Example `/etc/shadow` Entry for Root
Open the `/etc/shadow` file:

```bash
nano /etc/shadow
```

```plaintext
root:*:17722:0:99999:7:::
```
### 4. Set the Root Password
```bash
passwd root
```

### 5. Reboot the System
```bash
exec /sbin/init
```



#### Example Commands

- **View `/etc/shadow`** (requires root privileges):

    ```bash
    sudo cat /etc/shadow
    ```

- **Change a user's password**:

    ```bash
    sudo passwd username
    ```
- Check Locked accounts
```sh
cat /etc/shadow
! means locked
passwd -S username
chage -l username
```
Access Control Lists (ACLs) in Linux provide a more flexible permission mechanism than the traditional UNIX file permissions. They allow you to grant specific permissions to individual users or groups for any file or directory, beyond the standard owner, group, and others model.

## Key Concepts of ACLs

### 1. **ACL Basics**
- **ACL Entries**: Each ACL consists of a set of entries that specify the access permissions for a user or group.
- **Types of ACLs**:
  - **Access ACLs**: Define permissions for a specific file or directory.
  - **Default ACLs**: Define default permissions for new files and directories created within a directory.

### 2. **Viewing ACLs**
To view the ACLs of a file or directory, use the `getfacl` command:

```bash
getfacl /path/to/file_or_directory
```

Example output:
```bash
# file: example.txt
# owner: user
# group: group
user::rw-
user:anotheruser:r--
group::r--
mask::r--
other::---
```

### 3. **Setting ACLs**
To set or modify ACLs, use the `setfacl` command. Here are some common operations:

#### Adding Permissions
- **For a User**:
  ```bash
  setfacl -m u:username:permissions /path/to/file_or_directory
  ```
  Example:
  ```bash
  setfacl -m u:john:rwx /path/to/file
  ```

- **For a Group**:
  ```bash
  setfacl -m g:groupname:permissions /path/to/file_or_directory
  ```
  Example:
  ```bash
  setfacl -m g:developers:rw /path/to/file
  ```

#### Setting Default ACLs
Default ACLs are set on directories and inherited by new files and directories created within them.

```bash
setfacl -d -m u:username:permissions /path/to/directory
```
Example:
```bash
setfacl -d -m u:john:rwx /path/to/directory
```

#### Removing ACL Entries
- **Remove a Specific Entry**:
  ```bash
  setfacl -x u:username /path/to/file_or_directory
  ```
  Example:
  ```bash
  setfacl -x u:john /path/to/file
  ```

- **Remove All ACL Entries**:
  ```bash
  setfacl -b /path/to/file_or_directory
  ```

### 4. **Checking for ACLs**
The presence of ACLs on a file or directory can be detected by an extra `+` sign in the output of the `ls -l` command:

```bash
ls -l /path/to/file_or_directory
```

Example output:
```bash
-rw-rw-r--+ 1 user group 0 Jul 21 12:34 example.txt
```

### 5. **Examples**

- **Grant Read and Write Permissions to a User**:
  ```bash
  setfacl -m u:alice:rw /path/to/file
  ```

- **Grant Read, Write, and Execute Permissions to a Group**:
  ```bash
  setfacl -m g:team:rwx /path/to/directory
  ```

- **Set Default ACL for a Directory**:
  ```bash
  setfacl -d -m u:bob:rwx /path/to/directory
  ```

- **Remove All ACLs from a File**:
  ```bash
  setfacl -b /path/to/file
  ```

### 6. **Advanced Usage**
- **Recursive ACL Setting**:
  ```bash
  setfacl -R -m u:username:permissions /path/to/directory
  ```

- **Dry Run to Test ACL Changes**:
  ```bash
  setfacl --test -m u:username:permissions /path/to/file_or_directory
  ```
#### Find which kernel version a system is currently running
```
uname -a
```
#### Find system's current IP address
```
ifconfig
ip addr show
```
#### Lock user
```
usermod -L user1
```
