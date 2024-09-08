
## cache() Method: 
- The cache() method is a shorthand way to persist data with the default storage level, which is MEMORY_ONLY. 
- Spark’s cache is fault-tolerant – if any partition of an RDD is lost, it will automatically be recomputed using the transformations that originally created it.
- This means that the RDD or DataFrame will be stored as ==**deserialised Java objects in the JVM’s memory**==. 
- If the data does not fit in memory, Spark will recompute the missing partitions when needed which can again take some time.
- It does not guarantee that whole partitions will be cached in the memory.
```python
rdd.cache()
dataframe.cache()
```
- Default Storage Level: MEMORY_ONLY
- Use Case: Use cache() when you are sure that the data fits into the memory of the cluster and when you are fine with recomputing the data if it doesn’t fit in memory.
![[Pasted image 20240618020500.png]]
## persist() Method
Using `persist()` method, PySpark provides an optimization mechanism to store the intermediate computation of a PySpark DataFrame so they can be reused in subsequent actions.

When you persist a dataset, each node stores its partitioned data in memory and reuses them in other actions on that dataset.
- The persist() method allows you to specify the storage level explicitly. This means you can control how and where the data is stored (in memory, on disk, or both), ==and whether it is stored in serialised or deserialised format.==
- The persist() method provides more flexibility compared to cache().
- ==Default Storage Level: Not applicable (you need to specify it explicitly)==
- Use Case: Use persist() when you need more control over the storage level, such as when dealing with large datasets that don’t fit in memory, or when you want to store data on disk for fault tolerance.
```python
from pyspark.sql import SparkSession
from pyspark import StorageLevel
spark = SparkSession.builder.appName("Cache vs Persist").getOrCreate()
df = spark.read.text("hdfs://path/to/file")
# persist() Syntax
DataFrame.persist(storageLevel: pyspark.storagelevel.StorageLevel = StorageLevel(True, True, False, True, 1)) 
dfPersist = df.persist()
dfPersist.show(false)
dfPersist = df.persist(StorageLevel.MEMORY_ONLY)
dfPersist.show(false)
```

==PySpark automatically monitors every `persist()` call you make and it checks usage on each node and drops persisted data if not used or by using the least-recently-used (LRU) algorithm.== 
	You can also manually remove using `unpersist()` method. unpersist() marks the DataFrame as non-persistent, and removes all blocks for it from memory and disk.

---
### SPARK HEAP MEMORY

InSpark, the Java Virtual Machine ([JVM]) heap is divided into two parts: **On-Heap** and **Off-Heap** memory.

1. On-Heap memory:
	1. Managed by [JVM]
	2. Loaded data is stored here as RDD.
2. Off-Heap memory:
	1. ==Managed by Operating System and Not JVM.==
	2. If you want to cache that [RDD] for faster access later, Py Spark will move it to Off-Heap memory.
	3. Good for Serialized Data but still cpu intensive then

 **_Spill to disk and GC memory are the features of JVM Heap.
In Spark, garbage collection is performed by the JVM. 
off-heap is not subject to spill and GC category as data stored here is mostly used as cache**

==Also spark overhead memory is always off-heap. Out of memory exceptions are caused by overhead memory as it exceeds the limit of its storage.==

Spark uses off-heap memory to store the following data:
- **_[Broadcast variables]_**: Broadcast variables are variables that are broadcast to all worker nodes in a Spark cluster. 
	- ==Because it caches these variables on each executor.==
- **_Accumulators:_** Accumulators are variables that are used to accumulate data from all worker nodes in a Spark cluster. 
	- Accumulators are typically used to aggregate data or count the number of times a certain operation is performed.
- **_Cache:_** Spark can cache data in memory to improve performance. 
	- ==Cached data is stored in off-heap memory by default.==

By understanding how Spark uses the JVM heap, garbage memory, and off-heap memory, you can optimize your Spark applications for performance.

```python
import random  
import time  
from pyspark.sql import SparkSession  
# Create a SparkSession  
spark = SparkSession.builder.appName("Spark Memory Example").getOrCreate()  
# Create a DataFrame with 10 million random integers  
df = spark.createDataFrame([(random.randint(0, 10000000),) for i in range(10000000)], ["value"])  
# Print the in-heap memory usage  
print("In-heap memory usage:", spark.sparkContext.getMemoryStatus().inUse())  
# Cache the DataFrame in off-heap memory  
df.persist()  
# Print the in-heap memory usage again  
print("In-heap memory usage after caching:", spark.sparkContext.getMemoryStatus().inUse())  
# Unpersist the DataFrame from off-heap memory  
df.unpersist()  
# Print the in-heap memory usage one last time  
print("In-heap memory usage after uncaching:", spark.sparkContext.getMemoryStatus().inUse())
```

```python
In-heap memory usage: 100000000  
In-heap memory usage after caching: 100000000  
In-heap memory usage after uncaching: 100000000
```

|`spark.driver.memoryOverhead`
`spark.driver.memoryOverheadFactor`, with minimum of 384
Amount of non-heap memory to be allocated per driver process in cluster mode, in MiB unless otherwise specified. This is memory that accounts for things like VM overheads, interned strings, other native overheads, etc. This tends to grow with the container size (typically 6-10%). This option is currently supported on YARN, Mesos and Kubernetes. _Note:_ Non-heap memory includes off-heap memory (when `spark.memory.offHeap.enabled=true`) and memory used by other driver processes (e.g. python process that goes with a PySpark driver) and memory used by other non-driver processes running in the same container. The maximum memory size of container to running driver is determined by the sum of `spark.driver.memoryOverhead` and `spark.driver.memory`.|

|   |   |   |
|---|---|---|
|`spark.executor.maxNumFailures`|numExecutors * 2, with minimum of 3|The maximum number of executor failures before failing the application. This configuration only takes effect on YARN, or Kubernetes when `spark.kubernetes.allocation.pods.allocator` is set to 'direct'.|
### WHEN ALREADY `spark.memory.storageFaction` is present then why it is required to have `offheap`
**`spark.memory.storageFraction` and Unified Memory:**
- It defines the portion of the unified memory dedicated to storing cached RDDs and broadcast variables.

**Off-Heap Memory:**
- This is a separate memory region outside the Java Heap (and the unified memory pool) that Spark can leverage for caching purposes.

**How They Work Together:**
1. **Spark prioritises off-heap memory for caching:** When `spark.memory.offHeap.enabled` is `true` and sufficient space is available, Spark will primarily use off-heap memory to store cached data
    
2. **Unified Memory as Overflow:** If the off-heap memory becomes full or isn't enabled
	1. Spark utilizes the unified memory pool for caching based on `spark.memory.storageFraction`. 

**Here's the key point:**
- `spark.memory.storageFraction` doesn't directly control off-heap memory allocation. 
	- It defines the storage space within the unified memory pool, which acts as a **fallback** when off-heap memory isn't available or isn't enough.

