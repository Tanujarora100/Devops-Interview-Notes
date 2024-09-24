Spark applications are going to bring together a large number of different datasets. For this reason, joins are an essential part of nearly all Spark workloads. Spark’s ability to talk to different data means that you gain the ability to tap into a variety of data sources across your company.

### Join Expressions

A join brings together two sets of data, the left and the right, by comparing the value of one or more keys of the left and right and evaluating the result of a join expression that determines whether Spark should bring together the left set of data with the right set of data.

### Join Types

- Inner joins: Keeps rows with keys that exist in both the left and right datasets.
- Outer joins: Keeps rows with keys in either the left or right datasets.
- Left outer joins: Keeps rows with keys in the left dataset.
- Right outer joins: Keeps rows with keys in the right dataset.
- Left semi joins: Keeps rows in the left dataset where the key appears in the right dataset.
- Left anti joins: Keeps rows in the left dataset where they do not appear in the right dataset.
- Natural joins: Performs a join by implicitly matching columns with the same names.
- Cross (or Cartesian) joins: Matches every row in the left dataset with every row in the right dataset.

If you have ever interacted with a relational database system, or even an Excel spreadsheet, the concept of joining different datasets together should not be too abstract. Let’s move on to showing examples of each join type.

```python
person = spark.createDataFrame([
  (0, "Bill Chambers", 0, [100]),
  (1, "Matei Zaharia", 1, [500, 250, 100]),
  (2, "Michael Armbrust", 1, [250, 100])])\

.toDF("id", "name", "graduate_program", "spark_status")
graduateProgram = spark.createDataFrame([

  (0, "Masters", "School of Information", "UC Berkeley"),
  (2, "Masters", "EECS", "UC Berkeley"),
  (1, "Ph.D.", "EECS", "UC Berkeley")])\

.toDF("id", "degree", "department", "school")
sparkStatus = spark.createDataFrame([

  (500, "Vice President"),
  (250, "PMC Member"),
  (100, "Contributor")])\

.toDF("id", "status")
```

#### Inner Joins

Inner joins evaluate the keys in both of the DataFrames or tables and include (and join together) only the rows that evaluate to true.

```python
joinExpression = person["graduate_program"] == graduateProgram['id']
```

Inner joins are the default join, so we just need to specify our left DataFrame and join the right in the JOIN expression:

```python
person.join(graduateProgram, joinExpression).show()
```

#### Outer Joins

Outer joins evaluate the keys in both of the DataFrames or tables and includes (and joins together) the rows that evaluate to true or false. If there is no equivalent row in either the left or right DataFrame, Spark will insert null

```python
joinType = "outer"
person.join(graduateProgram, joinExpression, joinType).show()
```

#### Left Outer Joins

Left outer joins evaluate the keys in both of the DataFrames or tables and includes all rows from the left DataFrame as well as any rows in the right DataFrame that have a match in the left DataFrame. If there is no equivalent row in the right DataFrame, Spark will insert null:

```python
joinType = "left_outer"
graduateProgram.join(person, joinExpression, joinType).show()
```

#### Right Outer Joins

Right outer joins evaluate the keys in both of the DataFrames or tables and includes all rows from the right DataFrame as well as any rows in the left DataFrame that have a match in the right DataFrame. If there is no equivalent row in the left DataFrame, Spark will insert null:

```python
joinType = "right_outer"
person.join(graduateProgram, joinExpression, joinType).show()
```

#### Left Semi Joins

Semi joins are a bit of a departure from the other joins. They do not actually include any values from the right DataFrame. They only compare values to see if the value exists in the second DataFrame. If the value does exist, those rows will be kept in the result, even if there are duplicate keys in the left DataFrame. Think of left semi joins as filters on a DataFrame, as opposed to the function of a conventional join:

```python
joinType = "left_semi"
graduateProgram.join(person, joinExpression, joinType).show()
```

#### left Anti Joins

Left anti joins are the opposite of left semi joins. Like left semi joins, they do not actually include any values from the right DataFrame. They only compare values to see if the value exists in the second DataFrame. However, rather than keeping the values that exist in the second DataFrame, they keep only the values that do not have a corresponding key in the second DataFrame. Think of anti joins as a NOT IN SQL-style filter:

