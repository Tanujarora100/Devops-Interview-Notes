

## **List, Create, Delete, and Modify Physical Storage Partitions**

### **Listing Partitions**
  ```bash
  lsblk
  fdisk -l 
  ```

### **Creating Partitions**
- **Using `fdisk`**:
  ```bash
  sudo fdisk /dev/sdX
  ```
### **Deleting Partitions**
- **Using `fdisk`**:
  ```bash
  sudo fdisk /dev/sdX
  ```
  - Enter `d` to delete a partition.
  - Enter `w` to write changes.

### **Modifying Partitions**
- **Resizing with `parted`**:
  ```bash
  sudo parted /dev/sdX
  ```
  - Enter `resizepart NUMBER END` to resize a partition.
  - Parted does not need the deletion of the partition by fdisk does.

- **Resizing with `fdisk`** (requires deletion and recreation):
  ```bash
  sudo fdisk /dev/sdX
  ```
  - Delete the partition and recreate it with the new size.

## **Configure and Manage Swap Space**

### **Creating Swap Space**
- **Creating a Swap Partition**:
  ```bash
  sudo fdisk /dev/sdX
  ```
  - Create a new partition and set the type to `82` (Linux swap).
  -  `82 type is for swap space`.
  - Format the partition:
    ```bash
    sudo mkswap /dev/sdXn
    ```
  - Enable the swap:
    - Swapon is used to enable the swap space. 
    ```bash
    sudo swapon /dev/sdXn
    ```

  - **Creating a Swap File**:
    ```bash
    sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
    sudo mkswap /swapfile
    sudo swapon /swapfile
    ```

### **Managing Swap Space**
- **Check Swap Space**:
  ```bash
  free -h
  ```
- **Enable Swap at Boot**:
  - Add to `/etc/fstab`:
  ```bash
  /swapfile swap swap defaults 0 0
  ```

# **Manage and Configure LVM Storage**

### **Creating LVM Components**
- **Create Physical Volumes**:
  ```bash
  sudo pvcreate /dev/sdX1 /dev/sdX2
  ```
- **Create Volume Group**:
  ```bash
  sudo vgcreate myvg /dev/sdX1 /dev/sdX2
  ```
- **Create Logical Volume**:
  ```bash
  sudo lvcreate -L 10G -n mylv myvg
  ```

### **Managing LVM**
- **Extend Logical Volume**:
  ```bash
  sudo lvextend -L +5G /dev/myvg/mylv
  sudo resize2fs /dev/myvg/mylv
  ```
- **Reduce Logical Volume** (requires unmounting):
  ```bash
  sudo lvreduce -L -5G /dev/myvg/mylv
  sudo resize2fs /dev/myvg/mylv
  ```

## **Create and Configure Encrypted Storage**

### **Creating Encrypted Volume**
- **Encrypting a Partition**:
  ```bash
  sudo cryptsetup luksFormat /dev/sdXn
  sudo cryptsetup luksOpen /dev/sdXn my_encrypted_volume
  sudo mkfs.ext4 /dev/mapper/my_encrypted_volume
  ```

### **Mounting Encrypted Volume**
- **Mounting**:
  ```bash
  sudo cryptsetup luksOpen /dev/sdXn my_encrypted_volume
  sudo mount /dev/mapper/my_encrypted_volume /mnt
  ```

## **Create and Manage RAID Devices**

### **Creating RAID**
- **Using `mdadm`**:
  ```bash
  sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdX1 /dev/sdX2
  ```

### **Managing RAID**
- **Check RAID Status**:
  ```bash
  cat /proc/mdstat
  ```
- **Add Disk to RAID**:
  ```bash
  sudo mdadm --manage /dev/md0 --add /dev/sdX3
  ```

## **Manage and Diagnose Advanced File System Permissions**

### **Setting Permissions**
- **Using `chmod`**:
  ```bash
  sudo chmod 755 /path/to/file
  ```
- **Using `chown`**:
  ```bash
  sudo chown user:group /path/to/file
  ```

### **Diagnosing Permissions**
- **Using `ls -l`**:
  ```bash
  ls -l /path/to/file
  ```

## **Setup User and Group Disk Quotas for Filesystems**

### **Configuring Quotas**
- **Enable Quotas on Filesystem**:
  - Edit `/etc/fstab` to add `usrquota` and `grpquota` options.
  - Remount the filesystem:
  ```bash
  sudo mount -o remount /mountpoint
  ```
- **Initialize Quota Database**:
  ```bash
  sudo quotacheck -cug /mountpoint
  sudo quotaon /mountpoint
  ```

### **Managing Quotas**
- **Set Quota for User**:
  ```bash
  sudo edquota -u username
  ```
- **Set Quota for Group**:
  ```bash
  sudo edquota -g groupname
  ```
