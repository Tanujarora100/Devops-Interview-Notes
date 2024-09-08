Spark applications are going to bring together a large number of different datasets. For this reason, joins are an essential part of nearly all Spark workloads. Spark’s ability to talk to different data means that you gain the ability to tap into a variety of data sources across your company.

### Join Expressions

A join brings together two sets of data, the left and the right, by comparing the value of one or more keys of the left and right and evaluating the result of a join expression that determines whether Spark should bring together the left set of data with the right set of data.

### Join Types

- Inner joins: Keeps rows with keys that exist in both the left and right datasets.
- Outer joins: Keeps rows with keys in either the left or right datasets.
- Left outer joins: Keeps rows with keys in the left dataset.
- Right outer joins: Keeps rows with keys in the right dataset.
- Left semi joins: Keeps rows in the left dataset where the key appears in the right dataset.
- Left anti joins: Keeps rows in the left dataset where they do not appear in the right dataset.
- Natural joins: Performs a join by implicitly matching columns with the same names.
- Cross (or Cartesian) joins: Matches every row in the left dataset with every row in the right dataset.

If you have ever interacted with a relational database system, or even an Excel spreadsheet, the concept of joining different datasets together should not be too abstract. Let’s move on to showing examples of each join type.
```python
person = spark.createDataFrame([ (0, "Bill Chambers", 0, [100]), (1, "Matei Zaharia", 1, [500, 250, 100]), (2, "Michael Armbrust", 1, [250, 100])])\ .toDF("id", "name", "graduate_program", "spark_status") graduateProgram = spark.createDataFrame([ (0, "Masters", "School of Information", "UC Berkeley"), (2, "Masters", "EECS", "UC Berkeley"), (1, "Ph.D.", "EECS", "UC Berkeley")])\ .toDF("id", "degree", "department", "school") sparkStatus = spark.createDataFrame([ (500, "Vice President"), (250, "PMC Member"), (100, "Contributor")])\ .toDF("id", "status")person = spark.createDataFrame([
  (0, "Bill Chambers", 0, [100]),
  (1, "Matei Zaharia", 1, [500, 250, 100]),
  (2, "Michael Armbrust", 1, [250, 100])])\

.toDF("id", "name", "graduate_program", "spark_status")
graduateProgram = spark.createDataFrame([

  (0, "Masters", "School of Information", "UC Berkeley"),
  (2, "Masters", "EECS", "UC Berkeley"),
  (1, "Ph.D.", "EECS", "UC Berkeley")])\

.toDF("id", "degree", "department", "school")
sparkStatus = spark.createDataFrame([

  (500, "Vice President"),
  (250, "PMC Member"),
  (100, "Contributor")])\

.toDF("id", "status")
```
#### Inner Joins

Inner joins evaluate the keys in both of the DataFrames or tables and include (and join together) only the rows that evaluate to true.

```python
joinExpression = person["graduate_program"] == graduateProgram['id']
```

Inner joins are the default join, so we just need to specify our left DataFrame and join the right in the JOIN expression:

```python
person.join(graduateProgram, joinExpression).show()
```
#### Outer Joins

Outer joins evaluate the keys in both of the DataFrames or tables and includes (and joins together) the rows that evaluate to true or false. If there is no equivalent row in either the left or right DataFrame, Spark will insert null

```python
joinType = "outer"
person.join(graduateProgram, joinExpression, joinType).show()
```

#### Left Outer Joins

Left outer joins evaluate the keys in both of the DataFrames or tables and includes all rows from the left DataFrame as well as any rows in the right DataFrame that have a match in the left DataFrame. If there is no equivalent row in the right DataFrame, Spark will insert null:

```python
joinType = "left_outer"
graduateProgram.join(person, joinExpression, joinType).show()
```

#### Right Outer Joins

Right outer joins evaluate the keys in both of the DataFrames or tables and includes all rows from the right DataFrame as well as any rows in the left DataFrame that have a match in the right DataFrame. If there is no equivalent row in the left DataFrame, Spark will insert null:

```python
joinType = "right_outer"
person.join(graduateProgram, joinExpression, joinType).show()
```

