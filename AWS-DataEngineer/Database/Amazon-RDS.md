- Regional Service
- Supports Multi AZ
- AWS Managed SQL Database
- Supported Engines 
    - Postgres
    - MySQL
    - MariaDB
    - Oracle
    - Microsoft SQL Server
    - Aurora (AWS Proprietary database)
- Backed by Elastic Compute Cloud (EC2)Storage
    • So EC2 Security groups also applied to RDS instances.
    • We don't have access to the underlying instance
    • DB connection is made on port 3306
• Security Groups are used for network security (must allow incoming TCP traffic on port 3306 from specific IPs)
    • EC2 Security Groups
Instance Types:
    • General Purpose
    • Memory Optimized
Deployment Types
    • Single RDS Deployment- Single copy of a data deployed in a single availability zone 
    • Multi AZ Deployment
        • Multi-AZ synchronously replicates the data to the standby instance in different AZ.
        • Each AZ runs on physically different and independent infrastructure and is designed for high reliability.
        • Multi-AZ deployment is for Disaster recovery not for performance enhancement.
Backups
    • Automated Backups(enabled by default) 
        • Daily full backup of the database (during the defined maintenance window)
        • Default automated backup retention is of 1 day while you can change this from 0 to 35 days.
        • Backup retention:7 days (max 35 days)
        • Transaction logs are backed-up every 5 minutes(point in time recovery)
            • If you disable these automated backups then the point in time recovery feature will be lost.
        
    • DB Snapshots: 
        • Manually triggered
        • 100 Manual snapshots are allowed in a single region.
        • Backup retention: unlimited

Encryption
    • At rest encryption 
        • KMS AES-256 encryption
        • Encrypted DB => Encrypted Snapshots, Encrypted Replicas and vice versa
    • In flight encryption 
        • SSL certificates
        • Transparent data encryption is a concept for encryption of data at rest for MS SQL Server.
        • Force all connections to your DB instance to use SSL by setting the force_sslparameter to true and reboot the instance after that.
        • To enable encryption in transit, download the AWS-provided root certificates& used them when connecting to DB
    • To encrypt an un-encrypted RDS database: 
        • Create a snapshot of the un-encrypted database
        • Copy the snapshot and enable encryption for the snapshot
        • Restore the database from the encrypted snapshot
        • Migrate applications to the new database, and delete the old database
    • To create an encrypted cross-region read replica from a non-encrypted master: 
        • Encrypt a snapshot from the unencrypted master DB instance
        • Create a new encrypted master DB instance
        • Create an encrypted cross-region Read Replica from the new encrypted master
    • Enhanced Monitoring JSON output from CloudWatch Logs in a monitoring system of your choice. 
        • By default, Enhanced Monitoring metrics are stored in the CloudWatch Logs for 30 days. 
        • To modify the amount of time the metrics are stored in the CloudWatch Logs, change the retention for the RDSOSMetrics log group in the CloudWatch console.
        • Take note that there are certain differences between CloudWatch and Enhanced Monitoring Metrics. CloudWatch gathers metrics about CPU utilization from the hypervisor for a DB instance, and Enhanced Monitoring gathers its metrics from an agent on the instance. As a result, you might find differences between the measurements, because the hypervisor layer performs a small amount of work. 
        • Take note as well that you do not have direct access to the instances/servers of your RDS database instance, unlike with your EC2 instances where you can install a CloudWatch agent or a custom script to get CPU and memory utilization of your instance.
        