```python
joinType = "left_anti"
graduateProgram.join(person, joinExpression, joinType).show()
```

#### Cross (Cartesian) Joins

The last of our joins are cross-joins or cartesian products. Cross-joins in simplest terms are inner joins that do not specify a predicate. Cross joins will join every single row in the left DataFrame to ever single row in the right DataFrame. This will cause an absolute explosion in the number of rows contained in the resulting DataFrame. If you have 1,000 rows in each DataFrame, the cross- join of these will result in 1,000,000 (1,000 x 1,000) rows. For this reason, you must very explicitly state that you want a cross-join by using the cross join keyword

```python
joinType = "cross"
graduateProgram.join(person, joinExpression, joinType).show()
```

`You should use cross-joins only if you are absolutely, 100 percent sure that this is the join you need. There is a reason why you need to be explicit when defining a cross-join in Spark. They’re dangerous!

### How Spark Performs Joins

To understand how Spark performs joins, you need to understand the two core resources at play: the node-to-node communication strategy and per node computation strategy. These internals are likely irrelevant to your business problem. However, comprehending how Spark performs joins can mean the difference between a job that completes quickly and one that never completes at all.

##### Communication Strategies

Spark approaches cluster communication in two different ways during joins.

- Shuffle join, which results in an all-to-all communication
- Broadcast join.

Some of these internal optimizations are likely to change over time with new improvements to the cost-based optimizer and improved communication strategies.

For this reason, we’re going to focus on the high-level examples to help you understand exactly what’s going on in some of the more common scenarios

**The core foundation of our simplified view of joins is that in Spark you will have either a big table or a small table.**

##### Big table–to–big table

When you join a big table to another big table, you end up with a shuffle join,

![Pasted image 20231219213008.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231219213008.png)  
In a shuffle join, every node talks to every other node and they share data according to which node has a certain key or set of keys (on which you are joining). These joins are expensive because the network can become congested with traffic, especially if your data is not partitioned well.

##### Big table–to–small table

When the table is small enough to fit into the memory of a single worker node, with some breathing room of course, we can optimize our join

Although we can use a big table–to–big table communication strategy, **it can often be more efficient to use a broadcast join.**

What this means is that we will replicate our small DataFrame onto every worker node in the cluster (be it located on one machine or many). Now this sounds expensive. However, what this does is prevent us from performing the all-to-all communication during the entire join process. Instead, we perform it only once at the beginning and then let each individual worker node perform the work without having to wait or communicate with any other worker node, as is depicted in

![Pasted image 20231219213140.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231219213140.png)

At the beginning of this join will be a large communication, just like in the previous type of join. However, immediately after that first, there will be no further communication between nodes.

```python
val joinExpr = person.col("graduate_program") === graduateProgram.col("id")
person.join(graduateProgram, joinExpr).explain()
```

With the DataFrame API, we can also explicitly give the optimizer a hint that we would like to use a broadcast join by using the correct function around the small DataFrame in question.

```python
import org.apache.spark.sql.functions.broadcast
val joinExpr = person.col("graduate_program") === graduateProgram.col("id")
person.join(broadcast(graduateProgram), joinExpr).explain()
```

##### Little table–to–little table

When performing joins with small tables, it’s usually best to let Spark decide how to join them. You can always force a broadcast join if you’re noticing strange behavior.


In Apache Spark, joining datasets is a common operation in data processing, and choosing the right join strategy is crucial for performance optimisation. Spark provides several join strategies, each suited for different scenarios based on the size of the datasets and the available resources. Here’s an overview of the main join strategies in Spark:
![[Pasted image 20240613214752.png]]
### 1. Shuffle Hash Join
#### Description:
- Default join strategy when neither dataset is ==small enough to fit in memory.==
- Involves shuffling data across the cluster to ensure that rows with matching keys end up on the same partition.
- **Memory Usage**: The Shuffle Hash Join is efficient if the hash table for the smaller dataset fits into memory. If the smaller dataset is too large to fit into memory, the algorithm may fall back to a more memory-efficient join method, such as Sort-Merge Join.
- Smaller table hash table is generated and this hash table is in memory of the executor, so more number of unique keys means more memory.
- Time Complexity-O(1) but Memory Utilisation is more than Shuffle Sort Join.
- Out of Memory Error aa skta h isliye.
#### How it works:
- Data Partitioning:
	- Both input datasets (let's call them left and right) are partitioned based on the join keys. This partitioning ensures that rows with the same join key end up in the same partition.
- Shuffling:
	- The data is shuffled across the network to ensure that all rows with the same join key from both datasets are sent to the same executor (worker node). 
	- This involves a network transfer, where rows are grouped by join keys.
- Building Hash Tables:
	- Once the data is partitioned and shuffled ,==a hash table is built for the smaller of the two datasets in each partition.==
	- Each partition of the smaller dataset is loaded into memory, and a hash table is constructed using the join keys.
#### Pros:
- Can handle large datasets.
- Distributed across the cluster.
#### Cons:
- High network and disk I/O due to shuffling.
- Performance can degrade with very large datasets.
#### Use Case:
- Large datasets where neither fits in memory.
- Distributed joins with substantial data reshuffling.

### 2. Broadcast Hash Join

#### Description:
- Used when one of the datasets is small enough to fit into the memory of each executor.
- ==The smaller dataset is broadcasted to all nodes.==
- Small Tables less than 10MB can be broadcasted, this we can change also but this is the default value.
- Driver sends the file to all the worker nodes
- Why it is better than shuffle hash join=> No Shuffling required.
- This strategy makes each worker self dependent of each other.
![[Pasted image 20240614014048.png]]
##### Potential Issues
	- Driver memory should be there and can be out of memory error
	- broadcast file size should be decided as per the cluster size.
	- This strategy fails when there is two large tables are joined as if we broadcast such a huge table then it can choke the network.
#### How it works:
1. **Broadcasting the Smaller Dataset**:
    - Spark identifies the ==smaller dataset and broadcasts it to all worker nodes in the cluster. ==
    - Broadcasting involves sending the entire dataset to each worker node, making it available in memory for the join operation.
1. **Building Hash Tables**:
    - On each worker node, a hash table is built from the broadcasted dataset using the join keys. This hash table is kept in memory.
2. **Probing**:
    - The larger dataset is then processed on each worker node. For each row in the larger dataset, the join key is used to probe (look up) the hash table. If a match is found, the corresponding rows from both datasets are joined together.
### Configuration:

- **Auto Broadcast**:
    - By default, Spark will automatically decide to broadcast a dataset if its size is below a certain threshold, controlled by the==`spark.sql.autoBroadcastJoinThreshold`== parameter (default is 10MB).
- **Manual Broadcast**:
    - Users can also explicitly hint Spark to broadcast a dataset using the `broadcast` function.
```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import broadcast
spark = SparkSession.builder.appName("BroadcastHashJoinExample").getOrCreate()

