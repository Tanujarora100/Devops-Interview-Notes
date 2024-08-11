## Amazon EBS Overview

### General Characteristics
- **Attachment:** Both encrypted and unencrypted volumes can be attached to an EC2 instance simultaneously.
- **Mountable and Bootable:**

### EBS Volume Specifics
- **Single Instance Mount:** 
  - only be mounted to one instance at a time
  - **except for EBS multi-attach.**
  - exclusively on (io1 and io2) volumes
  - can't be created as boot volumes.
  - We need to take care of concurrency.

- **Availability Zone Bound:** bound to an Availability Zone
- **Instance Termination:** By default, the root EBS volume is deleted upon instance termination, while other attached volumes are not (can be overridden using the `DeleteOnTermination` attribute).
- **Replication:** To replicate an EBS volume across AZ or region, a snapshot must be copied.
  - take a snapshot
  - make a new ebs volume
  - attach it to the new instance.

### EBS Volume Upgrade
- **Modifications:** Increase volume size, change volume type, or adjust performance without detaching.
- **Charges:** No charge to modify the configuration.
- **Modification Time:** Can take from a few minutes to several hours, depending on the changes.
- **Size Changes:** Only volume size can be increased, not decreased.
- **Performance Changes:** Volume performance can be increased or decreased, but not the size.


### EBS Volume Types

#### General Purpose SSD
- **Balance of Price and Features:**
  - **Storage:** 1 GB - 16 TB
  - **Multi-Attach:** Not supported

- **gp3:**
  - **Baseline IOPS:** 3,000 (max 16,000, independent of size)
  - **Cost:** 20% lower than gp2
  - **Availability:** Not available in all regions

- **gp2:**
  - **Burst IOPS:** Up to 3,000
  - **IOPS per GB:** 3
  - **Max IOPS:** 16,000 (at 5,334 GB)
  - **Cost:** More expensive than gp3

#### Provisioned IOPS SSD
- **Optimized for Transaction-Intensive Applications:**
  - **Examples:** Banking, Payment applications
  - **Multi-Attach:** Supported

- **io1 or io2:**
  - **Storage:** 4 GB - 16 TB
  - **Max IOPS:** 64,000 for Nitro EC2 instances & 32,000 for non-Nitro
  - **IOPS per GB:** 50
  - **Durability:** io2 is more durable than io1

- **io2 Block Express:**
  - **Storage:** 4 GiB - 64 TB
  - **Latency:** Sub-millisecond
  - **Max IOPS:** 256,000
  - **IOPS per GB:** 1000

#### Hard Disk Drives (HDD)
- **Optimized for Throughput-Intensive Applications:**
  - **Examples:** Big Data, Data Warehousing, Log Processing
  - **Performance:** Lowest but cheaper
  - **Bootable:** Cannot be used as a boot volume

- **st1 (Throughput Optimized HDD):**
  - **Max Throughput:** 500 MB/s
  - **Max IOPS:** 500

- **sc1 (Cold HDD):**
  - **For Infrequently Accessed Data:**
    - **Max Throughput:** 250 MB/s
    - **Max IOPS:** 250

- **Magnetic Generation Volumes:**
  - **Suited for Small Data Sets:**
    - **Performance:** Approx. 100 IOPS
### EBS ENCRYPTION
- EBS encryption is only available on certain instance types.
- There is no direct way to encrypt an existing unencrypted volume, or to remove encryption from an encrypted volume. 
  - **However, you can migrate data between encrypted and unencrypted volumes.**
## Snapshots
- Snapshots are incremental
- Snapshots are stored in S3 (we are not able to see them)
- It is not necessary to detach the volume to do a snapshot, but it is recommended
-  EBS volumes restored from snapshots need to be pre-warmed (using fio or dd commands to read the entire volume)
- You can’t delete a snapshot of the root device of an EBS volume used by a registered AMI. You must first deregister the AMI before you can delete the snapshot.
- Snapshots can be automated using **Amazon Data Lifecycle Manage**




#### Instance Store Volumes

