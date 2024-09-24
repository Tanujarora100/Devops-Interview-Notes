### STATIC MEMORY MANAGEMENT VS DYNAMIC MEMORY MANAGEMENT
**Static Memory Management (Deprecated):**
- **Concept:** In static memory management, ==a fixed amount of memory is pre-allocated to each executor at the start of the Spark application.== This memory remains constant throughout the application's execution.
- **Configuration:** You specify the amount of memory for each executor using a configuration parameter like `spark.executor.memory`.
- **Benefits:**
    - Simpler to reason about memory usage.
- **Drawbacks:**
    - **Inefficient resource utilization:**
        - If the application requires varying memory usage across tasks, static allocation can lead to wasted memory for some executors.
    - **Lack of flexibility:** 
    - ==**Deprecated:** since Spark 1.6.0 due to its limitations.==

**Dynamic Memory Allocation (Recommended):**
- **Concept:** In dynamic memory allocation, memory is allocated to executors on-demand as needed during application execution. 
	- This allows for more efficient resource utilisation.
- **Mechanism:** **Spark's [Unified Memory Manager] (introduced in Spark 1.6.0) is responsible for dynamically allocating memory to executors. **
	- It tracks memory usage and adjusts allocations based on the application's requirements.
	- It resides ==within the Spark driver program== but operates independently to manage memory across all executors.
	- To disable it
		- `spark.memory.useStaticMemoryManager`
		- Setting this property to `true` disables the UMM and forces Spark to use the older static memory management approach.
---

### Common Causes of OOM Errors in Spark
![[Pasted image 20240614021257.png]]
1. **Insufficient Memory Allocation**:
    - **Driver Memory**: The driver may run out of memory if it collects too much data locally, such as when ==using actions like `collect()`, `count()`, or `take()` on large datasets.==
    - **Executor Memory**: Executors can run out of memory during tasks that require significant memory, such as ==aggregations, joins, or caching large datasets==
    - **Inefficient Brodcast Joins**
	    - When we try to union alot of dataframes together and then broadcast them together.
	    - This Dataframe will be sent to Driver and then if the driver does not have enough memory then it will fail.
	    - ![[Pasted image 20240614023308.png]]
1. **Large Shuffles**:
    - Shuffling data between executors can consume significant memory. 
    - Large shuffles occur during operations like `groupBy`, `join`, or `repartition`.
2. **Caching/Persistence**:
    - Caching or persisting large datasets in memory can lead to OOM errors if there is not enough memory available to store the datasets.
3. **Skewed Data**:
    - Data skew, where some partitions hold much more data than others, ==can cause certain executors to run out of memory while processing those heavy partitions.==
4. **Improper Serialisation**:
    - Inefficient serialisation formats or improper usage of serialisation libraries can lead to increased memory usage.
#### Why Show command does not show OOM
**Optimized Execution**:
- Spark's Catalyst optimiser ensures that the `show()` action is executed efficiently. It performs only the necessary computations to retrieve the specified number of rows, minimising the overall resource usage.
- - Unlike `collect()`, which retrieves the entire DataFrame or RDD to the driver, `show()` retrieves only one partition and sends it to the driver not all partitions.. This partial collection mechanism is much more memory-efficient.
### How to Handle OOM Error
**Properly Using `collect()` and Similar Actions**:
- Avoid using actions that collect large amounts of data to the driver. 
- Use actions like `take(n)` to limit the amount of data collected.
#### Efficient Shuffling
```python
spark.conf.set("spark.sql.shuffle.partitions", "200")
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "10485760") 

```

---

### Difference In Spark Memory and Spark MemoryOverhead

- **spark.storage.memoryFraction**:
    - `spark.storage.memoryFraction`: Fraction of Java heap to use for Spark's memory cache. This should not be larger than the "old" generation of objects in the JVM, which by default is given 0.6 of the heap
    - The default value is `0.6`, meaning 60% of the executor's heap memory is used for the unified memory region.
- **spark.memory.storageFraction**:
    - This setting determines the fraction of `spark.memory.fraction` that is allocated to ==storage for caching and persisting RDDs in the heap, this region is not used for computation.==
    - The default value is `0.5`, meaning 50% of the unified memory region is reserved for storage.
    - Means this is the division of 60% of fraction space in which 50% will be used for computation and 50% for Storage.
    - Spark uses a unified memory management model where both execution and storage share the region defined by 'spark.memory.fraction'. 'spark.memory.storageFraction' sets the amount of storage memory immune to eviction, expressed as a fraction of the size of the region set by 'spark.memory.fraction'.
