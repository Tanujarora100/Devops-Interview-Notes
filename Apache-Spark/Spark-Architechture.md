

![Pasted image 20231127200109.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231127200109.png)

### Spark Applications

Spark Applications consist of a **driver process** and a set of **executor processes.**

##### Driver Process:
The driver in Spark is responsible for:

1. **Scheduling Tasks**: It translates the high-level operations (like transformations and actions) on RDDs or DataFrames into an execution plan composed of tasks.
2. **Task Distribution**: It distributes these tasks to worker nodes (executors) in the cluster.
3. **Job Coordination**: It manages the execution of jobs, stages, and tasks.
4. **Maintaining Metadata**: It keeps track of metadata such as the RDD lineage, DAG (Directed Acyclic Graph) of stages, and partition information.
5. **Collecting Results**: It gathers the results from executors and returns them to the user application.

### Components of the Driver

- **SparkContext**: The main entry point for Spark functionality. It allows the Spark driver to access Spark cluster resources and can be used to create RDDs, accumulators, and broadcast variables.
- **DAGScheduler**: Responsible for converting logical execution plans into physical execution plans, managing stages and tasks.
- **TaskScheduler**: Manages the scheduling of tasks on different executors.
- **Backend**: Communicates with the cluster manager (e.g., YARN, Mesos, or standalone) to request resources and launch executors.

### Execution Flow

1. **Application Submission**: The user submits a Spark application. This application runs the driver program.
2. **Job Execution**:
    - The driver program creates a `SparkContext`.
    - The user application code (e.g., transformations and actions) is executed on the driver.
    - The `DAGScheduler` divides the job into stages based on wide dependencies (e.g., shuffles).
    - The `TaskScheduler` assigns tasks to executors.
    - The cluster manager allocates resources, and executors are launched.
3. **Task Execution**: Executors execute tasks as directed by the driver and report their status and results back to the driver.
4. **Result Collection**: The driver collects results from executors, and the final output is returned to the user application.

### Driver Resource Configuration

The performance and stability of the driver can be influenced by its resource configuration. Important configurations include:

- **Memory**: `spark.driver.memory` (default: 1g)
    - Specifies the amount of memory to use for the driver process. If the driver needs more memory for its operations, increase this value.
- **Cores**: `spark.driver.cores` (default: 1)
    - Specifies the number of CPU cores to use for the driver. Increase this if the driver is performing a lot of computation.

### Driver Failures

Driver failures can happen due to:

- **Out of Memory**: If the driver memory is insufficient.
- **Resource Exhaustion**: If the driver runs out of cores or encounters excessive garbage collection.
- **Network Issues**: Network connectivity problems between the driver and the cluster manager or executors.

To mitigate driver failures:

- Ensure adequate memory and CPU resources are allocated.
- Optimize the code to minimize driver-side operations.
- Use checkpointing for long-running applications.

### Best Practices

- **Driver Resource Management**: Allocate sufficient resources based on the workload. Monitor the driver's resource usage and adjust configurations as necessary.
- **Fault Tolerance**: Use checkpointing and save intermediate results to HDFS or another distributed storage to recover from driver failures.
- **Monitoring and Logging**: Use Spark's built-in monitoring tools, such as the web UI and event logs, to keep track of driver performance and identify potential issues.
- **Code Optimization**: Minimize the amount of data collected to the driver. Use actions like `count` or `take` instead of `collect` when possible.

**Executor Processes.**:  
The executors are responsible for actually carrying out the work that the driver assigns them.

- Executing code assigned to it by the driver
- Reporting the state of the computation on that executor back to the driver node.

==Spark, in addition to its cluster mode, also has a local mode. Which means that they can live on the same machine or different machines. ==
### WHAT IS LOCAL MODE 
In local mode, the driver and executors run (as threads) on your individual computer instead of a cluster.


![Pasted image 20231127200818.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231127200818.png)

Each language API maintains the same core concepts that we described earlier. ==There is a SparkSession object available to the user, which is the entrance point to running Spark code. When using Spark from Python or R, you don’t write explicit JVM instructions; instead, you write Python and R code that Spark translates into code that it then can run on the executor JVMs.==

### The SparkSession

You control your Spark Application through a ==driver process called the **SparkSession.**

The SparkSession instance is the way Spark executes user-defined manipulations across the cluster. ==There is a one-to-one correspondence between a SparkSession and a Spark Application.==

In Scala and Python, the variable is available as spark when you start the console.

```python
spark
```

output:

```
  <pyspark.sql.session.SparkSession at 0x7efda4c1ccd0>
```

Example:

```python
 myRange = spark.range(1000).toDF("number")
```



![Pasted image 20231128204134.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231128204134.png)

### SPARK CONTAINERS VS EXECUTORS
In Spark, containers and executors are two interrelated concepts that play a crucial role in distributed processing:

- **Containers:** These are lightweight environments provided by resource managers like YARN or Kubernetes. They encapsulate an application's code, libraries, and configurations, along with the necessary resources (CPU, memory) to run that application. Think of them as standardised units for packaging and isolating workloads.
- **Executors:** These are Spark's workhorses responsible for executing tasks distributed across the cluster. Each Spark application has one or more executors running within containers allocated by the resource manager. An executor manages a set of cores and memory on a worker node in the cluster. Spark distributes tasks to the executors, which then execute them in parallel.
- **Container-Executor Binding:** In most deployments (YARN, Mesos), there's a one-to-one mapping between containers and executors. 
	- ==A single container houses one executor process. This binding ensures that resources allocated to the container are exclusively used by the corresponding Spark executor.==
- **Spark Driver and Executors:** The Spark driver, which coordinates the application's tasks, doesn't run within containers. It can be in client mode (on your local machine) or cluster mode (on a cluster node). The driver communicates with the executors to schedule and manage tasks.

**Key Points to Remember:**
- Containers provide isolation and resource management for Spark executors.
- The number of executors can be configured to control the degree of parallelism in your Spark application.
- ==Resource managers like YARN or Kubernetes manage the allocation of containers for executors.==

### What is an Executor
Yes, an executor in Spark is a process. It's a long-running process that executes on a worker node in the cluster.  It is a JVM process with it's own Heap Space and Own Cores running in a container given by the YARN
**Responsibilities of an Executor Process:**
- **Task Execution:** The primary function of an executor is to execute tasks assigned to it by the Spark driver. 
	- These tasks could involve data transformations, aggregations, or other computations defined in your Spark application.
	- ==In some deployments (like Kubernetes), a container might house multiple executor cores (threads) for parallel execution within the same container.==
- **Resource Management:** Each executor manages its allocated resources on the worker node, including memory and CPU cores.
	- Each Spark application has one or more executors. 
	- ==These executors run **inside** the containers allocated by the resource manager on the worker nodes.==

**Key Points:**

- Executors are separate from the Spark driver process, which coordinates the application.
- Multiple executors can run concurrently on a cluster, enabling parallel processing of tasks.
- The number of executors can be configured to optimize performance based on your application's needs and the available resources in the cluster.

In essence, executors are the workhorses that translate your Spark application logic into concrete actions on the worker nodes, leveraging the processing power of the cluster.