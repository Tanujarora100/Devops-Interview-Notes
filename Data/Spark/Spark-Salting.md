
## Salting in PySpark

- Salting is a technique used in PySpark to address data skewness during operations like joins and aggregations on large datasets.
- ==Data skewness occurs when data is unevenly distributed across partitions. 
- ==One partition can be very big compared to other partitions.==
- Even though AQE will coalesce smaller partitions but still salting is another manual technique to use.
- Broadcast will not be possible as it is more than 10MB.
![[Pasted image 20240618152400.png]]
#### How Salting Works:
- Adding a Random Value (Salt): Before performing the join or aggregation operation, ==a random value (salt) is appended to the key used for partitioning. This salt can be generated using a hash function or a random number generator.==
- Distributing Data More Evenly: Due to the added salt, the original skewed distribution of the key is broken. 
- ==Records with the same original key value will now be scattered across different partitions based on their unique salt values.==
- By adding a random salt to the join key, salting aims to spread the data more evenly across partitions. This prevents all rows with the same original key from ending up in the same partition.
	- However, the introduction of random salts does lead to additional shuffle during wide transformations. This is because rows that originally had the same key (before salting) might now be scattered across different partitions due to the random salt values.
	- To perform joins or aggregations, Spark needs to shuffle these scattered rows back together based on their original key (excluding the salt) during the shuffle phase.
- Improved Performance: By distributing the data more evenly across partitions, salting helps to avoid overloading any single partition and improves the overall performance of the operation.
- Hume saari keys ko replicate karna padega for smaller table
![[Pasted image 20240618153410.png]]
#### Benefits of Salting:    
	- Reduces the impact of data skewness on join and aggregation operations.

#### Limitations of Salting:
- It introduces additional data (the salt values) that might need to be stored and processed.
- ==Spark 3.0 and above: With the introduction of the Adaptive Query Engine (AQL), Spark automatically handles data skewness in many cases== reducing the need for manual salting. 
- **Shuffling:** Salting involves adding a random value ("salt") to the join key. This necessitates shuffling data to redistribute it based on the salted key. Shuffling can be resource-intensive, impacting performance.

### When to Consider Salting:
- If you suspect your data might be skewed and experience performance issues during joins or aggregations.
- If you are using Spark versions below 3.0 and AQL is not available.
