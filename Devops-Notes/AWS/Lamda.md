## AWS Lambda Functions


### Key Features
- **Event-Driven Architecture:** 
- **Automatic Scaling:** 
- **Pay-As-You-Go:** 
- **High Availability:** 

### Disadvantages

1. **Cold Starts**
2. **Limited Control Over Environment**
3. **Computational and Execution Limits**
   - **Timeboxed Execution:** Functions are timeboxed with a maximum timeout of 15 minutes, which can complicate handling of long-running processes.
4. **Concurrency Management**: When multiple instances of the same function run simultaneously, careful management is required.

### Use Cases
- **Data Processing:** Process data from Amazon S3 buckets or DynamoDB tables.
- **Real-Time File Processing:** Resize images or process logs in real-time.
- **Automated Backups:** Trigger automated backups and other maintenance tasks.

## AWS Lambda Functions: Configuration Details

### Memory and Storage
- **Memory Allocation:** AWS Lambda allows you to allocate memory to your functions in 1 MB increments, ranging from 128 MB to 10,240 MB (10 GB).
- **Ephemeral Storage:** Each Lambda function has access to 512 MB of ephemeral storage in the `/tmp` directory, which is used for temporary data storage during execution.
- **Persistent Storage:** For persistent storage, you can integrate Lambda with other AWS services like Amazon S3, Amazon EFS, or Amazon DynamoDB.

### Execution Time
- **Timeout:** The maximum execution time for a Lambda function is configurable up to 15 minutes (900 seconds).

### Key Configuration Parameters
- **Memory Size:** 128 MB to 10,240 MB
- **Ephemeral Storage:** 512 MB in `/tmp`
- **Maximum Execution Time:** 900 seconds (15 minutes)
- **VPC Integration:** Lambda functions can be configured to access resources within a VPC, allowing them to interact with private subnets and security groups.

### Execution Environment
- **Execution Context:** Each function runs in an isolated execution environment, which includes the runtime, memory, and temporary storage.

