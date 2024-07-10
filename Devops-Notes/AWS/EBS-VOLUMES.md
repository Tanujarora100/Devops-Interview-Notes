## Amazon EBS Overview

### General Characteristics
- **Volume:** A collection of blocks, each with a unique identifier.
- **Filesystem:** Created on top of the volume at the OS level.
- **Persistence:** Volumes persist independently of the running life of an EC2 instance.
- **Attachment:** Both encrypted and unencrypted volumes can be attached to an EC2 instance simultaneously.
- **Mountable and Bootable:** Block storage is mountable and bootable.

### EBS Volume Specifics
- **Single Instance Mount:** EBS volumes can only be mounted to one instance at a time, except for EBS multi-attach.
- **Concurrency:** When attaching volumes to multiple instances, concurrency must be managed to avoid data corruption.
- **Availability Zone Bound:** Volumes are bound to an Availability Zone, and data is lost if the entire zone goes down.
- **Provisioning:** Capacity must be provisioned in advance (size in GB & throughput in IOPS).
- **Scaling:** No option for scaling as per use.
- **Instance Termination:** By default, the root EBS volume is deleted upon instance termination, while other attached volumes are not (can be overridden using the `DeleteOnTermination` attribute).
- **Replication:** To replicate an EBS volume across AZ or region, a snapshot must be copied.

### EBS Volume Upgrade
- **Modifications:** Increase volume size, change volume type, or adjust performance without detaching the volume or restarting the instance if Elastic Volumes are supported.
- **Charges:** No charge to modify the configuration; charged for the new configuration after modification starts.
- **Modification Time:** Can take from a few minutes to several hours, depending on the changes.
- **Cancellation:** Volume modification requests cannot be canceled once submitted.
- **Size Changes:** Only volume size can be increased, not decreased.
- **Performance Changes:** Volume performance can be increased or decreased, but not the size.
- **Type Changes:** Changing from gp2 to gp3 without specifying IOPS or throughput provisions the gp3 volume with either equivalent performance or baseline gp3 performance, whichever is higher.

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

#### Instance Store Volumes
- Provides block storage devices, raw volumes which can be mounted to a system
- They are similar to EBS, but they are local drives instead of being presented over the network
- These volumes are physically connected to the EC2 host, instances on the host can access these volumes
- **Provides the highest storage performance in AWS**
-- Instance stores are included in the price of EC2 instances with which they come with
  - Instance stores have to be attached at launch time, they can not be added afterwards!
- If an EC2 instance moves between hosts the instance store volume loses all its data
One of the primary benefit of instance stores is performance, ex: D3 instance provides 4.6 GB/s throughput, I3 volumes provide 16 GB/s of sequential throughput with NVMe SSD
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