#### Left Semi Joins

Semi joins are a bit of a departure from the other joins. They do not actually include any values from the right DataFrame. They only compare values to see if the value exists in the second DataFrame. If the value does exist, those rows will be kept in the result, even if there are duplicate keys in the left DataFrame. Think of left semi joins as filters on a DataFrame, as opposed to the function of a conventional join:

```python
joinType = "left_semi"
graduateProgram.join(person, joinExpression, joinType).show()
```

#### left Anti Joins

Left anti joins are the opposite of left semi joins. Like left semi joins, they do not actually include any values from the right DataFrame. They only compare values to see if the value exists in the second DataFrame. However, rather than keeping the values that exist in the second DataFrame, they keep only the values that do not have a corresponding key in the second DataFrame. Think of anti joins as a NOT IN SQL-style filter:

```python
joinType = "left_anti"
graduateProgram.join(person, joinExpression, joinType).show()
```

#### Cross (Cartesian) Joins

The last of our joins are cross-joins or cartesian products. Cross-joins in simplest terms are inner joins that do not specify a predicate. Cross joins will join every single row in the left DataFrame to ever single row in the right DataFrame. This will cause an absolute explosion in the number of rows contained in the resulting DataFrame. If you have 1,000 rows in each DataFrame, the cross- join of these will result in 1,000,000 (1,000 x 1,000) rows. For this reason, you must very explicitly state that you want a cross-join by using the cross join keyword

```python
joinType = "cross"
graduateProgram.join(person, joinExpression, joinType).show()
```

`You should use cross-joins only if you are absolutely, 100 percent sure that this is the join you need. There is a reason why you need to be explicit when defining a cross-join in Spark. They’re dangerous!

### How Spark Performs Joins

To understand how Spark performs joins, you need to understand the two core resources at play: the node-to-node communication strategy and per node computation strategy. These internals are likely irrelevant to your business problem. However, comprehending how Spark performs joins can mean the difference between a job that completes quickly and one that never completes at all.

##### Communication Strategies

Spark approaches cluster communication in two different ways during joins.

- Shuffle join, which results in an all-to-all communication
- Broadcast join.

Some of these internal optimizations are likely to change over time with new improvements to the cost-based optimizer and improved communication strategies.

For this reason, we’re going to focus on the high-level examples to help you understand exactly what’s going on in some of the more common scenarios

**The core foundation of our simplified view of joins is that in Spark you will have either a big table or a small table.**

##### Big table–to–big table

When you join a big table to another big table, you end up with a shuffle join,

![Pasted image 20231219213008.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231219213008.png)  
In a shuffle join, every node talks to every other node and they share data according to which node has a certain key or set of keys (on which you are joining). These joins are expensive because the network can become congested with traffic, especially if your data is not partitioned well.

##### Big table–to–small table

When the table is small enough to fit into the memory of a single worker node, with some breathing room of course, we can optimize our join

Although we can use a big table–to–big table communication strategy, **it can often be more efficient to use a broadcast join.**

What this means is that we will replicate our small DataFrame onto every worker node in the cluster (be it located on one machine or many). Now this sounds expensive. However, what this does is prevent us from performing the all-to-all communication during the entire join process. Instead, we perform it only once at the beginning and then let each individual worker node perform the work without having to wait or communicate with any other worker node, as is depicted in

![Pasted image 20231219213140.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231219213140.png)

At the beginning of this join will be a large communication, just like in the previous type of join. However, immediately after that first, there will be no further communication between nodes.

```python
val joinExpr = person.col("graduate_program") === graduateProgram.col("id")
person.join(graduateProgram, joinExpr).explain()
```

With the DataFrame API, we can also explicitly give the optimizer a hint that we would like to use a broadcast join by using the correct function around the small DataFrame in question.

```python
import org.apache.spark.sql.functions.broadcast
val joinExpr = person.col("graduate_program") === graduateProgram.col("id")
person.join(broadcast(graduateProgram), joinExpr).explain()
```

##### Little table–to–little table

When performing joins with small tables, it’s usually best to let Spark decide how to join them. You can always force a broadcast join if you’re noticing strange behavior.