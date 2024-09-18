**LVM Management**
Here are the key components of LVM:

1. **Physical Volumes (PVs):**
    - Physical Volumes are the **raw storage devices, such as hard drives or SSDs.**
    - Before you can use a hard drive with LVM,`you must initialise it as a physical volume`.
    - `sudo lvmdiskscan` shows the physical volumes.

2. **Volume Groups (VGs):**
    - Volume Groups are made up of one or more physical volumes.
    - **A Volume Group can be thought of as a pool of storage.**
3. **Logical Volumes (LVs):**
    - **Logical Volumes are virtual partitions created within Volume Groups.**
    - Logical Volumes are what you will actually use to store files.
    - `Logical volumes are block devices, just like physical devices.`

LVM allows for dynamic resizing of logical volumes, which means you can change the size of logical volumes as needed without losing any data. **It also provides a way to create snapshots, which are a point-in-time copy of a volume,** useful for backups.

### **Why Use LVM?**

- **Flexibility:** 
- **Snapshotting:** 

## **Add a new disk to LVM without using partitions**
Adding a new disk to LVM without using partitions involves the following steps:
1. Initialise the new disk as a Physical Volume (PV).
    
    ```bash
    sudo pvcreate /dev/sdb
    
    ```
2. Add the new Physical Volume to an existing Volume Group (VG).
    
    ```bash
    sudo vgextend my_volume_group /dev/sdb
    ```
3. Extend a Logical Volume (LV) to use the newly added space.
    `sudo lvextend -l +100%FREE /dev/my_volume_group/my_logical_volume`
    
4. Resize the file system to make use of the extended Logical Volume.
    `sudo resize2fs /dev/my_volume_group/my_logical_volume`
    

```bash
# 1. Initialize the new disk as a Physical Volume (PV)
sudo pvcreate /dev/sdb

# 2. Add the new Physical Volume to an existing Volume Group (VG)
sudo vgextend my_volume_group /dev/sdb

# 3. Extend a Logical Volume (LV) to use the newly added space
sudo lvextend -l +100%FREE /dev/my_volume_group/my_logical_volume

# 4. Resize the file system to make use of the extended Logical Volume
sudo resize2fs /dev/my_volume_group/my_logical_volume

```

### **Expand a LVM partition**

## Creating a physical volume

```bash
[bob@centos-host ~]$ sudo su -
[root@centos-host ~]# pvs
  PV         VG Fmt  Attr PSize PFree
  /dev/vdb      lvm2 ---  1.00g 1.00g
[root@centos-host ~]# pvcreate /dev/vdc
  Physical volume "/dev/vdc" successfully created.
[root@centos-host ~]# pvcreate /dev/vdd
  Physical volume "/dev/vdd" successfully created.
[root@centos-host ~]# pvcreate /dev/vde
  Physical volume "/dev/vde" successfully created.
[root@centos-host ~]# pvs
  PV         VG Fmt  Attr PSize PFree
  /dev/vdb      lvm2 ---  1.00g 1.00g
  /dev/vdc      lvm2 ---  1.00g 1.00g
  /dev/vdd      lvm2 ---  1.00g 1.00g
  /dev/vde      lvm2 ---  1.00g 1.00g
[root@centos-host ~]# vi /home/bob/pvszie
[root@centos-host ~]# vi /home/bob/pvsize
[root@centos-host ~]# pvremove /dev/vde
  Labels on physical volume "/dev/vde" successfully wiped.
[root@centos-host ~]# pvs
  PV         VG Fmt  Attr PSize PFree
  /dev/vdb      lvm2 ---  1.00g 1.00g
  /dev/vdc      lvm2 ---  1.00g 1.00g
  /dev/vdd      lvm2 ---  1.00g 1.00g
[root@centos-host ~]# 

```

## Creating a volume group made of physical volumes

```bash
root@centos-host ~]# vgcreate volume1 /dev/vdb /dev/vdc
  A volume group called volume1 already exists.
[root@centos-host ~]# vgdisplay
  --- Volume group ---
  VG Name               volume1
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               1.99 GiB
  PE Size               4.00 MiB
  Total PE              510
  Alloc PE / Size       0 / 0   
  Free  PE / Size       510 / 1.99 GiB
  VG UUID               sd8qnX-BVXn-5Px8-Doi1-Kepn-9d1A-8jaIYf
   
[root@centos-host ~]# 

```

## Extending a volume group

```bash
[root@centos-host ~]# pvs
  PV         VG      Fmt  Attr PSize    PFree   
  /dev/vdb   volume1 lvm2 a--  1020.00m 1020.00m
  /dev/vdc   volume1 lvm2 a--  1020.00m 1020.00m
  /dev/vdd           lvm2 ---     1.00g    1.00g
[root@centos-host ~]# vgextend volume1 /dev/vdd
  Volume group "volume1" successfully extended
[root@centos-host ~]# pvs
  PV         VG      Fmt  Attr PSize    PFree   
  /dev/vdb   volume1 lvm2 a--  1020.00m 1020.00m
  /dev/vdc   volume1 lvm2 a--  1020.00m 1020.00m
  /dev/vdd   volume1 lvm2 a--  1020.00m 1020.00m
[root@centos-host ~]# 
```

### Creating a logical volume on top of volume group

```bash
[root@centos-host ~]# lvcreate -L +1.5G -n smalldata volume1
  Logical volume "smalldata" created.
[root@centos-host ~]# lvs
  LV        VG      Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  smalldata volume1 -wi-a----- 1.50g                                                    
[root@centos-host ~]# 
```

