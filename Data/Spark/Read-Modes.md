#### Read modes

Reading data from an external source naturally entails encountering malformed data, especially when working with only semi-structured data sources.
- **permissive**: Sets all fields to null when it **encounters a corrupted record and places all corrupted records in a string column called _corrupt_record**
	- Default Mode of spark
	- Two Things Karega:
		- Null Set Karega
		- _corrupt_record mei place karega jo string type hoga.
- **dropMalformed**: Drops the row that contains malformed records, but will not stop the job like FailFast.
- ==**failFast**: Fails immediately upon encountering malformed records, even if one record is found it will fail the job immediately**==

##### Basics of Writing Data

The foundation for writing data is quite similar to that of reading data. Instead of the DataFrameReader, we have the DataFrameWriter. Because we always need to write out some given data source

```
dataframe.write.format("csv")
    .option("mode", "OVERWRITE")
    .option("dateFormat", "yyyy-MM-dd")
    .option("path", "path/to/file(s)")
    .save()
```

##### Save modes Or Write Modes 

Save modes specify what will happen if Spark finds data at the specified location (assuming all else equal).

- **append**: Appends the output files to the list of files that already exist at that location
- **overwrite**: Will completely overwrite any data that already exists there
- ==**errorIfExists**: Throws an error and fails the write if data or files already exist at the specified location==
- **ignore**: If data or files exist at the location, do nothing with the current DataFrame

`The default is errorIfExists. This means that if Spark finds data at the location to which you’re writing, it will fail the write immediately.`

#### CSV Files

CSV stands for comma values. This is a common text file format in which each line represents a single record, and commas separate each field within a record.

reading csv file

```python
spark= SparkSession.builder().app('csvreading').getOrCreate()
df=spark.read.format("csv")
    .option("header", "true")
    .option("mode", "FAILFAST")
    .option("inferSchema", "true")
    .load("some/path/to/file.csv")
```

writing csv file

```python
csvFile = spark.write.format("csv")\
    .option("header", "true")\
    .option("mode", "FAILFAST")\
    .option("inferSchema", "true")\
    .load("/data/flight-data/csv/2010-summary.csv")
```

you can also convert CSV to TSV

```python
csvFile.write.format("csv").mode("overwrite").option("sep", "\t")\
.save("/tmp/my-tsv-file.tsv")
```

#### JSON

Those coming from the world of JavaScript are likely familiar with JavaScript Object Notation, or JSON, as it’s commonly called.

In Spark, when we refer to JSON files, we refer to line-delimited JSON files. This contrasts with files that have a large JSON object or array per file.

The line-delimited versus multiline trade-off is controlled by a single option: multiLine. When you set this option to true, you can read an entire file as one json object and Spark will go through the work of parsing that into a DataFrame.

###### Reading JSON Files

Let’s look at an example of reading a JSON file and compare the options that we’re seeing:

```python
spark.read.format("json").option("mode", "FAILFAST")\
  .option("inferSchema", "true")\
  .load("/data/flight-data/json/2010-summary.json").show(5)
```

##### Writing JSON Files

```python
svFile.write.format("json").mode("overwrite").save("/tmp/my-json-file.json")
```

##### Parquet Files

Parquet is an open source column-oriented data store that provides a variety of storage optimizations, especially for analytics workloads. It provides columnar compression, which saves storage space and allows for reading individual columns instead of entire files. It is a file format that works exceptionally well with Apache Spark and is in fact the default file format.

Advantage of Parquet is that it supports complex types. This means that if your column is an array (which would fail with a CSV file, for example), map, or struct, you’ll still be able to read and write that file without issue

```python
 spark.read.format("parquet")\
	 .load("/data/flight-data/parquet/2010-summary.parquet").show(5)

csvFile.write.format("parquet").mode("overwrite")\
    .save("/tmp/my-parquet-file.parquet")
```

##### ORC Files

ORC is a self-describing, type-aware columnar file format designed for Hadoop workloads. It is optimized for large streaming reads, but with integrated support for finding required rows quickly.

```python
spark.read.format("orc").load("/data/flight-data/orc/2010-summary.orc").show(5)

csvFile.write.format("orc").mode("overwrite").save("/tmp/my-json-file.orc")
```

##### Text Files

Spark also allows you to read in plain-text files. Each line in the file becomes a record in the DataFrame.

```python
spark.read.textFile("/data/flight-data/csv/2010-summary.csv")
    .selectExpr("split(value, ',') as rows").show()

csvFile.select("DEST_COUNTRY_NAME").write.text("/tmp/simple-text-file.txt")
```

