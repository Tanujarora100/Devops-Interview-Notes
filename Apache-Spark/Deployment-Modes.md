### Client Mode

- In Client mode, **the driver runs on the same machine where you submit the Spark job.**
	- This is the default mode and is ideal for development, testing, or working with small datasets on your local machine.
- **Benefits:**
    - Simple to set up
    - Good for interactive Spark sessions (e.g., Spark shell)
- **Drawbacks:**
    - Limited resources of a single machine
    - The application crashes if the client machine crashes.
    - Network connection is required for the whole life cycle of the job.

### Cluster Mode
- In Cluster mode, the driver is submitted to the cluster manager (like YARN or Mesos) and runs on one of the nodes in the cluster. 
	- This is the preferred mode for production environments or working with large datasets.
- **Benefits:**
    - Leverages the resources of the entire cluster
    - Improved fault tolerance as the driver runs on the cluster.
    - Network connection is required till only job submission
- **Drawbacks:**
    - configured cluster manager.
    - Slightly more complex setup.
### **Local Mode**

In local mode, Spark runs in a single JVM (Java Virtual Machine) on a single machine. 
	This mode is primarily used for development, testing, and debugging. It is the simplest mode to set up and does not require a cluster manager.

**Usage:** `spark-submit --master local[<n>]`

- `local`: Runs Spark with one thread.
- **`local[N]`: Runs Spark with `N` threads (ideally, set to the number of cores on your machine).**
- `local[*]`: Runs Spark with as many threads as logical cores on your machine.

### STANDALONE MODE
==In Spark, standalone mode is a simple deployment mode where you manage your own cluster resources without relying on an external cluster manager like YARN or Mesos== 
Here's how standalone mode works:

- **Spark Installation:** You manually install Spark on each node in the cluster, including the Spark driver and worker nodes. This ensures all necessary libraries and configurations are available for running Spark applications.
- **Master and Workers:** ==Standalone mode uses a master-worker architecture. ==
- **Spark Driver:** The Spark driver program can run on any machine in the cluster, similar to client mode. 

**Benefits of Standalone Mode:**
- **Simplicity:** Easy to set up and use, especially for small clusters.
- **Lightweight:** Doesn't require the overhead of a complex resource management system.
- **Direct Control:** You have full control over the cluster configuration and resource allocation.

**Drawbacks of Standalone Mode:**
- **Scalability Limitations:**
- **Fault Tolerance:** 
- **Resource Management:** 
