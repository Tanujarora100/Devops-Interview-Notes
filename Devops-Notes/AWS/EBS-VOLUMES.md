## Amazon EBS Overview

### General Characteristics
- **Volume:** A collection of blocks, each with a unique identifier.
- **Attachment:** Both encrypted and unencrypted volumes can be attached to an EC2 instance simultaneously.
- **Mountable and Bootable:** Block storage is **mountable and bootable**.

### EBS Volume Specifics
- **Single Instance Mount:** EBS volumes can only be mounted to one instance at a time
  - except for EBS multi-attach.
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
  - However, you can migrate data between encrypted and unencrypted volumes.
## Snapshots
- Snapshots are incremental
- EBS backups use IO and we should not run them while the application is handling a lot of traffic
- Snapshots are stored in S3 (we are not able to see them)
- It is not necessary to detach the volume to do a snapshot, but it is recommended
-  EBS volumes restored from snapshots need to be pre-warmed (using fio or dd commands to read the entire volume)
- You can’t delete a snapshot of the root device of an EBS volume used by a registered AMI. You must first deregister the AMI before you can delete the snapshot.
- Snapshots can be automated using Amazon Data Lifecycle Manage




#### Instance Store Volumes
- Provides block storage devices, raw volumes which can be mounted to a system
- They are similar to EBS, but they are local drives instead of being presented over the network
- These volumes are physically connected to the EC2 host, instances on the host can access these volumes
- **Provides the highest storage performance in AWS**
-- Instance stores are included in the price of EC2 instances with which they come with
  - Instance stores have to be attached at launch time, they can not be added afterwards!
- If an EC2 instance moves between hosts the instance store volume loses all its data


##### Instance store considerations:
- Instance store volumes are local to EC2 hosts
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