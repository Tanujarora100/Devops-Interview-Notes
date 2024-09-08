### Key Concepts of Delta Lake

1. **Storage Layer**:
    - Delta Lake sits on top of cloud storage systems like S3, ADLS, or GCS. **It uses these systems to store the actual data files.**
    - The data itself is typically stored in a ==columnar format like Parquet.
2. **Structured Tables**:
    - Delta Lake organizes data into structured tables,==providing a schema and metadata management.==
    - Tables in Delta Lake can be queried and manipulated using SQL, just like traditional databases.
3. **Delta Tables**:
    - These are the primary unit of storage in Delta Lake. 
    - A Delta Table is a collection of data files (usually in Parquet format) along with a transaction log that maintains the state of the table.
    - Delta Tables support standard SQL operations, including `SELECT`, `INSERT`, `UPDATE`, and `DELETE`.
### How Delta Lake Works with Storage Systems

- **Physical Storage**:
    - The raw data is stored in the cloud storage (S3, ADLS, etc.) as Parquet files.
    - Delta Lake ==maintains a transaction log (also stored in the cloud storage) that tracks all changes to the data (such as inserts, updates, and deletes).==
- **Logical Layer**:
    - Delta Lake provides a logical layer that enables users to interact with the data as if it were a traditional database table.
    - This logical layer ensures ACID transactions, allowing multiple users to read and write data concurrently without compromising data integrity.
#### Create and Write to Delta Table
```python
# Configure the storage account
spark.conf.set("fs.azure.account.key.<account_name>.dfs.core.windows.net", "<access_key>")

# Define the path to the Delta Table in ADLS
delta_table_path = "abfss://<container>@<account_name>.dfs.core.windows.net/delta-table"

# Create a DataFrame
data = [("Alice", 34), ("Bob", 45), ("Catherine", 29)]
df = spark.createDataFrame(data, ["Name", "Age"])

# Write the DataFrame to a Delta Table
df.write.format("delta").mode("overwrite").save(delta_table_path)

```

### Creation of Delta Path
```sql
spark.sql(f"""
CREATE TABLE delta_table
USING delta
LOCATION '{delta_table_path}'
""")

```

### Key Features of Delta Lake

- **ACID Transactions**: Delta Lake ensures atomicity, consistency, isolation, and durability of data operations, enabling concurrent reads and writes and making data corruption almost impossible.
- **Scalable Metadata Handling**: It can handle petabytes of data and billions of files without a decline in performance, thanks to its scalable metadata management.
- **Schema Enforcement and Evolution**: Delta Lake enforces schema on write, ensuring data quality and consistency. It also allows for the evolution of your data schema without breaking existing pipelines.
- **Time Travel (Data Versioning)**: Delta Lake maintains a history of transactions, which allows you to access and restore previous versions of your data, crucial for auditing, rollbacks, and reproducing experiments.
- **Unified Batch and Streaming Sources and Sinks**: It can serve as a source and sink for both batch and streaming data, making it easier to build complex data pipelines.

![Pasted image 20240304111558.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240304111558.png)

### Delta Lake Transaction Logs

The Delta Lake transaction log (also known as the `DeltaLog`) is an ordered record of every transaction that has ever been performed on a Delta Lake table since its inception.

##### What Is the Transaction Log Used For?

###### Single Source of Truth

Delta Lake is built on top of Apache Spark™ in order to allow multiple readers and writers of a given table to all work on the table at the same time. In order to show users correct views of the data at all times, the Delta Lake transaction log serves as a **single source of truth** - the central repository that tracks all changes that users make to the table.

###### The Implementation of Atomicity on Delta Lake

One of the four properties of ACID transactions, **atomicity**, guarantees that operations (like an INSERT or UPDATE) performed on your data lake either complete fully, or don’t complete at all.

**The transaction log is the mechanism through which Delta Lake is able to offer the guarantee of atomicity.** For all intents and purposes, if it’s not recorded in the transaction log, it never happened

## How Does the Transaction Log Work?

##### Breaking Down Transactions Into Atomic Commits

Whenever a user performs an operation to modify a table (such as an INSERT, UPDATE or DELETE), Delta Lake breaks that operation down into a series of discrete steps composed of one or more of the **actions** below.

- **Add file** - adds a data file.
- **Remove file** - removes a data file.
- **Update metadata** - Updates the table’s metadata (e.g., changing the table’s name, schema or partitioning).
- **Set transaction** - Records that a structured streaming job has committed a micro-batch with the given ID.
- **Change protocol** - enables new features by switching the Delta Lake transaction log to the newest software protocol.
- **Commit info** - Contains information around the commit, which operation was made, from where and at what time.

Those actions are then recorded in the transaction log as ordered, atomic units known as **commits.**

### The Delta Lake Transaction Log at the File Level

**When a user creates a Delta Lake table, that table’s transaction log is automatically created in the** `_delta_log` **subdirectory. As he or she makes changes to that table, those changes are recorded as ordered, atomic commits in the transaction log.** 

