## ADAPTIVE QUERY ENGINE
Adaptive query execution (AQE) is a feature in Spark SQL
	- This can significantly improve query performance by choosing the most efficient plan for the actual data being processed.
	- AQE Can do the optimisations at runtime itself like sort merge join to broadcast depending on size of table.
	- Feature introduced in spark 3.0

- **Traditional Optimisation:** Spark typically creates a query plan based on estimated data statistics before actually running the query. 
    - These estimates might not always be accurate, leading to a sub-optimal plan.
    
- **Runtime Statistics:** With AQE, Spark gathers statistics as the query progresses through different stages (like shuffles or joins). This provides a more precise understanding of the data distribution and cardinality.
    
- **Plan Re-evaluation:** Based on the gathered runtime statistics, AQE can re-evaluate the chosen plan and make adjustments. This might involve:
    - **Coalescing Shuffle Partitions:** Combining small shuffle partitions into larger ones for better efficiency during data shuffling.
	    - Chote partitions ko utha kar merge kar dega taaki jaldi jaldi processing ho and task kam bane=> Less Resources and more uniform data and less cpu cores used even though thoda data distribution skewed hoga but still better hai.
	- ![[Pasted image 20240618015953.png]]
		    -![[Pasted image 20240618013834.png]]
    - **Dynamic Join Switch Strategy:** Switching between join types (e.g., broadcast hash join being faster for smaller datasets) based on actual data size at RUNTIME and can change the final plan which was initially designed in DAG
		- ![[Pasted image 20240618014913.png]]
    - **Skew Join Handling:** Optimising joins for skewed data distributions
		If your ==skewed data partition is more than 5 times of median and size of skewed data is greater than 256MB ==only then AQE will break the partition into smaller data partitions to process them faster, even though shuffling will happen during repartitioning but still cores bach jayengey
		In One table the data is more and in one data is less then the repartitions will have no table on other side to join to so we make the duplicates of the smaller partitions to join them
		![[Pasted image 20240618015744.png]]
		![[Pasted image 20240618014411.png]]
		![[Pasted image 20240618020053.png]]
**Benefits of AQE:**
- Improved query performance by selecting the most suitable execution plan.
- Reduced need for manual query tuning, as AQE adapts to different data scenarios.
- More efficient use of cluster resources.

**Enabling AQE:**
- AQE is enabled by default since Spark 3.2.0. You can control its behavior using configuration options like `spark.sql.adaptive.enabled`.