Lazy evaluation means that Spark will wait until the very last moment to execute the graph of computation instructions.

In Spark, instead of modifying the data immediately when you express some operation, you build up a plan of transformations that you would like to apply to your source data.

## Why Spark is Lazily Evaluated ? 
By waiting until the last minute to execute the code, Spark compiles this plan from your raw DataFrame transformations to a streamlined physical plan that will run as efficiently as possible across the cluster.

**Reduced Data Shuffling:** Spark can optimize transformations by grouping them together and performing them as a single operation, thus reducing unnecessary data shuffling between stages

**Fault Tolerance:** Spark's lazy evaluation model enables it to recover from failures more efficiently. Since transformations are not executed until an action is triggered, Spark can replay only the necessary portions of the computation in case of failures, rather than recomputing the entire data pipeline.

**Efficient Resource Utilization:** Lazily evaluating transformations allows Spark to make more informed decisions about resource allocation. It can determine the optimal number of tasks, partition sizes, and memory usage based on the complete execution plan rather than individual transformations.