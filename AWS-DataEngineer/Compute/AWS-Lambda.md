# AWS LAMBDA

### Key Features of AWS Lambda
1. **Event-Driven**: Automatically runs code in response to multiple events, including HTTP requests via Amazon API Gateway, modifications in Amazon S3 buckets, updates to DynamoDB tables, and more.
2. **Scalability**: 
3. **Cost-Efficient**: 
4. **Languages Supported**: Supports multiple programming languages, including Node.js, Python, Ruby, Java, Go, .NET Core, and custom runtimes


### Use Cases
- **Web Applications**: 
- **Data Processing**: 
- **Automation**: backups and updates.

### Execution Models
- **Synchronous**: Directly invoke and expect a response (e.g., via API Gateway).
- **Asynchronous**: Events are placed in a `queue before being processed (e.g., S3 events)`.
- **Poll-based**:

### AWS Lambda Layers
Lambda Layers are a way to manage code and dependencies, making it easier to organize, update, and reuse components.

#### Key Points about Lambda Layers
1. **Reusability**: Share libraries, custom runtimes, and other dependencies between multiple Lambda functions, which helps in keeping your functions lightweight and reduces the duplication of code across functions.
2. **Management**: Each layer is a ZIP archive that contains libraries, a custom runtime, or other dependencies. You can include up to `five layers per function`
3. **Versioning**: Each layer `can be versioned independently; when you update a layer, you can manage which functions use which version`.

### Managing Layers
- **Creating a Layer**: Upload your libraries or dependencies as a ZIP file to Lambda, define the compatible runtimes, and Lambda handles the rest.
- **Using Layers**: Add the layer to your Lambda function configuration.
- **Sharing Layers**: You can share layers with other AWS accounts or make them publicly available, facilitating collaboration and code reuse.

### Key Performance Configurations in AWS Lambda

1. **Memory Allocation**:
   - **Range**: You can allocate memory to your Lambda function from 128 MB to 10,240 MB,
   - **Impact on CPU and Network**: Increasing memory also proportionally increases the CPU and network bandwidth available to the function. For example, a function with more memory has access to more CPU power.

2. **Execution Time**:
   - **Timeout**: The maximum allowable timeout for a Lambda function is 15 minutes (900 seconds). You can set a lower timeout based on expected execution times to avoid excessive running times in case of errors or inefficient processing.
   - **Use Case Consideration**: For longer-running jobs, consider breaking the task into smaller chunks that fit within this limit, or use other AWS services like AWS Step Functions for orchestrating multiple Lambda functions.

3. **Concurrency and Throttling**:
   - **Concurrency Limits**: Concurrency is the number of instances of your function that can run simultaneously. The default soft limit is 1,000 concurrent executions per AWS account per region, which can be increased upon request.
   - **Throttling**: If your function exceeds the concurrency limit, additional invocations are throttled, i.e., they will fail with a throttling error. You can manage this by setting reserved concurrency limits for critical functions to ensure they have sufficient resources.

4. **Cold Starts**:
   - **Definition**: A cold start occurs when Lambda initializes a new instance of a function. This can add additional latency for the first invocation when no warm instances are available.
   - **Factors Affecting Cold Starts**: Cold start times can be influenced by the runtime language, the size of deployment packages, and the memory configuration.
   - **Mitigation**: Keeping functions warm using scheduled events or employing provisioned concurrency can mitigate cold starts.

### AWS Lambda Layers: Performance Implications

1. **Deployment Size**:
   - **Size Limits**: The total unzipped deployment package size (function and layers) must not exceed 250 MB. For direct uploads to the Lambda console, the zipped deployment package size limit is 50 MB.
   - **Layer Usage**: By using layers for common dependencies, you can reduce the size of your deployment package and potentially reduce the initialization time for cold starts.

2. **Versioning and Updates**:
   - **Layer Versioning**: Each layer can be independently versioned. When updating a layer, only the functions using that layer need to be updated, not the entire application.
   - **Best Practice**: Keep your layers up-to-date and prune old versions to maintain efficiency and security.