### Resizing a logical volume

`sudo lvresize --size 1G volume1/smalldata`
### Logical Volume Management (LVM)

Logical Volume Management (LVM) is a system for managing disk storage in a more flexible and efficient way than traditional partitioning methods. LVM allows you to create, resize, and manage disk storage volumes more easily, making it particularly useful for managing large storage environments.

### Key Components of LVM

1. **Physical Volume (PV):**
   - Physical Volumes are the raw physical storage devices (like hard drives, SSDs, or partitions) that are used in LVM.
   - They are initialized using the `pvcreate` command.
   - Example: `/dev/sda1`, `/dev/sdb1`

2. **Volume Group (VG):**
   - Volume Groups aggregate multiple Physical Volumes into a single storage pool.
   - You can create a Volume Group using the `vgcreate` command.
   - Example: `vg01`, `vg_data`

3. **Logical Volume (LV):**
   - Logical Volumes are the virtual partitions created from the space available in a Volume Group.
   - They act like traditional disk partitions but with more flexibility.
   - You can create a Logical Volume using the `lvcreate` command.
   - Example: `lv_home`, `lv_data`

### Creating and Managing LVM

#### 1. Preparing Physical Volumes

First, you need to initialize your physical storage devices as Physical Volumes (PVs).

```sh
sudo pvcreate /dev/sda1 /dev/sdb1
```

#### 2. Creating a Volume Group

Next, create a Volume Group (VG) by combining the Physical Volumes.

```sh
sudo vgcreate vg_data /dev/sda1 /dev/sdb1
```

#### 3. Creating Logical Volumes

With the Volume Group in place, you can create Logical Volumes (LVs).

```sh
sudo lvcreate -n lv_home -L 50G vg_data
sudo lvcreate -n lv_var -L 20G vg_data
```

In these commands:
- `-n` specifies the name of the Logical Volume.
- `-L` specifies the size of the Logical Volume.

#### 4. Formatting and Mounting Logical Volumes

After creating Logical Volumes, format them with a file system and mount them.

```sh
sudo mkfs.ext4 /dev/vg_data/lv_home
sudo mkfs.ext4 /dev/vg_data/lv_var

sudo mkdir /mnt/home
sudo mkdir /mnt/var

sudo mount /dev/vg_data/lv_home /mnt/home
sudo mount /dev/vg_data/lv_var /mnt/var
```

#### 5. Adding Entries to /etc/fstab

To ensure the Logical Volumes are mounted at boot time, add them to the `/etc/fstab` file.

```sh
/dev/vg_data/lv_home /mnt/home ext4 defaults 0 2
/dev/vg_data/lv_var  /mnt/var  ext4 defaults 0 2
```

### Advanced LVM Management

#### Resizing Logical Volumes

You can resize Logical Volumes, both increasing and decreasing their size.

**Increasing the Size:**

1. Extend the Logical Volume:
   ```sh
   sudo lvextend -L +10G /dev/vg_data/lv_home
   ```

2. Resize the File System:
   ```sh
   sudo resize2fs /dev/vg_data/lv_home
   ```

**Decreasing the Size:**

1. Resize the File System:
   ```sh
   sudo resize2fs /dev/vg_data/lv_home 40G
   ```

2. Reduce the Logical Volume:
   ```sh
   sudo lvreduce -L 40G /dev/vg_data/lv_home
   ```

#### Snapshots

LVM allows you to create snapshots of Logical Volumes. Snapshots can be used for backups or to create a consistent state of the file system.

1. Create a Snapshot:
   ```sh
   sudo lvcreate -s -n lv_home_snap -L 10G /dev/vg_data/lv_home
   ```

2. Mount the Snapshot:
   ```sh
   sudo mount /dev/vg_data/lv_home_snap /mnt/home_snap
   ```

#### Removing Logical Volumes, Volume Groups, and Physical Volumes

1. Unmount the Logical Volume:
   ```sh
   sudo umount /mnt/home
   ```

2. Remove the Logical Volume:
   ```sh
   sudo lvremove /dev/vg_data/lv_home
   ```

3. Remove the Volume Group:
   ```sh
   sudo vgremove vg_data
   ```

4. Remove the Physical Volume:
   ```sh
   sudo pvremove /dev/sda1
   ```

### Example Use Case

Let's assume you have two hard drives, `/dev/sda` and `/dev/sdb`, and you want to manage your storage using LVM to create separate logical volumes for `/home` and `/var`.

1. **Initialize Physical Volumes:**
   ```sh
   sudo pvcreate /dev/sda /dev/sdb
   ```

2. **Create a Volume Group:**
   ```sh
   sudo vgcreate vg_data /dev/sda /dev/sdb
   ```

3. **Create Logical Volumes:**
   ```sh
   sudo lvcreate -n lv_home -L 100G vg_data
   sudo lvcreate -n lv_var -L 50G vg_data
   ```

4. **Format the Logical Volumes:**
   ```sh
   sudo mkfs.ext4 /dev/vg_data/lv_home
   sudo mkfs.ext4 /dev/vg_data/lv_var
   ```

5. **Mount the Logical Volumes:**
   ```sh
   sudo mkdir /mnt/home
   sudo mkdir /mnt/var

   sudo mount /dev/vg_data/lv_home /mnt/home
   sudo mount /dev/vg_data/lv_var /mnt/var
   ```

6. **Add to `/etc/fstab`:**
   ```sh
   /dev/vg_data/lv_home /mnt/home ext4 defaults 0 2
   /dev/vg_data/lv_var  /mnt/var  ext4 defaults 0 2
   ```
