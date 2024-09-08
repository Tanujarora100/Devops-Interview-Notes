The Databricks File System (DBFS) is a ==**distributed file system installed on Databricks clusters.**== DBFS leverages cloud storage to provide a scalable, secure, and managed data storage environment that is integrated with Databricks' analytics and AI capabilities.

It allows users to store data files, notebooks, libraries, and other arte2facts that are accessible across various Databricks workspaces and clusters.

DBFS ==simplifies file management in a distributed environment,== providing a familiar file system interface on top of the underlying cloud storage. It supports operations like reading, writing, moving, and deleting files and directories

**One of the primary tools for interacting with DBFS is `dbutils`,** a collection of utilities available in Databricks notebooks for various tasks, including file system operations.![Pasted image 20240304104135.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240304104135.png)

### How to Interact with DBFS Using `dbutils`

`dbutils` provides several commands for interacting with DBFS, making it easy to perform file operations directly from a Databricks notebook. Below is a detailed guide with examples on how to use these commands.

#### Accessing DBFS

To access DBFS, you can use the `dbutils.fs` module. This module provides functions to perform file operations similar to those you would use on a local file system.

#### Listing Files and Directories

To list files and directories in DBFS, you can use the `ls` command. This command displays the contents of a directory.

```python
# List the contents of the root directory of DBFS
dbutils.fs.ls("/")
```

```python
dbutils.fs.ls('/databricks-datasets')
```

```python
files = dbutils.fs.ls('/databricks-datasets')
print(files)
display(files)
```

#### Creating Directories

To create a new directory in DBFS, use the `mkdirs` command. This command creates the specified directory along with any necessary parent directories.

```python
# Create a new directory in DBFS
dbutils.fs.mkdirs("/my-new-directory")
```

#### Uploading and Downloading Files

You can upload files from your local file system to DBFS using the Databricks UI. However, to move files programmatically within DBFS or to download files to your local system, you can use the `cp` command for copying and the Databricks CLI for downloading.

```python
# Copy a file from one location in DBFS to another
dbutils.fs.cp("/my-source-directory/my-file.txt", "/my-destination-directory/my-file.txt")
```

#### Reading and Writing Files

To read and write files in DBFS, you can use Spark or any library that supports reading from/writing to Hadoop File System (HDFS) paths. Here's an example of writing and reading a text file using PySpark:

```python
# Writing to a file in DBFS
textData = ["Hello, Databricks!", "This is a text file in DBFS."]
sparkContext.parallelize(textData).saveAsTextFile("/my-directory/my-text-file.txt")

# Reading from a file in DBFS
textFileRDD = sparkContext.textFile("/my-directory/my-text-file.txt")
for line in textFileRDD.collect():
    print(line)

```

#### Deleting Files and Directories

To delete a file or directory in DBFS, use the `rm` command. This command removes files or directories (directories must be empty unless the recursive option is used).

```python
# Delete a file
dbutils.fs.rm("/my-directory/my-text-file.txt")

# Delete a directory recursively
dbutils.fs.rm("/my-directory", recurse=True)
```