![[Pasted image 20240619144849.png]]
### `spark.memoryOverhead`
- **spark.executor.memoryOverhead**:
	**Memory overhead** refers to the ==additional memory allocated per executor to handle tasks that go beyond the typical JVM heap memory. ==This additional memory is used for:
	1. **JVM Overheads**: This includes the memory required for the Java Virtual Machine’s own operations such as thread stacks, garbage collection structures, and other JVM internals.
	2. ==**Off-Heap Storage**: Spark can use off-heap memory for certain operations, such as when using the `Tungsten` execution engine for improved performance.==
	3. **Serialized Data**: Data that needs to be transferred across the network or cached in serialised form.
	
	####  Why is Memory Overhead Important?
	Without adequate memory overhead, the executor may run out of memory, leading to `OutOfMemoryError` exceptions, even if the heap memory appears to be sufficient. 
		==This is because certain operations or Spark’s internal bookkeeping require memory outside of the heap.==
	    - The default value is either `384MB` or `10%` of the executor memory, whichever is greater.
	    - Objects stored are here
- **`spark.memory.fraction`:** This configuration defines the portion of the executor's Java Heap memory dedicated to Spark's internal memory management. 
	- ==By default, it's set to 0.6 (60%), leaving the remaining 40% for internal JVM usage and safety margins.==
- **`spark.memory.overhead`:** This configuration specifies the additional memory overhead required by the executor for various purposes like off-heap memory allocation, 
	- Network I/O buffers, and internal threads. It's typically set as a percentage of the total executor memory (`spark.executor.memory`) with a minimum default value (often 384MB).

**In essence:**
1. Spark allocates memory for the executor based on `spark.executor.memory`.
	1. - Spark uses off-heap memory (`spark.memory.offHeap.size`) **separately** from the unified memory pool.==It's not automatically carved out of the remaining memory after unified memory allocation.==
	- You need to explicitly configure `spark.memory.offHeap.size` to enable and define the size of the off-heap memory region. This memory resides outside the Java Heap and can potentially offer better performance for certain operations.
1. `spark.memory.fraction` determines the portion of this memory used for Spark's internal memory pool.
2. `spark.memory.overhead` adds extra memory on top of the memory pool defined by `spark.memory.fraction` to cover executor overheads.

**Therefore, the total memory used by an executor is calculated as:**

```
Total Executor Memory = spark.executor.memory + spark.memory.overhead
```

**Important points to remember:**

- While `spark.memory.fraction` defines the internal pool size, it doesn't directly translate to usable memory for your application.
- ==`spark.memory.overhead` accounts for memory used by Spark itself, not for your application data.==
### Executor Memory Breakdown

To understand how these configurations work together, consider an executor with `8GB` of allocated memory (`spark.executor.memory`):
1. **Total Memory**:
    - `spark.executor.memory = 8GB`
    - `spark.executor.memoryOverhead = max(384MB, 10% of 8GB) = 800MB`
    - **Total executor memory** = `8GB + 800MB = 8.8GB`
2. **Unified Memory**:
    - `spark.memory.fraction = 0.6` (60% of `8GB`)
    - Unified memory = `8GB * 0.6 = 4.8GB`
3. **Execution and Storage Memory**:
    - `spark.memory.storageFraction = 0.5` (50% of the unified memory)
    - Storage memory = `4.8GB * 0.5 = 2.4GB`
    - Execution memory = `4.8GB - 2.4GB = 2.4GB`

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("MemoryTuningExample") \
    .config("spark.executor.memory", "8g") \
    .config("spark.executor.memoryOverhead", "1g") \
    .config("spark.memory.fraction", "0.7") \
    .config("spark.memory.storageFraction", "0.6") \
    .getOrCreate()

