Apache Spark is a unified computing engine and a set of libraries for parallel data processing on computer clusters.

![Pasted image 20231124134358.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231124134358.png)


Spark is designed to support a wide range of data analytics tasks, ranging from simple data loading and SQL queries to machine learning and streaming computation, over the same computing engine and with a consistent set of APIs.

- Spark provides consistent, composable APIs that you can use to build an application out of smaller pieces or out of existing libraries.
- Spark’s APIs are also designed to enable high performance by optimising across the different libraries and functions composed together in a user program

For example, if you load data using a SQL query and then evaluate a machine learning model over it using Spark’s ML library, the engine can combine these steps into one scan over the data. The combination of general APIs and high- performance execution, no matter how you combine them, makes Spark a powerful platform for interactive and production applications.
We can perform different different actions on the same platform that is why it is unified in nature.

#### Computing engine

Spark handles loading data from storage systems and performing computation on it, not permanent storage as the end itself. You can use Spark with a wide variety of persistent storage systems, including cloud storage systems such as Azure Storage and Amazon S3, distributed file systems such as Apache Hadoop, key-value stores such as Apache Cassandra, and message buses such as Apache Kafka.

==Data is expensive to move so Spark focuses on performing computations over the data, no matter where it resides==

Hadoop included both a storage system (the Hadoop file system, designed for low-cost storage over clusters of commodity servers) and a computing system (MapReduce), which were closely integrated together. However, this choice makes it difficult to run one of the systems without the other.

#### Libraries

Spark’s final component is its libraries, which build on its design as a unified engine to provide a unified API for common data analysis tasks. ==Spark supports both standard libraries that ship with the engine as well as a wide array of external libraries published as third-party packages by the open source communities.

### Why do we need Spark? Big Data Problem
This trend in hardware stopped around 2005: due to hard limits in heat dissipation, hardware developers stopped making individual processors faster, and switched toward adding more parallel CPU cores all running at the same speed. This change meant that suddenly applications needed to be modified to add parallelism in order to run faster, which set the stage for new programming models such as Apache Spark.

In this new world, the software developed in the past 50 years cannot automatically scale up, and neither can the traditional programming models for data processing applications, creating the need for new programming models. It is this world that Apache Spark was built for.

Apache Spark began at UC Berkeley in 2009 as the Spark research project, which was first published the following year in a paper entitled “Spark: Cluster Computing with Working Sets”

At the time, Hadoop MapReduce was the dominant parallel programming engine for clusters