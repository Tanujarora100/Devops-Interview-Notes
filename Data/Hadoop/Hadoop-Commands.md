Here’s a summary of some essential Hadoop commands and operations for working with HDFS, MapReduce, and YARN. These commands help manage files, monitor cluster health, and run jobs.

### **HDFS Commands**

HDFS commands are used to interact with the Hadoop Distributed File System. They are similar to UNIX commands.

#### **Basic File Operations**

- **List Files**: `hdfs dfs -ls [path]`
  - Lists files and directories in the specified path.
  - Example: `hdfs dfs -ls /user/hadoop/`

- **Make Directory**: `hdfs dfs -mkdir [path]`
  - Creates a new directory in HDFS.
  - Example: `hdfs dfs -mkdir /user/hadoop/newdir`

- **Remove Directory/File**: `hdfs dfs -rm [-r] [path]`
  - Deletes files or directories. Use `-r` to remove directories recursively.
  - Example: `hdfs dfs -rm /user/hadoop/oldfile`

- **Copy Local to HDFS**: `hdfs dfs -copyFromLocal [local_path] [hdfs_path]`
  - Copies a file from the local filesystem to HDFS.
  - Example: `hdfs dfs -copyFromLocal /localpath/file.txt /user/hadoop/`

- **Copy HDFS to Local**: `hdfs dfs -copyToLocal [hdfs_path] [local_path]`
  - Copies a file from HDFS to the local filesystem.
  - Example: `hdfs dfs -copyToLocal /user/hadoop/file.txt /localpath/`

- **Move File**: `hdfs dfs -moveFromLocal [local_path] [hdfs_path]`
  - Moves a file from the local filesystem to HDFS (deletes the local file).
  - Example: `hdfs dfs -moveFromLocal /localpath/file.txt /user/hadoop/`

- **Get File Status**: `hdfs dfs -stat [path]`
  - Displays file status (similar to `ls -l` in UNIX).
  - Example: `hdfs dfs -stat /user/hadoop/file.txt`

- **Tail File**: `hdfs dfs -tail [path]`
  - Displays the last part of a file.
  - Example: `hdfs dfs -tail /user/hadoop/logfile.txt`

#### **Directory Operations**

- **Remove Empty Directory**: `hdfs dfs -rmdir [path]`
  - Removes an empty directory.
  - Example: `hdfs dfs -rmdir /user/hadoop/emptydir`

- **Change Permissions**: `hdfs dfs -chmod [permissions] [path]`
  - Changes the permissions of a file or directory.
  - Example: `hdfs dfs -chmod 755 /user/hadoop/dir`

- **Change Ownership**: `hdfs dfs -chown [owner:group] [path]`
  - Changes the owner and/or group of a file or directory.
  - Example: `hdfs dfs -chown user:group /user/hadoop/dir`

### **MapReduce Commands**

MapReduce commands are used to run and manage MapReduce jobs.

- **Run MapReduce Job**: `hadoop jar [jar_file] [main_class] [args]`
  - Submits a MapReduce job for execution.
  - Example: `hadoop jar /path/to/your.jar com.example.YourClass input output`

- **Check Job Status**: `hadoop job -status [job_id]`
  - Displays the status of a specific MapReduce job.
  - Example: `hadoop job -status job_1234567890123_0001`

- **Kill Job**: `hadoop job -kill [job_id]`
  - Terminates a running MapReduce job.
  - Example: `hadoop job -kill job_1234567890123_0001`

- **List Jobs**: `hadoop job -list`
  - Lists all MapReduce jobs in the cluster.
  - Example: `hadoop job -list`

- **Get Job Configuration**: `hadoop job -conf [job_id]`
  - Displays configuration details for a specific MapReduce job.
  - Example: `hadoop job -conf job_1234567890123_0001`

### **YARN Commands**

YARN commands are used to manage and monitor the cluster resources and applications.

- **ResourceManager Status**: `yarn resourcemanager -status`
  - Displays the status of the ResourceManager.
  - Example: `yarn resourcemanager -status`

- **NodeManager Status**: `yarn nodemanager -status`
  - Displays the status of NodeManagers.
  - Example: `yarn nodemanager -status`

- **Application Status**: `yarn application -status [application_id]`
  - Displays the status of a specific YARN application.
  - Example: `yarn application -status application_1234567890123_0001`

- **List Applications**: `yarn application -list`
  - Lists all YARN applications.
  - Example: `yarn application -list`

- **Kill Application**: `yarn application -kill [application_id]`
  - Terminates a running YARN application.
  - Example: `yarn application -kill application_1234567890123_0001`

### **HDFS Administration Commands**

These commands are used for administrative tasks related to HDFS.

- **Format NameNode**: `hdfs namenode -format`
  - Formats the NameNode (initial setup or reformatting).
  - Example: `hdfs namenode -format`

- **Check Health**: `hdfs fsck [path]`
  - Checks the health of the HDFS filesystem and reports block information.
  - Example: `hdfs fsck / -files -blocks -locations`

- **Balancing**: `hdfs balancer`
  - Balances the data across DataNodes to ensure even distribution.
  - Example: `hdfs balancer`

### **Summary**

- **HDFS Commands**: Manage files and directories in HDFS.
- **MapReduce Commands**: Submit and manage MapReduce jobs.
- **YARN Commands**: Monitor and manage YARN applications and cluster resources.
- **HDFS Administration**: Perform administrative tasks like formatting and balancing.