Access Management
    • Username and Password can be used to login into the database
    • EC2 instances & Lambdafunctions should access the DB using IAM DB Authentication (AWS Authentication Plugin with IAM) - token based access 
        • EC2 instance or Lambda function has an IAM role which allows is to make an API call to the RDS service to get the auth token which it uses to access the MySQL database.
        • Only works with MySQL and PostgreSQL
        • Auth token is valid for 15 mins
        • Network traffic is encrypted in-flight using SSL
        • An authentication token is a unique string of characters that Amazon RDS generates on request. Authentication tokens are generated using AWS Signature Version 4. Each token has a lifetime of 15 minutes. You don't need to store user credentials in the database, because authentication is managed externally using IAM. You can also still use standard database authentication.
        • Central access management using IAM(instead of doing it for each DB individually)
    • Storing Database Credentials in SSM Parameter Store:
        • The database credentials, such as the username and password, are securely stored in the SSM Parameter Store.
        • SSM Parameter Store provides a centralized and secure way to store sensitive information such as credentials, configuration data, and secrets.
    • Granting Permissions:
        • EC2 instances and Lambda functions must have appropriate permissions to access the SSM Parameter Store and retrieve the database credentials.
        • This is typically achieved by attaching an IAM role to the EC2 instances or Lambda functions with permissions to access the specific SSM parameters containing the database credentials.
    • Retrieving Credentials from SSM Parameter Store
        • When an EC2 instance or Lambda function needs to access the database, it makes a call to the SSM Parameter Store API to retrieve the database credentials.
        • The IAM role associated with the EC2 instance or Lambda function authorizes the access to the SSM Parameter Store, ensuring secure retrieval of the credentials.
        • EC2 & Lambda can also get DB credentials from SSM Parameter Store to authenticate to the DB - credentials based access
    • If you're using Oracle RDS instead of MySQL or PostgreSQL, you won't be able to directly utilize IAM DB Authentication or the AWS Systems Manager Parameter Store for credential retrieval. However, you still have options to manage access securely:
    • IAM Database Authentication (If Supported by Oracle RDS):
        • IAM Database Authentication is not supported for Oracle RDS instances. 
        • This feature is specific to MySQL and PostgreSQL.
    • Secure Credential Management:
        • You can manually manage database credentials for Oracle RDS instances.
        • Store the credentials securely, following best practices. This could involve encryption at rest and in transit.
    

Monitoring
    • CloudWatch Metrics for RDS 
        • Gathers metrics from the hypervisor of the DB instance 
            • CPU Utilization
            • Database Connections
            • Free able Memory
            • Free Storage Space
            • Replication Lag if Multi Deployment type
            • DB Engine Metrics like Query execution.
    • Enhanced Monitoring 
        • Gathers metrics from an agent running on the RDS instance 
            • OS processes
            • RDS child processes
            • Memory used by each process.
        • Enhanced monitoring is available for all DB instance classes except for db.m1.small. 
        • Used to monitor different processes or threads on a DB instance(ex. percentage of the CPU bandwidth and total memory consumed by each database process in your RDS instance).

Auto Scaling
    • Automatically scales the RDS storage within the max limit
    • Condition for automatic storage scaling: 
        • Free storage is less than 10% of allocated storage
        • Low-storage lasts at least 5 minutes
        • 6 hours have passed since last modification

Read Replicas
    • Allows us to scale the read operation (SELECT) on RDS
    • Up to 15 read replicas(within AZ, cross AZ or cross region)
    • Active Active config for read operations.
    • Used to distribute the read traffic basically load balancing.
        • Asynchronous Replication(seconds)
        • Replicas can be promoted to their own DB if the primary instance goes down.
    • Applications must update the connection string to leverage read replicas
    • Network fee for replication 
        • Same region: free
        • Cross region: paid
    • If you no longer need read replicas, you can explicitly delete them using the same mechanisms for deleting a DB instance. If you delete a source DB instance without deleting its read replicas in the same AWS Region, each read replica is promoted to a standalone DB instance. 
    • The read replica operates as a DB instance that allows only read-only connections. 
        • An exception is the RDS for Oracle DB engine, which supports replica databases in mounted mode. 
        • A mounted replica doesn't accept user connections and so can't serve a read-only workload. 
        • The primary use for mounted replicas is cross-Region disaster recovery. 
You can create a read replica as a multi-AZ DB instance. A standby of the replica will be created in another AZ for failover support for the replica but this follows the synchronous replication of the data if it is in another AZ.
Use Cases:
    • Upgrading storage configuration – If your source DB instance isn't on the preferred storage configuration, you can create a read replica of the instance and upgrade the storage file system configuration. This option migrates the file system of the read replica to the preferred configuration. You can then promote the read replica to a standalone instance.
