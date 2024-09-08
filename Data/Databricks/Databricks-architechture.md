Databricks is designed in a very flexible manner; it is compatible with multiple cloud vendors such as AWS, Azure, and GCP, and so on==. Underlying operations are highly abstract; customers can focus on their Data Engineering and Data Science-related tasks.==

Databricks operates with two main components:

- Control plane
- Data plane

![Pasted image 20240304093821.png](https://publish-01.obsidian.md/access/2948681fa29a77abab215fc5482133de/Images/Spark%20Course/Pasted%20image%2020240304093821.png)

### Control plane

It has a ==web application that acts as an interface for creating and managing interactive notebooks, cluster management, jobs, and queries for Databricks SQL.==

**Notebooks:** These are web-based interface that contains executable code, powered visualisations, and narrative texts. They are ideally used for ETLs, machine learning, and much more.  
**Cluster management:** Most of the tasks related to provisioning and maintaining of clusters is done by Databricks cluster manager on its own based on user inputs on certain parameters like quantification of worker nodes, specification of memory, and runtime version of spark as well as  auto scaling.  
**Jobs:** These are scheduled or immediate executable tasks to run a notebook on Databricks cluster. 
- These are a non-interactive way to run a notebook containing executable code or visualisations.  
**Queries:** Databricks SQL is a web-based query editor, which can be used to execute SQL queries and also helps in visualising data.

### Data/Compute plane

It resides in the client’s cloud (ideally, it is compatible with AWS, Azure, and GCP).

For most Databricks computation, the compute resources are in your AWS account in what is called the classic compute plane. This refers to the network in your AWS account and its resources. ==Databricks uses the classic compute plane for your notebooks, jobs, and for pro and classic Databricks SQL warehouses.==

#### Simple words

The **control plane** includes the backend services that Databricks manages in your Databricks account. The **compute plane** is where your data is processed.