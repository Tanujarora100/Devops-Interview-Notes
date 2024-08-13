# Amazon Elastic File System (EFS)

## Overview
- **EFS** is a managed NFS (network file system) that can be mounted.
- **EFS** works with EC2 instances across **multiple AZs**.
- **EFS** is highly available, scalable, **but also more expensive (3x GP2) than EBS**.
- **Amazon EFS can be used in one VPC at a time only**.
- **EFS** enables you to control access (POSIX) permissions.


## Technical Details
- Uses **NFSv4.1** protocol.
  - You can tag your file system with a name, and these names don’t need to be unique.
- Security groups can be used to control access to EFS volumes.
- Can scale up to **petabytes** whereas EBS Volumes can go upto 64tb max in io2 block express.
- **AWS DataSync** provides a fast way to securely sync existing file systems with Amazon EFS.
- Number of file systems for each customer account in an AWS Region: **1000** but there is no limit on EBS Volumes.
- You can mount EFS filesystems onto EC2 instances running Linux or MacOS Big Sur. 
- **Windows is not supported, supported in EBS Volumes.**
- Aside from EC2 instances, you can also mount EFS filesystems on ECS tasks, EKS pods, and Lambda functions.
- **Amazon EFS** is designed to provide 99.999999999% (11 nines) of durability over a given year.
- Amazon EFS does not support the `nconnect` mount option.
- You can mount an Amazon EFS file system from on-premises data center servers using AWS Direct Connect and VPN.
- EFS performance mode cannot be changed after the EFS is created.

# DIFFERENCES WITH EBS:
- Windows not supported
- 3x Expensive
- Can scale to petabytes
- Security Groups can be attached
- Attached to multiple Instances
- POSIX file permissions used.
- Limit of 1000 per account compare to 5000 limit on EBS volumes.

## Data Transfer Across Regions
- You can use DataSync to transfer files between two Amazon EFS file systems, including ones in different AWS Regions.
- AWS Transfer Family endpoints must be in the same Region as your Amazon EFS file system.

## EFS Replication
- Keeps two file systems synchronized by automatically transferring only incremental changes without requiring additional infrastructure or a custom process.
- While EFS Replication is enabled, your applications can use the **replica file system in read-only mode for low network latency cross-Region access.**

## Data Consistency in EFS
- EFS provides the open-after-close consistency semantics that applications expect from NFS.
- Write operations will be durably stored across Availability Zones.
- Applications that perform synchronous data access and perform non-appending writes will have read-after-write consistency for data access.

## Backups
- During the initial backup, a copy of the entire file system is made in the backup vault.
- All subsequent backups of that file system are incremental in nature.
- File systems created using the Amazon EFS console are automatically backed up **daily through AWS Backup with a retention of 35 days**. 
- You can also disable automatic backups for your file systems at any time.

## Encryption
- Amazon EFS supports two forms of encryption for file systems: encryption of data in transit and encryption at rest.
- **You can enable encryption of data at rest when creating an Amazon EFS file system.**
- You can enable encryption of data in transit when you mount the file system.
- Encryption is not enabled by default on EFS.
- The mount helper initializes a client `stunnel` process. `Stunnel` is an open-source utility used for providing encryption for network communications. In this context, it acts as a multipurpose network relay.
  - The mount helper and the `stunnel` process use Transport Layer Security (TLS) version 1.2 to establish secure communication with the EFS file system. TLS is a cryptographic protocol that ensures the privacy and integrity of data exchanged over a network.

## Types of EFS
- **EFS Regional file systems** (recommended) offer the highest levels of durability and availability by storing data with and across multiple Availability Zones (AZs).
  - Automatic file backup is not by default in the EFS regional but it is the case in the one zone file system.
- **EFS One Zone file systems** store data redundantly within a single AZ, so data in these file systems will be unavailable and might be lost during a disaster or other fault within the AZ.
  - File systems using EFS One Zone storage classes are configured to automatically back up files by default at file system creation.

## EFS Performance and Storage Classes
### EFS Scale
- Thousands of concurrent NFS clients, 10 GB+ per second throughput.
- It can grow to petabyte scale NFS automatically.

### Performance Modes
- **General Purpose (default)**:
  - Recommended for latency-sensitive use cases: web server, CMS, etc.
  - Whenever we need lower latency, we should go for general purpose.
  - Suitable for under 100 EC2 Instances.
  - One Zone file systems always use the General Purpose performance mode.
  - For faster performance, we recommend always using General Purpose performance mode.
- **Max I/O**:
  - Higher latency.
  - Higher throughput or power.
  - Highly parallel processing power.
  - Recommended for big data, media processing.
  - Suitable for 100 or more EC2 instances.
  - Max I/O mode is not supported for One Zone file systems or file systems that use Elastic throughput.

