User-Defined Functions  
One of the most powerful things that you can do in Spark is define your own functions. These user-defined functions (UDFs) make it possible for you to write your own custom transformations using Python or Scala and even use external libraries.

We’ll create a simple one for this example. Let’s write a power3 function that takes a number and raises it to a power of three:

```python
udfExampleDF = spark.range(5).toDF("num")

def power3(double_value):
    return double_value ** 3

power3(2.0)
```

In this trivial example, we can see that our functions work as expected. We are able to provide an individual input and produce the expected result (with this simple test case)

Now that we’ve created these functions and tested them, we need to register them with Spark so that we can use them on all of our worker machines. Spark will serialize the function on the driver and transfer it over the network to all executor processes. This happens regardless of language.

When you use the function, there are essentially two different things that occur.

- If the function is written in Scala or Java, you can use it within the Java Virtual Machine (JVM).
- If the function is written in Python, something quite different happens. Spark starts a Python process on the worker, serializes all of the data to a format that Python can understand, executes the function row by row on that data in the Python process, and then finally returns the results

![Pasted image 20231128140312.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020231128140312.png)

Now that you have an understanding of the process, let’s work through an example. First, we need to register the function to make it available as a DataFrame function:

```python
from pyspark.sql.functions import udf
power3udf = udf(power3)
```

```python
from pyspark.sql.functions import col
udfExampleDF.select(power3udf(col("num"))).show(2)
```

you can also call it in SQL

```sql
udfExampleDF.selectExpr("power3(num)").show(2)
```