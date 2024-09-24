
#### 1. **CloudWatch Metrics**
- **Custom Metrics**: Users can publish their own metrics directly to CloudWatch using the AWS SDK or the CloudWatch API.

#### 2. **CloudWatch Alarms**
- **Use Cases**: For instance, an alarm can automatically stop, start, or terminate an Amazon EC2 instance, or it can notify `you through Amazon SNS` if a particular threshold is breached.


#### 3. **CloudWatch Logs**
- **Purpose**: Logs help you to aggregate, monitor, and store logs. 
- **Features**:
  - **Log Groups**: A log group is a collection of log streams that share the same retention, monitoring, and access control settings. Log groups are created automatically the first time you send log data.
  - **Log Streams**: Within each log group, `log streams are a sequence of log events that share the same source`.



### Advanced CloudWatch Features

#### 6. **CloudWatch Synthetics**
- **Purpose**: Allows you to create canaries to monitor your endpoints and APIs from the outside-in to ensure your application's availability and latency.
- **Details**: Canaries are configurable scripts that run at specified intervals to monitor endpoints, giving insights into uptime and performance.

#### 7. **CloudWatch Anomaly Detection**
- **Functionality**: Uses machine learning algorithms to detect anomalies in your metrics, helping you to spot issues that fall outside of normal patterns.
- **Application**: Useful for monitoring metrics that are periodic or have predictable patterns.


#### Metrics:
- Variables to monitor in CloudWatch
- Dimension is an attribute of a metric (instance id, environment, etc.)
- Up to 30 dimensions per metric
- Segregated by namespaces (which AWS service they monitor)

#### Custom Metrics
- Define and send your own custom metrics to CloudWatch using PutMetricData API
- Metric resolution (Storage Resolution API) - frequency of sending metric data
- Standard: 60 seconds
- High Resolution: 1/5/10/30 seconds (higher cost)
- Accepts metric data points two weeks in the past and two hours in the future
