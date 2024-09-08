The lakehouse is centered around the idea of unification and combining the best elements of different technologies in a single place of data warehouse and data lake.

The idea of the medallion architecture, a ==**popular data design pattern with Bronze, Silver, and Gold layers that is ultimately enabled via Delta Lake.**==

This popular pattern is used to organize data in a lakehouse or ADLS in an iterative manner to improve the structure and quality of data across your data lake, with each layer having specific functions and purposes for analytics while unifying batch and streaming data flows.

![Pasted image 20240305124127.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240305124127.png)

#### The Bronze Layer (Raw Data)

Raw data from the data sources is ingested into the Bronze layer without any transformations or business rule enforcement. This layer is the “landing zone” for our raw data, so all table structures in this layer correspond exactly to the source system structure.

==**The format of the data source is maintained, so when the data source is a CSV file, it is stored in Bronze as a CSV file, JSON data is written as JSON, etc. Data extracted from a database table typically lands in Bronze as a Parquet or AVRO file.**==

#### The Silver Layer

In the Silver layer we first cleanse and normalize the data. We ensure that standard formats are used for constructs such as ==**date and time, enforce the company’s column naming standard, de-duplicate the data, and perform a series of additional data quality checks, dropping low-quality data rows when needed.**==

Note that we apply a “just-enough” philosophy here, where we provide just enough detail with the least amount of effort possible, making sure that we maintain our agile approach to building our medallion architecture.

#### The Gold Layer

In the Gold layer, we create business-level aggregates. This can be done through a standard Kimball star schema, an Inmon snowflake schema dimensional model, or any other modeling technique that fits the consumer business use case. ==The final layer of data transformations and data quality rules is applied here, resulting in high- quality, reliable data that can serve as the single source of truth in the organization.==

## The Complete Lakehouse

Once you have implemented the medallion architecture as part of your Delta Lake– based architecture, you can start seeing the full benefits and extensibility of the lakehouse.

![Pasted image 20240305124541.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240305124541.png)

#### Example Projects:

```python
from pyspark.sql import SparkSession
from pyspark.sql.window import Window

spark = SparkSession.builder.appName("CustomerDemographics").getOrCreate()

# bronze layer
bronzePath = "/mnt/delta/customers/bronze/"

bronzeDF = spark.read.format("csv") \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .load("dbfs:/databricks-datasets/retail-org/customers/customers.csv")

bronzeDF.write.mode("overwrite").format("delta").save(bronzePath)

# silver layer
silverPath = "/mnt/delta/customers/silver/"

silverDF = spark.read.format("delta").load(bronzePath) \
    .withColumn("customer_name", initcap(trim(col("customer_name")))) \
    .withColumn("state", upper(trim(col("state")))) \
    .withColumn("city", initcap(trim(col("city")))) \
    .fillna({"tax_code": "UNKNOWN"}) \
    .dropDuplicates(["customer_id"])

silverDF.write.mode("overwrite").format("delta").save(silverPath)

# Read silver data
silverDF = spark.read.format("delta").load(silverPath)

# Example transformation: Rank customers by state based on their tax_code frequency
windowSpec = Window.partitionBy("state").orderBy(desc("tax_code"))
rankedDF = silverDF.withColumn("rank", rank().over(windowSpec))

# Add a 'customer_age_group' column based on arbitrary age logic for demonstration
enrichedDF = rankedDF.withColumn("customer_age_group", when(col("tax_id").substr(-1, 1) % 2 == 0, "Even").otherwise("Odd"))

enrichedDF.write.mode("overwrite").option("overwriteSchema", "true").format("delta").save(silverPath)


# Gold Layer
goldPath = "/mnt/delta/customers/gold/"

goldDF = spark.read.format("delta").load(silverPath) \
    .groupBy("state", "customer_age_group") \
    .agg(count("*").alias("total_customers"),
         collect_list("customer_name").alias("sample_customers")) \
    .orderBy("state", "total_customers")

goldDF.write.mode("overwrite").format("delta").save(goldPath)
```

SQL for Analytics

```sql

CREATE DATABASE customer;
USE customer;

CREATE TABLE customer_gold
SELECT *
FROM delta.`/mnt/delta/customers/gold/`;`

SElECT * FROM customer_gold;

SELECT state, total_customers
FROM customer_gold
ORDER BY total_customers DESC
LIMIT 10;

SELECT state, SUM(total_customers) AS customers_in_state
FROM customer_gold
GROUP BY state
ORDER BY customers_in_state DESC;

SELECT state, total_customers
FROM customer_gold
WHERE total_customers < 50 -- Assuming cities with less than 50 customers are underrepresented
ORDER BY total_customers;
```