In Spark, **the core data structures are immutable,** meaning they cannot be changed after they’re created.
- To “change” a DataFrame, you need to instruct Spark how you would like to modify it to do what you want. These instructions are called **transformations**.

```python
divisBy2 = myRange.where("number % 2 = 0")
```

Transformations are the core of how you express your business logic using Spark.

There are two types of transformations:

- Narrow dependencies
- Wide dependencies.

![Pasted image 20231127202740.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231127202740.png)

Transformations consisting of narrow dependencies (we’ll call them narrow transformations) ==are those for which each input partition will contribute to only one output partition.== There is no data shuffling in this type of transformation.
Examples:
- Filter
- Where
- Map
- Flat Map

![Pasted image 20231127202808.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231127202808.png)

[Wide transformation]
Wide dependency (or wide transformation) style transformation will have input partitions contributing to many output partitions. 
	Spark will exchange partitions across the cluster. 
	- **Default Shuffle Partitions (200):** Spark is configured with a default of 200 shuffle partitions. This value might be suitable for some applications, but it's often not ideal.
	- - **`spark.sql.shuffle.partitions`:** This configuration parameter allows you to specify the desired number of shuffle partitions for your Spark application. Setting a value that aligns with your data size, executors, and operation type can optimize performance.
#### How Shuffling Happens in Wide Transformations
1. **Map Phase:** In this phase, Spark processes each partition of the input data on the executor where it resides. This processing might involve generating key-value pairs (e.g., customer ID as key, purchase amount or location as value).
2. **Shuffle Phase:** ==All key-value pairs with the same key are routed to the same partition,== even if they originated from different partitions of the original data.
3. **Reduce Phase:** Finally, Spark aggregates or combines the shuffled data on the target partitions.
Examples:
- GroupBy
- Join
- ReduceByKey

#### Hash Based Partitioning
In Apache Spark, hash-based partitioning is commonly used to distribute data across the cluster for parallel processing. This technique ensures that data with the same key is grouped together in the same partition, which is particularly useful for operations that require key-based aggregation or joins.
### How Hash-Based Partitioning Works in Spark

1. **Hash Function**: Spark uses a hash function to determine the partition for each record based on the key. 
	1. The hash function typically used is a variant of ==MurmurHash,== which is a fast, ==non-cryptographic hash function== suitable for general hash-based partitioning.
2. **Assign to Partition**: The hash value is used in conjunction with the number of partitions to determine which partition a record belongs to. This is done using modulo arithmetic: `partitionId = hash(key) % numPartitions`.
3. **Data Skew**: If the data has a highly uneven distribution of keys, some partitions may end up with significantly more data than others, leading to performance bottlenecks. 
	1. ==In such cases, custom partitioning strategies or additional techniques (like salting) may be necessary to balance the load.==
4. **Number of Partitions**: Choosing the right number of partitions is important for performance. 
	1. Too few partitions can lead to under-utilization of resources, while too many partitions can increase overhead due to excessive shuffling.
### Role of Driver and Executors in Transformations

1. **Driver**:
    
    - The driver is responsible for transforming the logical plan of operations into a physical plan that can be executed across the cluster.
    - When a transformation is called on an RDD or DataFrame, the driver does not immediately execute the transformation. Instead, it builds up a logical plan of transformations, which is a lineage graph representing the series of transformations.
    - When an action (like `count()`, `collect()`, or `saveAsTextFile()`) is called, the driver converts the logical plan into a physical execution plan. It breaks down the plan into stages of tasks that can be distributed to the executors.
2. **Executors**:
    
    - Executors are the worker nodes responsible for executing the tasks assigned by the driver.
    - When a transformation is applied, the actual computation is performed on the worker nodes (executors).
    - For narrow transformations, the data is processed within the same partition and often within the same executor.
    - For wide transformations, the driver orchestrates the shuffle process, where data is redistributed across different partitions and executors to satisfy the transformation requirements.