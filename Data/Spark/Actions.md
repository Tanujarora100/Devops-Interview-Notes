Transformations allow us to build up our logical transformation plan. To trigger the computation, we run an action.

An action instructs Spark to compute a result from a series of transformations.

```python
divisBy2.count()
```

The output of the preceding code should be 500.

### There are three kinds of actions:

- Actions to view data in the console
- Actions to collect data to native objects in the respective language
- Actions to write to output data sources

### What are the common Actions in Apache Spark?
- Reduce(func): This Action aggregates the elements of a dataset by using func function.
- Count(): This action gives the total number of elements in a Dataset.
- Collect(): This action will return all the elements of a dataset as an Array to the driver program.
- First(): This action gives the first element of a collection.
- Take(n): This action gives the first n elements of dataset.
- Foreach(func): This action runs each element in dataset through a for loop and executes function on each element.
