- AWS OpenSearch Service (formerly known as Amazon Elasticsearch Service) is a managed service.
- OpenSearch includes OpenSearch Dashboards (formerly Kibana)
- **Easy Scaling**: You can scale your OpenSearch clusters up or down manually or automatically based on performance metrics, allowing you to adjust resources based on demand.
- **Multi-AZ Deployments**


### Use Cases
- **Log Analytics**
- **Full-Text Search**: Powers search capabilities across large datasets with advanced search features

### Physical Components:

### 1. **Indices**
An **index** in Elasticsearch or OpenSearch is similar to a database in the world of relational databases. It is the highest-level entity you work with when storing and retrieving data. An index is a collection of documents that are somewhat related to each other. For instance, you might have an index for customer data and another for product data.

#### **Key Features of Indices:**
- **Storage and Retrieval**: Indices store and organize data to facilitate fast and efficient retrieval of information.
- **Sharding**: Indices are divided into shards, which are distributed across different nodes in a cluster. This enhances the performance and scalability of the system.
- **Replication**: Each shard can be replicated across nodes to ensure data availability and fault tolerance. This also helps in load balancing of read requests.

### 2. **Documents**
A **document** is the basic unit of information that can be indexed in Elasticsearch or OpenSearch. Each document is a JSON object consisting of keys (field names) and values, which can be text, numbers, arrays, or even another JSON object.

#### **Key Features of Documents:**
- **Uniquely Identifiable**: Each document is identified by a unique ID within an index.
- **Schema-less**: Documents can be added to an index without predefining a schema. OpenSearch automatically detects the data structure.
- **Indexable**: All fields in a document are indexed by default, making them searchable.

### 3. **Types**
**Types** used to be a way to logically categorize different kinds of documents within an index, somewhat akin to tables in a relational database. However, as of Elasticsearch 6.x and in OpenSearch, the concept of types has been deprecated, and you can only have one type per index, which is usually set as `_doc`.

#### **Legacy of Types:**
- **Single-Type Indices**: Modern usage patterns suggest using separate indices for data that needs to be stored in separate types, mainly due to performance optimizations and data management simplifications.
- **Mapping**: Although types are deprecated, the term is still sometimes used to describe the schema (mapping) for the documents in an index.

### 4. **Mappings**
**Mapping** is the process of defining how a document and its fields are stored and indexed. Think of it as a schema definition, similar to a database schema in a relational database.

#### **Key Features of Mappings:**
- **Field Types**: Fields can be defined as types like text, keyword, date, long, double, boolean, etc.
- **Custom Indexing**: It allows customization of how fields are indexed, such as enabling or disabling indexing, defining analyzers for text fields, and more.
- **Dynamic Mapping**: OpenSearch can automatically detect the field type, but you can also explicitly define it to control behavior more granularly.

### 5. **Analyzers**
An **analyzer** in Elasticsearch and OpenSearch processes text data before indexing it. An analyzer is made up of a tokenizer and zero or more filters.

#### **Functionality of Analyzers:**
- **Tokenization**: Breaks text into terms (words) that are then indexed. This is done by the tokenizer.
- **Normalization**: Filters transform terms into a consistent format, like lowering case or removing stop words, which are common words that are usually irrelevant for searches.

### Use Cases:
- **Full-Text Search**: Leveraging analyzers to enhance search capabilities across large volumes of text data.
- **Data Analytics**: Using indices to efficiently aggregate and analyze data in real time.
- **Log Storage**: Indices configured with time-based data, efficiently managing logging data across time intervals.

## Opensearch Serverless

- **Collections**: In this context, a "collection" likely refers to a logical grouping of data similar to an index but without the need for pre-provisioning. 

- **Data Type Specialization**: Collections can be specialized by type—either for generic search use cases or optimized for time series data. 

- **Always Encrypted with KMS Key**: Ensures that all data at rest is encrypted using AWS Key Management Service (KMS), allowing users to manage keys and encryption settings.

### 5. **Encryption at Rest Requirement**

### 6. **OpenSearch Compute Units (OCUs)**
- **Usage-Based Billing**: Capacity and performance are measured in OCUs
- **Flexible Limits**: Users can set maximum limits to control costs and manage performance

### 7. **Indexing and Search Limits**
- **Fixed Minimum Limits**: The service ensures a minimum capacity (specified as 2 OCUs for indexing and 2 for search).
