The Structured APIs are a tool for manipulating all sorts of data, from unstructured log files to semi-structured CSV files and highly structured Parquet files.

These APIs refer to three core types of distributed collection APIs:

- Datasets
- DataFrames
- SQL tables and views

The Structured APIs are the fundamental abstraction that you will use to write the majority of your data flows.

#### [4. Spark DataFrame](https://publish.obsidian.md/datavidhya/Course+Notes/Apache+Spark/4.+Spark+DataFrame):

DataFrames table-like collections with well-defined rows and columns.

To Spark, DataFrames represents immutable, lazily evaluated plans that specify what operations to apply to data residing at a location to generate some output

#### Schemas

A schema defines the column names and types of a DataFrame. ==You can define schemas manually or read a schema from a data source (often called schema on read).== Schemas consist of types, meaning that you need a way of specifying what lies where.

Spark is effectively a programming language of its own. Internally, ==Spark uses an engine called Catalyst that maintains its own type information through the planning and processing of work.==

#### Catalyst Optimiser
Catalyst is the optimisation framework that underlies Apache Spark's SQL engine. It plays a crucial role in transforming SQL queries into efficient execution plans. Here’s an in-depth look at Catalyst and its significance:

##### Catalyst Optimiser Overview

==**Catalyst** is an extensible query optimisation framework in Spark SQL.== It is designed to handle the complexities of query optimisation and execution planning in a highly efficient manner. ==Catalyst is a key component of Spark SQL and the **DataFrame API,==** enabling Spark to optimize and execute queries efficiently.

##### Key Features of Catalyst Optimiser

1. **Rule-Based Optimisation**:
    - Catalyst uses a collection of rules to perform optimisations. These rules are applied iteratively to transform logical plans into more efficient forms.
2. **Cost-Based Optimisation (CBO)**:
    - ==Catalyst can use statistics to estimate the cost of various execution plans and choose the most efficient one. ==This involves analysing data distribution and other factors to make informed decisions.
3. **Extensibility**:
    - Catalyst is designed to be highly extensible. Developers can add new optimization rules, data sources, and data types.
4. **Logical and Physical Plans**:
    - Catalyst works by transforming a logical plan (which represents the query) into an optimized physical plan (which represents how the query will be executed).

#### Columns
Columns represent a simple type like an integer or string, a complex type like an array or map, or a null value.

#### Rows
A row is nothing more than a record of data. Each record in a DataFrame must be of type Row, as we can see when we collect the following DataFrames.

#### Spark Types
Spark Types are different data types supported by Spark, you can use following code to import types in your code

```python
  from pyspark.sql.types import *
  b = ByteType()
```

![Pasted image 20231128114940.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231128114940.png)

