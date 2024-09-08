Hadoop Distributed File System (HDFS) is designed to store and manage large volumes of data across multiple machines, providing high-throughput access to data and fault tolerance. ==The architecture of HDFS is based on the master-slave model and consists of several key components:==

### Key Components of HDFS:

1. **NameNode**:
    - **Role**: The master server that manages the filesystem namespace and regulates access to files by clients.
    - **Functions**: ==Maintains the metadata of the filesystem (e.g., directory structure, file permissions, and file-to-block mappings). It does not store the actual data of these files.==
    - **High Availability**: In a high-availability setup, there are two NameNodes: an active NameNode and a standby NameNode to ensure fault tolerance.
- **DataNode**:
    - **Role**: The slave servers that store actual data blocks of HDFS files.
    - **==Functions**: Serve read and write requests from clients and perform block creation, deletion, and replication upon instruction from the NameNode.==
    - **Heartbeat**: Regularly sends heartbeats and block reports to the NameNode to confirm its status and provide block information.
- **Secondary NameNode**:
    - **Role**: Not a direct backup to the NameNode but assists in housekeeping functions for the NameNode.
    - **Functions**: Periodically merges the namespace image with the edit log to prevent the edit log from becoming too large. This reduces the NameNode’s restart time.
- **Checkpoint Node** (optional):    
    - ==**Role**: Similar to the Secondary NameNode, it creates periodic checkpoints of the HDFS metadata.==
    - **Functions**: Can be configured to perform the same functions as the Secondary NameNode but runs separately to provide more frequent checkpoints.
- **Journal Node**:
    - **Role**: Used in HDFS high-availability setups.
    - **Functions**: Keeps a log of changes (edits) made by the active NameNode. ==The standby NameNode reads these logs to stay synchronised with the active NameNode.== This maintains all the logs and these logs are actually read by the Standby Namenode to be updated.
![[Pasted image 20240612114650.png]]

### HDFS VS NAS

- Network-attached storage (NAS) is a ==file-level computer data storage server ==connected to a computer network providing data access to a heterogeneous group of clients. 
	- NAS can either be a hardware or software which provides services for storing and accessing files. 
	- ==Whereas Hadoop Distributed File System (HDFS) is a distributed filesystem to store data using commodity hardware.==
- In HDFS Data Blocks are distributed across all the machines in a cluster. 
	- In NAS entire data is on the single machine.
- HDFS is designed to work with MapReduce paradigm, where computation is moved to the data. 
	- NAS is not suitable for MapReduce since data is stored separately from the computations.
	- There is no concept of master and slave in NAS Storage.
- HDFS uses commodity hardware which is cost-effective, whereas a NAS is a high-end storage devices which includes high cost.