### Spark DataFrame

A DataFrame is the most common Structured API or High Level API and simply represents a table of data with rows and columns.  
![Pasted image 20231127201907.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231127201907.png)

The DataFrame concept is not unique to Spark. R and Python both have similar concepts. However, Python/R DataFrames (with some exceptions) exist on one machine rather than multiple machines.

However, because Spark has language interfaces for both Python and R, it’s quite easy to convert Pandas (Python) DataFrames to Spark DataFrames, and R DataFrames to Spark DataFrames.

## Data Frame VS DataSet
**DataFrames**
- **Structure:** 
	- ==DataFrames are schema-flexible. They can infer the schema of your data during runtime==
- **API:** DataFrames offer a high-level, SQL-like API for working with data
- **Supported Languages:** DataFrames are widely supported across Spark programming languages like Scala, Java, Python, and R. 
- ==Not type safe in nature.==

**Datasets**

- **Structure:** 
	- However, Datasets are strongly typed. This means the schema and data types of each column are explicitly defined at compile time. 
	- This enforces type safety, preventing runtime errors due to data type mismatches.
- **Schema Enforcement:** The strict schema definition in Datasets ensures data consistency
- **Functional Programming:** work well with functional programming paradigms in Scala and Java. 
- **Language Support:** Dataset support is primarily focused on Scala and Java.
### SPARK INPUT PARTITIONS
**128 MB Partitions (Input/Output):**

- These 128 MB partitions are related to how Spark reads data from storage systems like HDFS (Hadoop Distributed File System) or local file systems.
- When you use Spark to read data from a file, Spark doesn't process the entire file at once. 
	- Instead, it splits the file into smaller, more manageable chunks. 
	- These chunks are often referred to as **input partitions**.
- ==The default size of these input partitions is typically 128 MB, although you can configure it using the `spark.sql.files.maxPartitionBytes` parameter.==
- ==These input partitions are essentially logical divisions of the data for parallel processing. 
	- Each partition can be processed by a separate Spark executor, enabling efficient data loading.==
![[Pasted image 20240618220811.png]]