```

---

### Why do we get OOM when data can be spilled to the Disk?

1. **Insufficient Memory for Critical Operations**:    
    - **Shuffle Operations**: During shuffle operations, intermediate data is stored in memory before being spilled to disk. If the amount of intermediate data generated by operations like ==joins, aggregations, or groupBy exceeds the available memory before spilling can occur, an OOM error may result.==
    - **Large Broadcast Variables**: Broadcast variables that are too large to fit into memory can cause OOM errors. Although broadcast data is intended to fit into memory, when it's too large, it can't be efficiently handled by the executors.
2. **JVM Overheads**:
    - **Garbage Collection**: ==Excessive memory usage can lead to frequent and long garbage collection (GC) pauses.== If the JVM spends too much time in GC, it may fail to reclaim enough memory, resulting in OOM errors.
    - **Driver Memory**: Operations like `collect()`, which gather data to the driver, can easily overwhelm the driver's memory if the dataset is large.
3. **Memory Leaks**:
    - Memory leaks in Spark applications, often caused ==by bugs in user-defined functions or libraries==, can gradually consume all available memory, leading to OOM errors.
4. **Inefficient Memory Management**:
    - **Improper Caching**: ==Caching large datasets without sufficient memory can lead to OOM errors.== Even though Spark spills cached data to disk, the initial memory allocation can cause memory pressure.
    - **Suboptimal Configuration**: Misconfigurations such as setting `spark.executor.memory` or `spark.memoryOverhead` too low can result in insufficient memory for operations.
5. **Data Skew**:
    - When data is unevenly distributed across partitions (data skew), some executors may handle significantly larger partitions than others, causing them to run out of memory.
#### Solutions
**Increase Memory Allocation**:
- Allocate more memory to executors and increase `spark.executor.memoryOverhead` to handle additional memory requirements.
	
```python
--executor-memory 8g
--executor-cores 4
--executor-memoryOverhead 2g

```
**Efficient Caching**:
- Cache only necessary datasets and use appropriate storage levels (e.g., `MEMORY_AND_DISK`).
Avoid using `collect()` or other actions that gather large amounts of data to the driver.
Adjust Spark's memory management configurations to better handle the workload.
```python
spark.conf.set("spark.sql.shuffle.partitions", "400")
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "-1")


```

---

### Spark Memory Managers

Apache Spark has two main types of memory management systems: **Static Memory Management** and **Unified Memory Management**. Each system governs how Spark allocates and manages memory resources for tasks such as caching, execution, and shuffling.
### 1. Static Memory Management
This was the default memory management model in ==Spark versions prior to 1.6. In this model, memory is statically divided into two regions: storage memory and execution memory.==

- **Storage Memory**:
    - Used for caching data and storing shuffle data.
    - Configured using `spark.storage.memoryFraction`, which defaults to 0.6, meaning 60% of the allocated memory is used for storage.
- **Execution Memory**:
    - Used for executing tasks, such as sorting, shuffling, and aggregations.
    - The remaining 40% of the allocated memory is used for execution.

### 2. Unified Memory Management

Introduced in ==Spark 1.6, Unified Memory Management (UMM) is the default memory management system from Spark 1.6 onward.== It combines storage and execution memory into a single unified region, making memory management more flexible and efficient.

#### Key Features of Unified Memory Management:

- **Unified Memory Region**:
    - Instead of static partitions, UMM dynamically allocates memory between storage and execution based on current needs.
- **Memory Fraction Configurations**:
    - `spark.memory.fraction`:
        - The fraction of the total heap memory that is used for execution and storage.
        - Default value is 0.6, meaning 60% of the heap memory is used for execution and storage.
    - `spark.memory.storageFraction`:
        - The fraction of `spark.memory.fraction` dedicated to storage.
        - Default value is 0.5, meaning 50% of the unified memory is used for storage, and the rest is used for execution.
        - Amount of storage memory immune to eviction, expressed as a fraction of the size of the region set aside by `spark.memory.fraction`. The higher this is, the less working memory may be available to execution and tasks may spill to disk more often
![[Pasted image 20240619144849.png]]
#### How Unified Memory Management Works:
- **Dynamic Allocation**:
    - The unified memory pool allows memory to be dynamically allocated between storage and execution based on current needs. If execution memory is not fully utilized, storage can use more memory and vice versa.
- **Spill to Disk**:
    - When memory usage exceeds the available memory, Spark spills data to disk to free up space. This helps prevent out-of-memory errors.
---
### How to Handle Memory Intensive Tasks
- Number of Core and executor good balance
- repartition to avoid data skew
- Optimising Transformations
- Caching and using off-heap memory.

### What is `spark.executor.cores`
Each task will have one core to itself so if we increase the number of cores more tasks can work parallel 
But without increasing memory if we do it then it can lead to OOM errors.
![[Pasted image 20240619153658.png]]