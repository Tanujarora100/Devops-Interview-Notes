A data lake house is a new, open ==data management architecture that combines the flexibility, cost-efficiency, and scale of [data lakes](https://www.databricks.com/discover/data-lakes/introduction) with the data management and ACID transactions of data warehouses,== enabling business intelligence (BI) and machine learning (ML) on all data.

Databricks Lakehouse Platform ==**offers an architecture that combines the best features of data lakes and data warehouses.**== This combination provides high-quality, reliable data at a low cost, and it's ==**capable of handling both structured and unstructured data.**==

![Pasted image 20240304110401.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240304110401.png)  
Data lakehouse are enabled by a new, open system design: implementing similar data structures and data management features to those in a data warehouse, directly on the kind of low-cost storage used for data lakes.

![Pasted image 20240304110107.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240304110107.png)

## Databricks Lakehouse Platform Architecture Components

### 1. Workspace

The workspace is the heart of the Databricks Lakehouse Platform. It's a collaborative environment where data teams can work together on shared projects. ==In the workspace, you can create notebooks, schedule jobs, manage clusters, and perform other tasks that are central to your data workflows.==

### 2. Runtime

Databricks Runtime is the execution engine that powers the Lakehouse Platform. It's optimised for data workloads, offering high performance for both big data and machine learning tasks. ==**Databricks Runtime is built on top of Apache Spark,**== but it includes many enhancements and optimisations that make it faster and more reliable.

### 3. Cloud Services

Databricks Cloud Services provide the infrastructure that supports the Lakehouse Platform. These services handle things like cluster management, job scheduling, security, and more. They're designed to be robust and scalable, ensuring that you can handle even the largest data workloads with ease.