You can use this option to overcome the scaling limitations on storage and file size for older 32-bit file systems. For more information, see Upgrading the storage file system for a DB instance.
This option is only available if your source DB instance is not on the latest storage configuration, or if you're modifying the DB instance class within the same request.
    • Sharding – Sharding embodies the "share-nothing" architecture and essentially involves breaking a large database into several smaller databases. One common way to split a database is splitting tables that are not joined in the same query onto different hosts. Another method is duplicating a table across multiple hosts and then using a hashing algorithm to determine which host receives a given update. You can create read replicas corresponding to each of your shards (smaller databases) and promote them when you decide to convert them into standalone shards. You can then carve out the key space (if you are splitting rows) or distribution of tables for each of the shards depending on your requirements.
    • Performing DDL operations (MySQL and MariaDB only) – DDL operations, such as creating or rebuilding indexes, can take time and impose a significant performance penalty on your DB instance. 
        • You can perform these operations on a MySQL or MariaDB read replica once the read replica is in sync with its primary DB instance. Then you can promote the read replica and direct your applications to use the promoted instance.

Multi AZ Cluster¶
    • Increase availability of the RDS database by replicating it to another AZ
    • We have a read replica in backup region also for backup purposes.
    • Synchronous Replication for standby databases and the read replicas
    • In the case of read replicas the replication is asynchronized.
    • Connection string does not require to be updated(both the databases can be accessed by one DNS name, which allows for automatic DNS failover to standby database)
    • Good option in case CPU Patches needs to be applied on the master we can just change the CNAME record and then it will point to this Replica.
    • When failing over, RDS flips the CNAMErecord for the DB instance to point at the standby, which is in turn promoted to become the new primary. 
        • Cannot be used for scaling as the standby database cannot take read/write operation
    • Failover times are typically 60–120 seconds. 
        • However, large transactions or a lengthy recovery process can increase failover time. When the failover is complete, it can take additional time for the RDS console to reflect the new Availability Zone.
Important Fact
• You can configure a read replica for a DB instance that also has a standby replica configured for high availability in a Multi-AZ deployment. Replication with the standby replica is synchronous. Unlike a read replica, a standby replica can't serve read traffic.
• In the following scenario, clients have read/write access to a primary DB instance in one AZ. The primary instance copies updates asynchronously to a read replica in a second AZ and also copies them synchronously to a standby replica in a third AZ. Clients have read access only to the read replica.


READ REPLICAS:



Blue-Green Deployment
    • In the green environment all the data copied from the prod database.
    • Data is synced between the both environments, once we have verified then we can move the client to the green environment
    • We can test dB changes safely
    • Switching takes less than other a minute
    • The resources should be in the same aws account
    • Setup is expensive.

RDS STORAGE TYPES
    • General Purpose SSD 
        • Cost effective
        • For Dev and SIT
    • Provisioned IOPS SSD 
        • For Production environment
        • Minimum is 100 gb till 16TB
    • Magnetic SSD 
        • Initial Storage option
        • Disk Drives-> Slower

RDS Configurations
    • Parameter Store= Stores the sensitive information of the database
    • Performance Insights= Visual Repo of data load and query performance
        • Used to check how fast the queries are running
    • Enhanced Monitoring- Inbuilt with the CloudWatch config
        • This is used to check the child processes running on the database.
    • Audit and Log Data
    • DB Subnet Groups
    • Supports Encryption

RDS Events
    • RDS events only provide operational events on the DB instance (not the data)
    • To capture data modification events, use native functions or stored procedures to invoke a Lambda

#### RDX PROXY
- When we have multiple connections to the database this can go to exhaustion of resources
- We can go for RDS Proxy for `DB Load balancing for connections`.
- In RDS Proxy, it has a `connection pool` and reuses those connections.
        
Security:
• We should go for IPSEC VPN Connection to AWS on premises datacentre through VPC service
• Using public subnet and tls certificates for replication and backup is good but the most secure is the IPSEC VPN connection.

Backtracking:
Backtrack feature simply "rewinds" the DB cluster to the time you specify. Backtracking is not a replacement for backing up your DB cluster so that you can restore it to a point in time. However, you can easily undo mistakes using the backtrack feature if you mistakenly perform a destructive action, such as a DELETE without a WHERE clause.