### Throughput Modes
- **Bursting Throughput**:
  - Throughput scales as EFS grows.
  - Recommended for workloads that require throughput that scales with the amount of storage in your file system. 
  - The base throughput is proportionate to the file system's size in the Standard storage class, at a rate of 50 KiBps per each GiB of storage.
- **Provisioned Throughput**:
  - Fixed throughput independent of the size.
  - Suitable for web applications, development tools, web serving, or content management applications.
  - If content storage is less priority but access is of more use, then we should go for provisioned mode.

### Storage Tiers
- **Lifecycle Management Feature**:
  - **Standard**: For frequently accessed files.
  - **Infrequent Access (EFS-IA)**: There is a cost to retrieve files, lower price per storage.
  - **EFS Archive Class**:
    - The default recommended lifecycle policy will tier files from EFS Standard to EFS IA after 30 consecutive days without access and to EFS Archive after 90 consecutive days without access. You can also specify a custom policy for transitioning files between storage classes based on the number of days since a file’s last access.
    - You can also enable EFS Intelligent-Tiering to promote files from EFS IA and EFS Archive back to EFS Standard when they are accessed.

## EBS vs EFS
### EBS Volumes
- Can be attached to only one instance at a time.
- Are locked at the AZ level.
- **GP2**: IO increases if the disk size increases.
- **IO1**: Can increase IO independently.
- To migrate an EBS across AZ:
  - Take a snapshot.
  - Restore the volume from the snapshot.
- Root EBS volumes get terminated by default if the EC2 instance is terminated (this feature can be disabled).

### EFS
- Can be mounted to multiple instances across AZs via EFS mount targets.
- Available only for Linux instances.
- EFS has a higher price point than EBS.
- We can use the EFS with ECS Tasks to store the data, and ECS takes care of mounting the EFS on all the ECS Tasks.
- EFS is pay per second; we can leverage EFS-IA for cost saving.
- When the mode is checked, this cannot be later changed from provisioned to bursting or vice versa like we can in EBS Volumes.

## Mount Targets
- To access your EFS file system in a VPC, you create one or more mount targets in the VPC.
  - A mount target provides an IP address for an NFSv4 endpoint.
  - You can create one mount target in each Availability Zone in a region.
- You mount your file system using its DNS name, which will resolve to the IP address of the EFS mount target.
  - Format of DNS: `File-system-id.efs.aws-region.amazonaws.com`
- When using Amazon EFS with an on-premises server, your on-premises server must have a Linux-based operating system.

## Managing File Systems
- You can create encrypted file systems.
  - EFS supports encryption in transit and encryption at rest.
- **Regular Files**: The metered data size of a regular file is the logical size of the file rounded to the next 4-KiB increment, except that it may be less for sparse files.
  - A sparse file is a file to which data is not written to all positions of the file before its logical size is reached.
  - For a sparse file, if the actual storage used is less than the logical size rounded to the next 4-KiB increment, Amazon EFS reports actual storage used as the metered data size.
- **Directories**: The metered data size of a directory is the actual storage used for the directory entries and the data structure that holds them, rounded to the next 4 KiB increment. The metered data size doesn’t include the actual storage used by the file data.
- **Symbolic Links and Special Files**: The metered data size for these objects is always 4 KiB.
- **File System Deletion**: Deleting a file system is a destructive action that you can’t undo. You lose the file system and any data you have in it, and you can’t restore the data. You should always unmount a file system before you delete it.
- **Amazon CloudWatch Metrics**: Can monitor your EFS file system storage usage, including the size in each of the EFS storage classes.

## Access Using VPC
- When having multiple VPCs to access the EFS, ensure the CIDR ranges do not overlap and establish a peering connection between VPCs. Use the instances created in the new VPC to access the EFS with mount targets.
- The client's VPC and your EFS file system's VPC must be connected using either a VPC peering connection or a VPC transit gateway. When you use a VPC peering connection or transit gateway to connect VPCs, Amazon EC2 instances in one VPC can access EFS file systems in another VPC, even if the VPCs belong to different accounts.
- **Inter-region VPC peering is supported for EFS**.

## Issues While Connecting to EFS by Multiple VPCs
- Check the security groups of both EC2 instances and mount targets as these act as security groups and can act as virtual firewalls.
- The security group on a mount target must allow inbound access for TCP on the NFS port on which you want to mount it; otherwise, there will be a connection timeout.
- Number of security groups for each mount target is 5 and cannot be changed.
- Number of mount targets for each file system in an Availability Zone is one only.