
### `/etc/fstab` (Filesystem Table)

#### Purpose:
- The `/etc/fstab` file is a static configuration file that contains a list of entries specifying how disk partitions, devices, or remote file systems should be automatically mounted at boot time or when called by the `mount` command.

#### Structure:
- Each line in `/etc/fstab` corresponds to a file system and contains six fields, which are:
  1. **Device:** The file system or device to be mounted (e.g., `/dev/sda1`, `UUID=1234-5678`, or `LABEL=root`).
  2. **Mount Point:** The directory where the file system should be mounted (e.g., `/`, `/home`, `/mnt/data`).
  3. **Filesystem Type:** The type of the file system (e.g., `ext4`, `xfs`, `nfs`).
  4. **Options:** Mount options (e.g., `defaults`, `ro`, `noatime`).
  5. **Dump:** A number indicating if the file system should be dumped (1 for true, 0 for false).
  6. **Pass:** A number indicating the order in which file systems should be checked at boot time by `fsck` (0 to disable, 1 for the root file system, 2 for other file systems).

  #### Example:
  ```plaintext
  # <file system>  <mount point>  <type>  <options>  <dump>  <pass>
  UUID=1234-5678   /              ext4    defaults    1       1
  /dev/sda2        /home          ext4    defaults    0       2
  /dev/sdb1        /mnt/data      xfs     defaults    0       0
  ```

### `/etc/mtab` (Mounted File Systems)

#### Purpose:
- The `/etc/mtab` file is a `dynamic file` that maintains a list of currently mounted file systems. 
- Fstab is static while this is dynamic
  - It is updated by the `mount` and `umount` commands as file systems are `mounted and unmounted`.

#### Structure:
- Each line in `/etc/mtab` contains information similar to `/etc/fstab` but is dynamically generated and reflects the current state of mounted file systems.
  1. **Device:** The file system or device that is mounted.
  2. **Mount Point:** The directory where the file system is mounted.
  3. **Filesystem Type:** The type of the file system.
  4. **Options:** Mount options that are currently in effect.
  5. **Dump:** Indicates if the file system should be dumped.
  6. **Pass:** Indicates the order in which file systems are checked at boot.

  #### Example:
  ```plaintext
  /dev/sda1 / ext4 rw,relatime,data=ordered 0 0
  /dev/sda2 /home ext4 rw,relatime,data=ordered 0 0
  /dev/sdb1 /mnt/data xfs rw,relatime,attr2,inode64,noquota 0 0
  ```

### Key Differences

- **Static vs. Dynamic:**
  - `/etc/fstab` is a static file, manually edited by the system administrator
  - `/etc/mtab` is a dynamic file, automatically updated by the system 

- **Purpose:**
  - `/etc/fstab` is used to specify file systems to be mounted at boot time and their mount options.
  - `/etc/mtab` provides a snapshot of file systems currently mounted
