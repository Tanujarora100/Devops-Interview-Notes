- **What it is:** A Spark Job represents a complete computation initiated by a Spark action. Think of it as the ==highest level of work you submit to Spark for processing.== 
	- Jobs = ==Number of Actions==
![[Pasted image 20240617134115.png]]
    
- **When it's created:** A Job is triggered ==when you perform an action on an RDD, DataFrame, or Dataset.== Common actions include:
    - `collect()`: Retrieves all data from the cluster to the driver.
    - `count()`: Counts the number of elements.
    - `saveAsTextFile()`: Saves data to a file.
    - `take(n)`: Returns the first 'n' elements.
    - `show()`: Displays a subset of the data.
    - `read()`
    - `inferschema()`
- **Example:**
    
    ```python
    from pyspark import SparkContext
    
    sc = SparkContext("local", "JobExample")
    data = [1, 2, 3, 4, 5]
    rdd = sc.parallelize(data)
    
    # Triggering a Spark Job 
    result = rdd.reduce(lambda x, y: x + y)
    print(result)  # This action will create and execute a Spark Job 
    ```
    ![[Pasted image 20240617134025.png]]

**2. Spark Stage**

- **What it is:** A Job is broken down into smaller units of work called Stages. 
	- ==A Stage consists of a set of tasks that can be executed in parallel
		- they represent a sequence of transformations that can be computed together without shuffling data across the cluster.
	- When there is data shuffling , then it is called the Stage boundary ki iske baad next partition mei processing ki jayegi.
    
- **When it's created:** Spark automatically creates Stages whenever a shuffle operation (e.g., `reduceByKey`, `groupByKey`, `join`) is required within your data processing logic. 
	- Shuffles involve redistributing data among partitions, which necessitates breaking the job into distinct stages.
	- This is the logical plan 
	==Number of stages=> Number of wide transformations in the code ==
    
- **Example:**
    
    ```python
    rdd1 = sc.parallelize([(1, "a"), (2, "b"), (3, "c")])
    rdd2 = sc.parallelize([(1, "x"), (2, "y"), (4, "z")])
    
    # This join operation will introduce a shuffle
    joined_rdd = rdd1.join(rdd2) 
    
    result = joined_rdd.collect() # This action triggers the job, which will have at least two stages
    ```
    
**3. Spark Task**
	Any job will have minimum one stage and each stage will have minimum one tasks.
- **What it is:** A Task is the smallest unit of work in Spark. 
	- ==Each Stage is further divided into Tasks that operate on a single partition of data. ==
	- Tasks are sent by the driver program to worker nodes for execution.
	- So if we have shuffle operation and then AQE is turned off and default configuration then 200 tasks will be created one for each partition
- **When it's created:** Tasks are created for each partition of the RDD, DataFrame, or Dataset being processed within a Stage. 
	- ==The number of tasks per stage is equal to the number of partitions in the input data.==
- **Example:**
    If you have an RDD with 4 partitions and a Stage requires processing these partitions, Spark will create 4 Tasks (one for each partition) to execute the Stage's computations.
	    - These will be created as per `spark.sql.shuffle.partitions`
	    - Unlike input partitions, the size of shuffle partitions is not directly related to the size of the original data file.
	    - Shuffle partitions are dynamic and exist only during the execution of the specific wide transformation. After the shuffle operation is complete, these temporary partitions are no longer needed and are released from memory.


**In Summary**
- **Job:** High-level representation of your Spark computation (triggered by an action).
- **Stage:** A sequence of transformations that can be executed together without shuffling. Jobs are divided into Stages.
- **Task:** The smallest unit of work; a task processes a single partition of data within a Stage.

**Key Points**

- **Parallelism:** Tasks within a Stage are executed in parallel, allowing Spark to leverage distributed computing.
- **Dependencies:** Stages have