It’s worth keeping in mind that the types might change over time as Spark SQL continues to grow so you may want to reference [Spark’s documentation](https://spark.apache.org/docs/latest/sql-programming-guide.html#data-types) for future updates.

### Overview of Structured API Execution

Let’s walk through the execution of a single structured API query from user code to executed code. Here’s an overview of the steps:

1. Write DataFrame/Dataset/SQLCode.
2. If valid code, Spark converts this to a LogicalPlan.
3. Spark transforms this Logical Plan to a Physical Plan, checking for optimizations along the way.
4. Spark then executes this Physical Plan(RDD manipulations) on the cluster.  
    ![Pasted image 20231128115324.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231128115324.png)

#### Logical Planning

The first phase of execution is meant to take user code and convert it into a logical plan.

![Pasted image 20231128115434.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231128115434.png)

This logical plan only represents a set of abstract transformations to convert the user’s set of expressions into the most optimized version.

**- Unresolved Logical Plan:**  
It does this by converting user code into an unresolved logical plan. This plan is unresolved because although your code might be valid, the tables or columns that it refers to might or might not exist.  
**- Catalog**  
Spark uses the catalog, ==a repository of all table and DataFrame information, to resolve columns and tables in the analyser.== The analyser might reject the unresolved logical plan if the required table or column name does not exist in the catalog.  
**- Catalyst Optimizer:**  
a collection of rules that attempt to optimize the logical plan by pushing down predicates or selections.

### Physical Planning

After successfully creating an optimized logical plan, Spark then begins the physical planning process. ==The physical plan, often called a Spark plan, specifies how the logical plan will execute on the cluster==

![Pasted image 20231128115801.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231128115801.png)

An example of the cost comparison might be choosing how to perform a given join by looking at the physical attributes of a given table

### Execution
Upon selecting a physical plan, Spark runs all of this code over RDDs, the lower-level programming interface of Spark (which we cover in Part III). ==Spark performs further optimisations at runtime, generating native Java bytecode== that can remove entire tasks or stages during execution. Finally the result is returned to the user.

##### We already understood what is the [4. Spark DataFrame](https://publish.obsidian.md/datavidhya/Course+Notes/Apache+Spark/4.+Spark+DataFrame)

a DataFrame consists of a series of records (like rows in a table), that are of type Row, and a number of columns (like columns in a spreadsheet).

- Schemas define the name as well as the type of data in each column.
- Partitioning of the DataFrame defines the layout of the DataFrame or Dataset’s physical distribution across the cluster.
- The partitioning scheme defines how that is allocated.

```python
df = spark.read.format("json").load("/data/flight-data/json/2015-summary.json")

df.printSchema()
```

#### Schemas

A schema defines the column names and types of a DataFrame. We can either let a data source define the schema (called schema-on-read) or we can define it explicitly ourselves.

```python
  StructType(List(StructField(DEST_COUNTRY_NAME,StringType,true),
  StructField(ORIGIN_COUNTRY_NAME,StringType,true),
  StructField(count,LongType,true)))
```

A schema is a **StructType** made up of a number of fields, **StructFields**, that have a name, type, a **Boolean** flag which specifies whether that column can contain missing or null values,

### How to create and enforce a specific schema on a DataFrame

you can define your own schema type when you read files

```python
from pyspark.sql.types import StructField, StructType, StringType, LongType

  myManualSchema = StructType([
    StructField("DEST_COUNTRY_NAME", StringType(), True),
    StructField("ORIGIN_COUNTRY_NAME", StringType(), True),
    StructField("count", LongType(), False, metadata={"hello":"world"})

  ])  df = spark.read.format("json").schema(myManualSchema)\
  .load("/data/flight-data/json/2015-summary.json")
```

### Columns and Expressions

**Columns** in Spark are similar to columns in a spreadsheet, R dataframe, or pandas DataFrame. You can select, manipulate, and remove columns from DataFrames and these operations are represented as **expressions**.

There are a lot of different ways to construct and refer to columns but the two simplest ways are

```python
from pyspark.sql.functions import col, column
col("someColumnName")
column("someColumnName")
```

If you need to refer to a specific DataFrame’s column, you can use the col method on the specific DataFrame.

```python
df.col("count")
```

**Expression** is a set of transformations on one or more values in a record in a DataFrame. Think of it like a function that takes as input one or more column names, resolves them, and then potentially applies more expressions to create a single value for each record in the dataset.

In the simplest case, an expression, created via the expr function, is just a DataFrame column reference. In the simplest case, `expr("someCol")` is equivalent to `col("someCol").

```python
from pyspark.sql.functions import expr
expr("(((someCol + 5) * 200) - 6) < otherCol")
```

#### Accessing a DataFrame’s columns

Sometimes, you’ll need to see a DataFrame’s columns, which you can do by using something like printSchema; ==however, if you want to programmatically access columns, you can use the columns property to see all columns on a DataFrame==

```python
 spark.read.format("json").load("/data/flight-data/json/2015-summary.json").columns
```

### Records and Rows

In Spark, each row in a DataFrame is a single record. Spark represents this record as an object of type Row.

##### Creating Rows

You can create rows by manually instantiating a Row object with the values that belong in each column.

**It’s important to note that only DataFrames have schemas. Rows themselves do not have schemas.**

_This means that if you create a Row manually, you must specify the values in the same order as the schema of the DataFrame to which they might be appended_

```python
from pyspark.sql import Row
myRow = Row("Hello", None, 1, False)
```

Accessing Row:

```python
myRow[0]
myRow[2]
```

## DataFrame Transformations

### Creating DataFrames

```python
df = spark.read.format("json").load("/data/flight-data/json/2015-summary.json")
df.createOrReplaceTempView("dfTable")
```

or you can also do this

```python
from pyspark.sql import Row
from pyspark.sql.types import StructField, StructType, StringType, LongType
myManualSchema = StructType([
							 StructField("some", StringType(), True),
							 StructField("col", StringType(), True),
							 StructField("names", LongType(), False)
							 ])  
myRow = Row("Hello", None, 1)
myDf = spark.createDataFrame([myRow], myManualSchema)
myDf.show()
```

Now that you know how to create DataFrames, let’s take a look at their most useful methods that you’re going to be using: the select method when you’re working with columns or expressions,

and the selectExpr method when you’re working with expressions in strings.

#### select and selectExpr

##### select

select and selectExpr allow you to do the DataFrame equivalent of SQL queries on a table of data

```python
df.select("DEST_COUNTRY_NAME").show(2)
```

same as

```sql
SELECT DEST_COUNTRY_NAME FROM dfTable LIMIT 2
```

You can also select multiple columns

```python
df.select("DEST_COUNTRY_NAME", "ORIGIN_COUNTRY_NAME").show(2)
```

or you can also do something like this

```python
from pyspark.sql.functions import expr, col, column
df.select(
		  expr("DEST_COUNTRY_NAME"),
		  col("DEST_COUNTRY_NAME"),
		  column("DEST_COUNTRY_NAME")).show(2)
```

Using expr you can also change column name

```python
df.select(expr("DEST_COUNTRY_NAME AS destination")).show(2)

#or you can use alias on top the expr 
df.select(expr("DEST_COUNTRY_NAME as destination").alias("DEST_COUNTRY_NAME")).show(2)
```

##### **selectExpr**

This is probably the most convenient interface for everyday use:

```python
df.selectExpr("DEST_COUNTRY_NAME as newColumnName", "DEST_COUNTRY_NAME").show(2)
```

This opens up the true power of Spark. We can treat selectExpr as a simple way to build up complex expressions that create new DataFrames.

```python
df.selectExpr(
    "*", # all original columns
    "(DEST_COUNTRY_NAME = ORIGIN_COUNTRY_NAME) as withinCountry")\
    .show(2)
```

we can also specify aggregations over the entire DataFrame by taking advantage of the functions that we have

```python
df.selectExpr("avg(count)", "count(distinct(DEST_COUNTRY_NAME))").show(2)
```

#### Converting to Spark Types (Literals)

Sometimes, we need to pass explicit values into Spark that are just a value (rather than a new column). This might be a constant value or something we’ll need to compare to later on. The way we do this is through literals.

```python
from pyspark.sql.functions import lit
df.select(expr("*"), lit(1).alias("One")).show(2)
```

#### Adding Columns

There’s also a more formal way of adding a new column to a DataFrame, and that’s by using the withColumn method on our DataFrame. For example, let’s add a column that just adds the number one as a column:

```python
df.withColumn("numberOne", lit(1)).show(2)
```

Let’s do something a bit more interesting and make it an actual expression. We’ll set a Boolean flag for when the origin country is the same as the destination country:

```python
#withColumn function takes two arguments: the column name and the expression that will create the value for that given row in the DataFrame
df.withColumn("withinCountry", expr("ORIGIN_COUNTRY_NAME == DEST_COUNTRY_NAME")).show(2)
```

#### Renaming Columns

Although we can rename a column in the manner that we just described, another alternative is to use the **withColumnRenamed** method

```python
df.withColumnRenamed("DEST_COUNTRY_NAME", "dest").columns
```

#### Removing Columns

Now that we’ve created this column, let’s take a look at how we can remove columns from DataFrames.

```python
df.drop("ORIGIN_COUNTRY_NAME").columns
```

We can drop multiple columns by passing in multiple columns as arguments:

```python
df.WithLongColName.drop("ORIGIN_COUNTRY_NAME", "DEST_COUNTRY_NAME")
```

#### Changing a Column’s Type (cast)

Sometimes, we might need to convert from one type to another; for example, if we have a set of StringType that should be integers. We can convert columns from one type to another by casting the column from one type to another.

```python
df.withColumn("count2", col("count").cast("long"))
```

#### Filtering Rows

To filter rows, we create an expression that evaluates to true or false. You then filter out the rows with an expression that is equal to false.

There are two methods to perform this operation:

- where
- filter

They both will perform the same operation and accept the same argument types when used with DataFrames

```python
df.filter(col("count") < 2).show(2)
df.where("count < 2").show(2)
```

Applying Multiple Filter

```python
df.where(col("count") < 2).where(col("ORIGIN_COUNTRY_NAME") != "Croatia").show(2)
```

#### Getting Unique Rows

A very common use case is to extract the unique or distinct values in a DataFrame. These values can be in one or more columns. The way we do this is by using the distinct method on a DataFrame

```python
df.select("ORIGIN_COUNTRY_NAME", "DEST_COUNTRY_NAME").distinct().count()
```

#### Concatenating and Appending Rows (Union)

To append to a DataFrame, you must union the original DataFrame along with the new DataFrame. This just concatenates the two DataFrames.

To union two DataFrames, you must be sure that they have the same schema and number of columns; otherwise, the union will fail.

```python
  from pyspark.sql import Row
  schema = df.schema
  newRows = [
    Row("New Country", "Other Country", 5L),
    Row("New Country 2", "Other Country 3", 1L)
  ]
  parallelizedRows = spark.sparkContext.parallelize(newRows)
  newDF = spark.createDataFrame(parallelizedRows, schema)


  df.union(newDF)\
    .where("count = 1")\
    .where(col("ORIGIN_COUNTRY_NAME") != "United States")\
    .show()

```

#### Sorting Rows

When we sort the values in a DataFrame, we always want to sort with either the largest or smallest values at the top of a DataFrame. 0. There are two equivalent operations to do this sort and orderBy that work the exact same way.

```python
df.sort("count").show(5)
df.orderBy("count", "DEST_COUNTRY_NAME").show(5)
df.orderBy(col("count"), col("DEST_COUNTRY_NAME")).show(5)
```

To more explicitly specify sort direction, you need to use the asc and desc functions if operating on a column.

```python
from pyspark.sql.functions import desc, asc
df.orderBy(expr("count desc")).show(2)
df.orderBy(col("count").desc(), col("DEST_COUNTRY_NAME").asc()).show(2)
```

#### Limit

Oftentimes, you might want to restrict what you extract from a DataFrame; for example, you might want just the top ten of some DataFrame.

```python
df.limit(5).show()

df.orderBy(expr("count desc")).limit(6).show()
```

#### Repartition and Coalesce

Another important optimization opportunity is to [5. Partitions](https://publish.obsidian.md/datavidhya/Course+Notes/Apache+Spark/5.+Partitions) the data according to some frequently filtered columns, which control the physical layout of data across the cluster including the partitioning scheme and the number of partitions.

==**Repartition** will incur a full shuffle of the data, regardless of whether one is necessary. This means that you should typically only repartition when the future number of partitions is greater than your current number of partitions== or when you are looking to partition by a set of columns

get number of partitions

```python
df.rdd.getNumPartitions() # 1
```

repartition data

```python
df.repartition(5)
```

If you know that you’re going to be filtering by a certain column often, it can be worth repartitioning based on that column

```python
df.repartition(col("DEST_COUNTRY_NAME"))

#create more partition
df.repartition(5, col("DEST_COUNTRY_NAME"))
```

Coalesce, on the other hand, will not incur a full shuffle and will try to combine partitions. ==This operation will shuffle your data into five partitions based on the destination country name, and then coalesce them (without a full shuffle): ==

```python
df.repartition(5, col("DEST_COUNTRY_NAME")).coalesce(2)
```

#### Collecting Rows

collect gets all data from the entire DataFrame, take selects the first N rows, and show prints out a number of rows nicely.

```python
collectDF = df.limit(10)
collectDF.take(5) # take works with an Integer count
collectDF.show() # this prints it out nicely
collectDF.show(5, False)
collectDF.collect()
```

`Any collection of data to the driver can be a very expensive operation! If you have a large dataset and call collect, you can crash the driver. If you use toLocalIterator and have very large partitions,you can easily crash the driver node and lose the state of your application. This is also expensive because we can operate on a one-by-one basis, instead of running computation in parallel`