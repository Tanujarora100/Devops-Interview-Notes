To allow every executor to perform work in parallel, Spark breaks up the data into chunks called partitions.
Executor is a process that is running on the worker node or the slave node.

A DataFrame’s partitions represent how the data is physically distributed across the cluster of machines during execution.

- If you have one partition, Spark will have a parallelism of only one, even if you have thousands of executors.
- If you have many partitions but only one executor, Spark will still have a parallelism of only one because there is only one computation resource. So Spark is pretty smart about computation.

DataFrames are high-level transformations, you do not (for most of the part) manipulate partitions manually or individually.

Lower-level APIs do exist (via the [18. Resilient Distributed Dataset (RDD)](https://publish.obsidian.md/datavidhya/Course+Notes/Apache+Spark/18.+Resilient+Distributed+Dataset+(RDD)) interface)