- They are similar to EBS, but they are local drives instead of being presented over the network
- These volumes are physically connected to the EC2 host
- **Provides the highest storage performance in AWS**
-- Instance stores are included in the price of EC2 instances with which they come with
  - Instance stores have to be attached at launch time, they can not be added afterwards!
- If an EC2 instance moves between hosts the instance store volume loses all its data


##### Instance store considerations:
- Instance store can be added only at launch
- Data is lost on an instance stores in case the instance is moved, resized or there is a hardware failure
- For instance store volumes we pay for it with the EC2 instance
- For super high performance we should use instance store
- If cost is a primary concern we can use instance store if it comes with the EC2 instance
- Cost consideration: cheaper volumes: ST1 or SC1
- Throughput or streaming: ST1
- Boot volumes: HDD based volumes are not supported (no ST1 or SC1)
RAID0 + EBS: up to 260000 IOPS (maximum possible IOPS per EC2 instance)
- **For more than 260000 IOPS - use instance store**

Resizing the root EBS volume of an EC2 instance involves a few steps, including stopping the instance, modifying the volume, and then resizing the filesystem to utilize the additional space. Here's a detailed guide on how to do this:

### Step 1: Stop the Instance (if necessary)
For some Linux distributions, you can resize the volume without stopping the instance. However, for safety and to avoid any data corruption, it's recommended to stop the instance.

1. **Stop the Instance**:
   - Go to the EC2 Dashboard.
   - Select the instance you want to resize.
   - Click on `Instance State` and then `Stop`.

### Step 2: Modify the Volume
1. **Navigate to Volumes**:
   - In the EC2 Dashboard, select `Volumes` under the `Elastic Block Store` section.

2. **Select the Root Volume**:
   - Find the root EBS volume attached to your instance. The root volume typically has the device name `/dev/xvda` or `/dev/sda1`.

3. **Modify the Volume**:
   - Select the volume and click on `Actions` > `Modify Volume`.
   - Enter the new desired size for the volume in the `Size` field.
   - Click `Modify` and then `Yes` to confirm.

### Step 3: Resize the Filesystem
After modifying the volume, you need to resize the filesystem to use the new space. This can be done without stopping the instance for modern Linux distributions using `growpart` and `resize2fs` (for ext4 filesystems) or `xfs_growfs` (for XFS filesystems).

#### For ext4 Filesystems:
1. **Connect to Your Instance**:
   - Start the instance if it's stopped and connect via SSH.

2. **Install growpart (if not installed)**:
   ```sh
   sudo yum install cloud-utils-growpart   # For Amazon Linux
   sudo apt-get install cloud-guest-utils  # For Ubuntu/Debian
   ```

3. **Grow the Partition**:
   ```sh
   sudo growpart /dev/xvda 1
   ```

4. **Resize the Filesystem**:
   ```sh
   sudo resize2fs /dev/xvda1
   ```

#### For XFS Filesystems:
1. **Connect to Your Instance**:
   - Start the instance if it's stopped and connect via SSH.

2. **Resize the Filesystem**:
   ```sh
   sudo xfs_growfs -d /
   ```

### Verification
1. **Check the Filesystem**:
   ```sh
   df -h
   ```

   This command will display the disk space usage and should reflect the new size of your root EBS volume.

### Example
Here's a full example for resizing a root volume on an instance using an ext4 filesystem:

1. **Stop the Instance**:
   ```sh
   aws ec2 stop-instances --instance-ids i-1234567890abcdef0
   ```

2. **Modify the Volume**:
   ```sh
   aws ec2 modify-volume --volume-id vol-12345678 --size 50
   ```

3. **Start the Instance**:
   ```sh
   aws ec2 start-instances --instance-ids i-1234567890abcdef0
   ```

4. **Connect to the Instance**:
   ```sh
   ssh ec2-user@your-instance-public-dns
   ```

5. **Resize the Filesystem**:
   ```sh
   sudo growpart /dev/xvda 1
   sudo resize2fs /dev/xvda1
   ```

6. **Verify**:
   ```sh
   df -h
   ```