you can also write it as CSV

```python
csvFile.limit(10).select("DEST_COUNTRY_NAME", "count")\
    .write.partitionBy("count").text("/tmp/five-csv-files2py.csv")
```

### Advanced I/O Concepts

We saw previously that we can control the parallelism of files that we write by controlling the partitions prior to writing. We can also control specific data layout by controlling two things:

- bucketing
- partitioning

##### Writing Data in Parallel

The number of files or data written is dependent on the number of partitions the DataFrame has at the time you write out the data.

By default, one file is written per partition of the data. This means that although we specify a “file,” it’s actually a number of files within a folder, with the name of the specified file, with one file per each partition that is written.

For example, the following code

```python
csvFile.repartition(5).write.format("csv").save("/tmp/multiple.csv")
```

will end up with five files inside of that folder. As you can see from the list call:

`ls /tmp/multiple.csv`

```
/tmp/multiple.csv/part-00000-767df509-ec97-4740-8e15-4e173d365a8b.csv
 /tmp/multiple.csv/part-00001-767df509-ec97-4740-8e15-4e173d365a8b.csv
 /tmp/multiple.csv/part-00002-767df509-ec97-4740-8e15-4e173d365a8b.csv
 /tmp/multiple.csv/part-00003-767df509-ec97-4740-8e15-4e173d365a8b.csv
 /tmp/multiple.csv/part-00004-767df509-ec97-4740-8e15-4e173d365a8b.csv
```

##### Partitioning During Write

Partitioning is a tool that allows you to control what data is stored (and where) as you write it. 
When you write a file to a partitioned directory (or table), you basically encode a column as a folder. What this allows you to do is skip lots of data when you go to read it in later, allowing you to read in only the data relevant to your problem instead of having to scan the complete dataset.


```python
csvFile.limit(10).write.mode("overwrite").partitionBy("DEST_COUNTRY_NAME")\
    .save("/tmp/partitioned-files.parquet")

df.coalesce(1).write.format('csv')\
    .option('header','true')\
    .option('mode','permissive')\
    .partitionBy('country')\
    .save('/FileStore/tables/results/CountryWiseData')
```

```
$ ls /tmp/partitioned-files.parquet

...
DEST_COUNTRY_NAME=Costa Rica/
DEST_COUNTRY_NAME=Egypt/
DEST_COUNTRY_NAME=Equatorial Guinea/
DEST_COUNTRY_NAME=Senegal/
DEST_COUNTRY_NAME=United States/
```

##### Bucketing

Bucketing is another file organization approach with which you can control the data that is specifically written to each file. This can help avoid shuffles later when you go to read the data because data with the same bucket ID will all be grouped together into one physical partition

```python
val numberBuckets = 10
val columnToBucketBy = "count"

csvFile.write.format("parquet").mode("overwrite")
.bucketBy(numberBuckets, columnToBucketBy).saveAsTable("bucketedFiles")
```

```
$ ls /user/hive/warehouse/bucketedfiles/

part-00000-tid-1020575097626332666-8....parquet
part-00000-tid-1020575097626332666-8....parquet
part-00000-tid-1020575097626332666-8....parquet
...
```

### How To Create Schema
Ways:
1) StructType and StructField: Struct-type defines the structure of the data frame.
	1) Structtype is the collection of structfields.
2) DDL Schema

```python
from pyspark.sql.types import StructField,StructType,DateType, StringType,IntegerType,FloatType
covid_day_wise_data_schema= StructType([

StructField('Date',DateType()),
StructField('Confirmed_Deaths',IntegerType()),
StructField('Recovered',IntegerType()),
StructField('New_Cases',IntegerType()),
StructField('New_Recovered',IntegerType()),
StructField('DeathCountPer100Cases',FloatType()),
StructField('RecoverdCountPer100Cases',FloatType()),
StructField('DeathCountPer100Recovered',FloatType()),
StructField('Number_of_countries',IntegerType()),

])
```

### How to Remove the header or skip the header

```python
spark.read.format('csv').option('header','true')\
.option('skipRows',1).mode('permissive').load(file_path)

```

### How to handle Corrupted Records
- talk about read modes and how which read mode is suitable for corrupted records
- If you need the corrupted records
- Make a custom schema and add a column _corrupt_records and then read the file with the custom schema
- to Store these bad records read the option with =="badrecordsPath"==
```python
spark.read.format('csv').option('header','true')\
.option("badrecordsPath"."/FileStore/Table/bad_records_directory")\
.option('skipRows',1).mode('permissive').load(file_path)
```