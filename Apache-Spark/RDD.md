### WHAT ARE RDD
Unlike DataFrames though, where each record is a structured row containing fields with a known schema, ==in RDDs the records are just Java, Scala, or Python objects of the programmer’s choosing.==

RDDs give you complete control because every record in an RDD is a just a Java or Python object. 
	You can store anything you want in these objects, in any format you want. This gives you great power, but not without potential issues.
	Every manipulation and interaction between values must be defined by hand, meaning that you must “reinvent the wheel” for whatever task you are trying to carry out.

==Also, optimisations are going to require much more manual work, because Spark does not understand the inner structure of your records as it does with the Structured APIs.==
### What is a Lineage Graph

In Apache Spark, a lineage graph is a directed acyclic graph (DAG) that represents the **logical execution plan** of your Spark application, specifically focusing on the lineage of Resilient Distributed Datasets (RDDs) or DataFrames.
**Components:**
- **Nodes:** Each node signifies a specific stage in the data processing pipeline.
- **Edges:** These connect the nodes and depict the transformations applied to data. 
![[Pasted image 20240618222451.png]]
**Benefits of Lineage Graphs:**
- **Fault Tolerance:** Spark can use the lineage graph to reconstruct the lost data by re-applying the transformations on the parent RDDs. 
- **Debugging:** Lineage graphs can be helpful for debugging data processing issues. 
- **Performance Optimization:** Understanding the lineage can help you identify potential bottlenecks in your Spark application. 

### LINEAGE GRAPH VS DAG
**DAG** (direct acyclic graph) is the representation of the way Spark will execute your program - each vertex on that graph is a separate operation and edges represent dependencies of each operation. Your pr
ogram (thus DAG that represents it) may operate on multiple entities (RDDs, Dataframes, etc). 
	- **RDD Lineage** is just a portion of a DAG (one or more operations) that lead to the creation of that particular RDD.
	- So, one DAG (one Spark program) might create multiple RDDs, and each RDD will have its lineage (i.e that path in your DAG that lead to that RDD). 
	- If some partitions of your RDD got corrupted or lost, then Spark may rerun that part of the DAG that leads to the creation of those partitions.
==If the sole purpose of your Spark program is to create only one RDD and it's the last step, then the whole DAG is a lineage of that RDD

## STORAGE LEVELS
In Apache Spark, storage levels are used to determine how Resilient Distributed Datasets (RDDs) or DataFrames are stored across your cluster. 

- **Storage Levels:**    
    - **MEMORY_ONLY:** Stores data entirely in memory (deserialized Java objects)  for fast access but consumes significant memory.
    - **MEMORY_ONLY_SER:** Similar to MEMORY_ONLY, but stores data as serialized objects in memory, reducing memory footprint but requiring deserialisation overhead during access.
    - **MEMORY_AND_DISK:** Stores data partitions in memory if they fit, spilling the rest to disk. 
	    - Ideal for datasets exceeding available memory.
    - **MEMORY_AND_DISK_SER:** Combines MEMORY_AND_DISK with serialization for memory efficiency, similar to MEMORY_ONLY_SER.
    - **DISK_ONLY:** Stores data solely on disk for situations where memory is insufficient or persistence across application restarts is needed.
    - **OFF_HEAP:** Stores data in off-heap memory (outside the Java heap) for potentially better performance if available on your cluster.
	    - `spark.memory.offheap.enabled='True'`
The selection of storage level depends on factors like data size, memory availability, desired performance, and fault tolerance requirements.

- For small datasets or performance-critical operations, MEMORY_ONLY or MEMORY_ONLY_SER might be suitable.
- For larger datasets exceeding memory, consider MEMORY_AND_DISK or MEMORY_AND_DISK_SER for a balance between speed and memory usage.
- If memory is scarce or persistence is essential, opt for DISK_ONLY.
- ==Utilize OFF_HEAP cautiously, ensuring your cluster supports it for potential performance gains.==