data1 = [(i, 'A' + str(i)) for i in range(100000)]
data2 = [(i, 'B' + str(i)) for i in range(100)]

# Create DataFrames
df1 = spark.createDataFrame(data1, ['id', 'value1'])
df2 = spark.createDataFrame(data2, ['id', 'value2'])

# Perform Broadcast Hash Join using a broadcast hint
joined_df = df1.join(broadcast(df2), df1.id == df2.id, 'inner')

# Show the result
joined_df.show()

# Show the query plan to confirm Broadcast Hash Join
joined_df.explain()


```
	
#### Pros:
- No shuffling required.
- Very efficient for small datasets joined with large datasets.
#### Cons:
- The small dataset must fit in memory.
- Inefficient if the small dataset is larger than available memory.
#### Use Case:
- Small dataset joined with a large dataset.
- When the size of the small dataset is known and manageable.

### 3. Shuffle Sort Merge Join

#### Description:
- **Default join strategy for structured data (e.g., DataFrames, Datasets) when both datasets are sorted on the join key.**
- Requires both datasets to be sorted by the join key.
- Reason for sorting is to decrease the time complexity because then it will be O(N2)
- Sorting Time complexity is O-NLOGN
- `spark.sql.join.preferSortMergeJoin`: This configuration parameter can be set to `true` to prefer Sort-Merge Join over other join strategies. When set to `false`, Spark may prefer other join types like Shuffle Hash Join when appropriate.
![[Pasted image 20240613215140.png]]
#### How it works:
- Both datasets are sorted by the join key if not already sorted.
- The sorted datasets are merged and joined.
#### Pros:
- Efficient for large datasets that are already sorted.
- Can be more efficient than shuffle hash join for large datasets with sorted keys.
#### Cons:
- Sorting can be expensive if the datasets are not already sorted.
- Requires significant memory for sorting large datasets.
- Internally Sorting takes O(NLOGN)
#### Use Case:
- Large, structured datasets that are either sorted or can be efficiently sorted.
- Join operations in ETL pipelines where data can be pre-sorted.

### Details of the Sorting Process:

1. **External Sort**: When the datasets are too large to fit into memory, an external sort is used. 
	1. This process involves dividing the data into manageable chunks, sorting each chunk in memory, and then merging these sorted chunks. 
	2. This technique ensures that even very large datasets can be efficiently sorted without running out of memory.
    
2. **Distributed Sorting**: In a distributed computing environment like PySpark, sorting is also distributed across multiple nodes. Each node sorts its partition of the data, and these sorted partitions are then merged across the cluster.

### Execution in PySpark:

When a Sort-Merge Join is performed in PySpark, the following steps occur:

1. **Shuffle Phase**: The data from both tables is shuffled based on the join keys. This ensures that rows with the same key end up on the same partition.
2. **Sort Phase**: Each partition of the data is sorted by the join key. This is where the external sort comes into play if the partition size exceeds memory limits.
3. **Merge Phase**: The sorted partitions are then merged. Since each partition is sorted, the merge process is efficient, involving a sequential scan of the partitions.

### 4. Broadcast Nested Loop Join

#### Description:
- Fallback join strategy when no join keys are available or suitable.
- Broadcasts one dataset to all nodes and performs a nested loop join.

#### How it works:
- The smaller dataset is broadcasted to all nodes.
- Each row in the larger dataset is compared with each row in the smaller dataset.
- - **Broadcasting the Smaller Dataset**:
    - Similar to the Broadcast Hash Join, Spark broadcasts the smaller dataset to all worker nodes. This dataset is fully replicated across all nodes.
- **Nested Loop Join**:
    - Each node iterates through the larger dataset and, for each row, iterates through the broadcasted dataset to find matching rows based on the join condition.
    - This involves a double loop where for each row in the larger dataset, all rows in the broadcasted dataset are checked for a match.

#### Pros:
- Simple and works with any join condition.
- Can handle non-equi joins (e.g., joins with inequality conditions).

#### Cons:
- Very inefficient for large datasets as time complexity is O(N2)
- High memory and computational cost.

#### Use Case:

- Small datasets.
- Non-equi joins or complex join conditions.

### 5. Cartesian Join (Cross Join)

#### Description:
- Produces the Cartesian product of two datasets.
- Every row from one dataset is joined with every row from the other dataset.

#### How it works:
- All possible pairs of rows are created from the two datasets.

#### Pros:
- Works without join keys.
- ==Suitable for generating combinations.==

#### Cons:
- ==Extremely expensive for large datasets.==
- Exponential growth in the number of rows.

#### Use Case:
- Small datasets.
- Specific scenarios requiring Cartesian products.

### Summary and Recommendations

- **Shuffle Hash Join**: Use when both datasets are large and cannot fit in memory.
	- shuffle and divide then
- **Broadcast Hash Join**: Use when one dataset is small enough to fit in memory.
	- Broadcast chote vala
- **Sort Merge Join**: Use for large, structured datasets that are sorted or can be sorted efficiently.
	- shuffle and divide and then sort 
- **Broadcast Nested Loop Join**: Use for small datasets or non-equi join conditions.
- **Cartesian Join**: Use with caution, only for small datasets or specific use cases.