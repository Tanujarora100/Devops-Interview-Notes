### **Basic Hadoop Architecture**

Hadoop architecture is designed to handle large-scale data processing and storage efficiently across a distributed cluster. Here’s a breakdown of its core components and how they interact:

#### **1. Hadoop Distributed File System (HDFS)**

**Purpose**: HDFS is designed to store vast amounts of data across a distributed cluster of machines. It provides high throughput access to data and is optimized for large files.

- **NameNode**: The master server that manages the metadata of HDFS. It keeps track of the file system's namespace, directory structure, and the mapping of files to blocks. It does not store the actual data but maintains information about where data is stored across the cluster.
  
- **DataNode**: These are the worker nodes that store the actual data blocks. Each DataNode periodically sends heartbeat signals and block reports to the NameNode to update its status and the list of blocks it holds.

- **Secondary NameNode**: This node periodically merges the namespace image with the edit logs to create a new checkpoint. It helps in recovering the NameNode in case of failures but does not serve client requests.

**How It Works**:
- **Data Storage**: Files are split into large blocks (typically 128 MB or 256 MB). These blocks are replicated across multiple DataNodes (default replication factor is 3) to ensure data durability and fault tolerance.
- **Data Retrieval**: When a client requests a file, the NameNode provides the locations of the blocks, and the client directly communicates with the DataNodes to read the data.

#### **2. MapReduce**

**Purpose**: MapReduce is a programming model for processing large datasets with a distributed algorithm. It breaks down tasks into smaller sub-tasks that can be processed in parallel across a cluster.

- **JobTracker (in older versions)**: Manages the scheduling and resource allocation for MapReduce jobs. It coordinates job execution and monitors task progress.

- **TaskTracker (in older versions)**: Executes tasks assigned by the JobTracker. It periodically sends progress reports and heartbeats to the JobTracker.

- **ResourceManager (in YARN)**: Manages cluster resources and job scheduling. It allocates resources to different applications and handles resource requests.

- **NodeManager (in YARN)**: Manages the execution of tasks on individual nodes. It reports resource usage and health to the ResourceManager.

- **ApplicationMaster (in YARN)**: Manages the lifecycle of a specific application. It negotiates resources with the ResourceManager and monitors the execution of tasks.

**How It Works**:
- **Map Phase**: The input data is divided into chunks, and each chunk is processed by a Mapper. Mappers generate intermediate key-value pairs.
- **Shuffle and Sort**: Intermediate data is shuffled and sorted based on keys. This phase groups all values associated with the same key together.
- **Reduce Phase**: Reducers process the grouped data, aggregating and summarizing it to produce the final output.

#### **3. YARN (Yet Another Resource Negotiator)**

**Purpose**: YARN is the resource management and job scheduling layer for Hadoop. It improves the scalability and resource utilization of Hadoop clusters.

- **ResourceManager**: Manages and allocates cluster resources among various applications. It ensures efficient use of resources and schedules jobs based on the resource availability.
  
- **NodeManager**: Runs on each node and is responsible for managing resources and monitoring the health of the node. It handles task execution and reports resource usage to the ResourceManager.

- **ApplicationMaster**: Manages individual applications, including job scheduling and monitoring. It negotiates resources with the ResourceManager and tracks the application's progress.

**How It Works**:
- **Resource Allocation**: When an application submits a job, the ResourceManager allocates resources based on the application's requirements and the cluster's current resource availability.
- **Task Execution**: The ApplicationMaster requests resources from the ResourceManager and manages task execution on the allocated resources.

#### **4. Basic Hadoop Architecture Workflow**

1. **Data Storage**:
   - Files are split into blocks and stored across multiple DataNodes in HDFS.
   - The NameNode maintains metadata and keeps track of block locations.

2. **Data Processing**:
   - A MapReduce job is submitted to the ResourceManager in YARN.
   - The ApplicationMaster negotiates resources and manages the job execution.
   - The Map phase processes data in parallel, generating intermediate key-value pairs.
   - The Shuffle and Sort phase groups and organizes data.
   - The Reduce phase aggregates and processes the data to produce the final result.

3. **Resource Management**:
   - The ResourceManager allocates resources to applications and manages cluster resources.
   - NodeManagers handle task execution on individual nodes and report status to the ResourceManager.

