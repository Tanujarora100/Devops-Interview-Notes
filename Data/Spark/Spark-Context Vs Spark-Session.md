In Apache Spark, both `SparkSession` and `SparkContext` are important components, but they serve different purposes and have different scopes of usage.

### Spark Context (`SparkContext`)

- **Purpose:** ==`SparkContext` was the main entry point for Spark applications before Spark 2.0. It represents the connection to a Spark cluster and is responsible for coordinating with that cluster.==
- **Functionality:**
    - Manages the execution of Spark jobs on the cluster.
    - ==Establishes communication with the cluster manager (e.g., YARN, Mesos, or Spark's standalone cluster manager).==
    - Distributes the application code (e.g., jars) across the cluster.
    - Allocates resources (CPU cores, memory) for Spark jobs.
- **Creation:** Typically, you create a `SparkContext` object manually in your Spark application.
```scala
import org.apache.spark.{SparkConf, SparkContext}

val conf = new SparkConf().setAppName("MySparkApp").setMaster("local[*]")
val sc = new SparkContext(conf)

```
### Spark Session (`SparkSession`)
- **Purpose:** Introduced in Spark 2.0, `SparkSession` simplifies the usage of Spark by combining the functionalities of ==**`SparkContext`, `SQLContext`, and `HiveContext` into a unified interface.==**
- **Functionality:**
    - Provides a single point of entry to interact with Spark functionality and allows interaction with Spark SQL.
    - Supports reading and writing DataFrames and Datasets.
    - Manages Spark configurations and resources under the hood.
- **Creation:** In Spark 2.x and later, you typically use `SparkSession.builder` to create a `SparkSession` object.
- ### Key Differences

- **Scope:** `SparkContext` is the entry point to Spark's core functionality and directly interacts with the cluster. ==It manages low-level operations such as RDDs (Resilient Distributed Datasets).==
- **API Unification:** `SparkSession` builds upon `SparkContext` and unifies the APIs for different Spark functionalities (SQL, DataFrame, Dataset) under one umbrella. It encapsulates `SparkContext` and provides higher-level abstractions for easier data manipulation.
- **Compatibility:** ==`SparkContext` is still used under the hood in `SparkSession` for managing RDDs, but for structured data processing (DataFrames, SQL), `SparkSession` is the preferred entry point.==