Each commit is written out as a JSON file, starting with `000000.json`. Additional changes to the table generate subsequent JSON files in ascending numerical order so that the next commit is written out as `000001.json`, the following as `000002.json`, and so on.

![Pasted image 20240304112133.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240304112133.png)

##### Simple Reads and Writes

![Pasted image 20240304112211.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240304112211.png)

##### Updates

![Pasted image 20240304112238.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240304112238.png)

##### Simultaneous Writes/Reads

![Pasted image 20240304112311.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240304112311.png)

##### Failed Writes

![Pasted image 20240304112354.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240304112354.png)

This is an amazing blog to deep-dive into this topic - [https://www.databricks.com/blog/2019/08/21/diving-into-delta-lake-unpacking-the-transaction-log.html](https://www.databricks.com/blog/2019/08/21/diving-into-delta-lake-unpacking-the-transaction-log.html)

## Understanding Delta Tables

```sql
-- create table
CREATE TABLE employees
(id INT, name STRING, salary DOUBLE);

-- insert data
INSERT INTO employees
VALUES 
  (1, "Adam", 3500.0),
  (2, "Sarah", 4020.5);

INSERT INTO employees
VALUES
  (3, "John", 2999.3),
  (4, "Thomas", 4000.3);

INSERT INTO employees
VALUES
  (5, "Anna", 2500.0);

INSERT INTO employees
VALUES
  (6, "Kim", 6200.3)

-- select data
SELECT * FROM employees;

-- describe table
DESCRIBE DETAIL employees

-- check folder
%fs ls 'dbfs:/user/hive/warehouse/employees'

-- update data
UPDATE employees 
SET salary = salary + 100
WHERE name LIKE "A%"

-- select data
SELECT * FROM employees;

-- check folder
%fs ls 'dbfs:/user/hive/warehouse/employees'

-- describe table
DESCRIBE DETAIL employees

-- check history
DESCRIBE HISTORY employees

-- check delta log
 %fs ls 'dbfs:/user/hive/warehouse/employees/_delta_log'

-- check file
%fs head 'dbfs:/user/hive/warehouse/employees/_delta_log/00000000000000000003.json'
```

### Time Travel

Having worked with databases and tables before, odds are you have had that imme‐ diate sense of panic when you forgot a WHERE clause and accidentally ran a DELETE or UPDATE statement against an entire table.

We have all been there. Or you may have wondered what your data or schema looked like at a specific point in time for auditing, tracking, or analysis purposes

The ability to easily traverse through different versions of data at specific points in time is a key feature in Delta Lake called Delta Lake time travel.

You learned that the transaction log automatically versions data in a Delta table, and this versioning helps you access any historical version of that data.

Delta Lake time travel allows you to access and revert to previous versions of data stored in Delta Lake, easily providing a powerful mechanism for version control, auditing, and data management. You can then track changes over time and roll back to previous versions if needed.

### SYNTAX

##### Using a timestamp

```sql
SELECT * FROM my_table TIMESTAMP AS OF "2019-01-01"
```

##### Using a version number

```sql
SELECT * FROM my_table VERSION AS OF 36
SELECT * FROM my_table@v36
```

Restore Table

```sql
RESTORE TABLE my_table TO TIMESTAMP AS OF '2019-01-01'

RESTORE TABLE my_table TO VERSION AS OF 36
```

Continue with our last example

```python
DESCRIBE HISTORY employees
```

We can select specific version

```sql
SELECT * FROM employees VERSION AS OF 1

--or

SELECT * FROM employees@v1

-- let's delete our table
DELETE FROM employees

-- try selecting
SELECT * FROM employees

-- error? we can restore our deleted table by version
RESTORE TABLE employees TO VERSION AS OF 5 -- check history to find best version

-- select again
SELECT * FROM employees

-- check history
DESCRIBE HISTORY employees

-- check table details
DESCRIBE DETAIL employees
```

### Compacting Small Files

In Delta Lake, sometimes you end up with many small files, which can slow down your data queries. Compacting these files means combining them into larger ones for faster performance.

#### Z-Ordering

Z-Ordering is a technique to organize data files based on the values in one or more columns. This can help speed up queries that filter on those columns.

```sql
OPTIMIZE employees
ZORDER BY id
```

```sql
-- check details
DESCRIBE DETAIL employees

-- check history
DESCRIBE HISTORY employees

-- check folder
%fs ls 'dbfs:/user/hive/warehouse/employees'
```

### The `VACUUM` Command

The `VACUUM` command cleans up old data files that are no longer needed. This helps to save storage space and maintain a tidy data environment.

```sql
VACUUM my_table;
```

Remember to set a safe retention period when using `VACUUM` to avoid deleting files you might need for Time Travel. The default retention period is usually 7 days.

When you use VACUUM then you can't time travel

Let's try this

```sql
VACUUM employees
```

check file system

```shell
 %fs ls 'dbfs:/user/hive/warehouse/employees'
```

nothing changed?

Let's try setting retention 0

```sql
VACUUM employees RETAIN 0 HOURS
```

error? we need to disable retention

```shell
SET spark.databricks.delta.retentionDurationCheck.enabled = false;
```

try now!

```sql
VACUUM employees RETAIN 0 HOURS
```

try selecting version 1 of table

```
SELECT * FROM employees@v1
```

error? well it got removed as we don't need it

### Creating your first Delta table

Let’s create our first Delta table! Like databases, to create our Delta table we can first create a table definition and define the schema or, like data lakes simply write a Spark DataFrame to storage in the Delta form

When creating a Delta table, you are writing files to some storage (e.g. file system, cloud object stores). All of the files together stored in a directory of a particular structure make up your table. Therefore, when we create a Delta table, we are in fact writing files to some storage location

```python
dataframe.write.format("parquet").save("/data")
```

when we write this we store `parquet` data to `data` folder

![Pasted image 20240305111825.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240305111825.png)  
With one simple modification of the preceding code snippet, you can now create a Delta table.

#### Writing Delta Tables

```python
# Create data DataFrame
data = spark.range(0, 5)
# Write the data DataFrame to /delta location
data.write.format("delta").save("/delta")
```

It is important to note that in most production environments when you are working with large amounts of data, it is important to partition your data.

```python
# Write the Spark DataFrame to Delta table partitioned by date
data.write.partitionBy("date").format("delta").save("/delta")

# Append new data to your Delta table
data.write.format("delta").mode("append").save("/delta")

# Overwrite your Delta table
data.write.format("delta").mode("overwrite").save("/delta")
```

#### Reading Delta Tables

Similar to writing your Delta table, you can use the DataFrame API to read the same files from your Delta table

```python
# Read the data DataFrame from the /delta location
spark.read.format("delta").load("/delta").show()
```

same thing can also be done using SQL

```sql
SELECT * FROM delta.`/delta`
```

Let's use existing datasets to create delta tables

```python
display(dbutils.fs.ls('/databricks-datasets'))

#or
display(dbutils.fs.ls('/databricks-datasets/credit-card-fraud/data'))
```

create view

```sql
-- Assuming Spark SQL context is used for initial exploration
CREATE DATABASE credit_card;
USE credit_card;

CREATE OR REPLACE TEMP VIEW credit_card.temp_crdit_card AS
SELECT *
FROM parquet.`dbfs:/databricks-datasets/credit-card-fraud/data/part-00000-tid-898991165078798880-9c1caa7b-283d-47c4-9be1-aa61587b3675-0-c000.snappy.parquet`;
```

create delta table using view

```sql
-- Create a managed Delta table from the temporary view
CREATE TABLE credit_card_managed
USING DELTA
AS SELECT * FROM temp_crdit_card;
```

##### Let's do it with Flight Data using SQL and Spark

```sql
CREATE DATABASE flight;
USE flight;

CREATE OR REPLACE TEMP VIEW temp_flights_view AS
SELECT *
FROM csv.`dbfs:/databricks-datasets/flights/departuredelays.csv`;

-- problem??
```

```sql
CREATE TABLE flight_data
  (date INT, delay INT, distance STRING, origin STRING, destination INT)
USING CSV
OPTIONS (
  header = "true",
  delimiter = ","
)
LOCATION "/databricks-datasets/flights/departuredelays.csv"
```

```sql
SELECT * FROM flight_data LIMIT 10;
```

Spark

```python
from pyspark.sql import SparkSession

# Start Spark session
spark = SparkSession.builder.appName("FlightDataDeltaLake").getOrCreate()

# Load the CSV file into a DataFrame, specifying that the first row contains headers
df = spark.read.format("csv").option("header", "true").load("dbfs:/databricks-datasets/flights/departuredelays.csv")

# Show the DataFrame schema to verify that the headers are correctly used as column names
df.printSchema()
```

```python
# Define the path for the Delta table
deltaTablePathManaged = "/delta/flights_delay_managed"

# Write the DataFrame to a Delta table (managed)
df.write.format("delta").mode("overwrite").save(deltaTablePathManaged)
```

##### Read from Delta Table

```python

# Load the data from the Delta table
deltaTablePath = "/delta/flights_delay_managed"
flightDataDF = spark.read.format("delta").load(deltaTablePath)

# Display the schema to verify the data
flightDataDF.printSchema()
```

```python
# Filter Flights Delayed by More than 60 Minutes
delayedFlightsDF = flightDataDF.filter("delay > 60")

# Add a New Column for Significant Delays
enhancedFlightsDF = delayedFlightsDF.withColumn("significant_delay", when(col("delay") > 120, "Yes").otherwise("No"))

# Aggregate: Average Delay by Origin Airport
avgDelayByOriginDF = enhancedFlightsDF.groupBy("origin").avg("delay").withColumnRenamed("avg(delay)", "average_delay")

# Show the result of the transformations
avgDelayByOriginDF.show()

# Save the Transformed Data
transformedDeltaTablePath = "/delta/transformed_flights_delay"

avgDelayByOriginDF.write.format("delta").mode("overwrite").save(transformedDeltaTablePath)

```

