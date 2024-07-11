## AWS Elastic Load Balancer and Elastic IP Overview

### **Elastic IP**
- static ip 
- Only one network interface
- IP4 Address 
- 5 Elastic IP per region 


### **Subnets**

- **Public Subnet**: attached internete gateway
- **Private Subnet**: uses NAT Gateway in public subnet

### **Kinds of Load Balancers**


#### **Application Load Balancer (ALB)**
- **Components**:
  - **Listeners**: Check for connection requests based on configured protocol/port.
  - **Rules**: 
  - **Target Groups**: 
- **Features**:
  - Layer 7 (HTTP/HTTPS).
  - Supports **WebSockets and HTTP/2**.
  - `IPv6` support.
  - Path-based and host-based routing.
  - Integration with AWS WAF.
  - `Sticky sessions`.

#### **Network Load Balancer (NLB)**
- **Handles**: TCP and UDP traffic.
- **Features**:
  - sub milli second latency
  - whitelist ip using this
  - Layer 4.
  - Preserves the source IP address of the client.

#### **Gateway Load Balancer (GWLB)**
- **Purpose**: third-party virtual appliances like firewalls.
- **Features**:
  - Layer 3 (network layer).
  - Uses the `GENEVE protocol` on port 6081.
  - Acts as a `single entry and exit point`.

#### **Classic Load Balancer (CLB)**
- **Legacy**: An older type of load balancer that supports both Layer 4 and Layer 7 traffic.
- No web socket support and http2 support
- waf is not compatible with this.

### **Key Concepts and Features**

#### **Connection Draining**
- Allows existing connections to quit gracefully 
- while preventing new connections to instances that are deregistering.

#### **Cross-Zone Load Balancing**
- **Definition**: Distributes traffic evenly across all registered targets in all enabled AZ.

#### **Sticky Sessions**
- same target using cookies to track sessions.
- special cookie (AWSALB) to track the instance. 
- load balancer checks for this cookie. 
- If present, the request is routed to the specified instance. If absent, the load balancer selects an instance based on the load balancing algorithm.

#### **Integration with Auto Scaling**
- **Definition**: Automatically adds or removes instances from the load balancer's target group as the Auto Scaling group scales in or out.

### **Security Measures**

- **SSL/TLS Termination**: Offloads the SSL/TLS encryption and decryption to the load balancer.
- **Integration with AWS WAF**: 
- **Security Groups and ACLs**:

### **Challenges and Optimization Strategies**

#### **Challenges**
- Configuring health checks correctly.
- Managing security settings.
- Handling sudden traffic spikes.

#### **Optimization Strategies**
- Using the appropriate type of load balancer for your needs.
- Monitoring usage and scaling down when necessary.
- Considering Reserved Instances for cost savings.

### **Setting Up a Highly Available Architecture Using ELB**

1. **Deploy Application Across Multiple Availability Zones**: Ensures high availability and fault tolerance.
2. **Create an ELB**: 
3. **Enable Cross-Zone Load Balancing**:
4. **Set Up Health Checks**: 
5. **Integrate with Auto Scaling**: 

### **Algorithms for Load Balancers**

| Algorithm          | How It Works                                    | Benefits                                  | Drawbacks                              | Use Cases                                   |
|--------------------|-------------------------------------------------|-------------------------------------------|----------------------------------------|---------------------------------------------|
| **Round Robin**    | Cyclically distributes requests to servers      | Simple, even distribution if servers are similar | Assumes identical server capacity      | Environments with similar server performance|
| **Least Connections** | Directs requests to the server with the fewest active connections | Prevents server overload, dynamic adaptation | Ignores server capacity, more complex | Varying server loads and capacities         |
| **IP Hash**        | Uses client's IP address to determine server assignment | Provides session persistence              | Can lead to uneven load distribution   | Applications requiring consistent server assignment |

### **Path-Based and Host-Based Routing**

- **Path-Based Routing**: Routes requests based on the URL path.
  - **Listener Rules**: Define path patterns to match.
  - **Target Groups**: Each path pattern is associated with a specific target group.
  - **Use Case**: Hosting multiple microservices behind a single ALB.

- **Host-Based Routing**: Routes requests based on the host header in the HTTP request.
  - **Listener Rules**: Define host conditions.
  - **Target Groups**: Each host condition is associated with a specific target group.
  - **Use Case**: Hosting multiple applications or services on different subdomains.

### **Availability Zones**

- **Definition**: Distinct locations within an AWS region engineered to be isolated from failures in other Availability Zones.
- **Typical Count**: 3 to 6 AZs per region.
## **Application Load Balancer (ALB) vs. Network Load Balancer (NLB) Security Comparison**

### **Security Features**

**Application Load Balancer (ALB)**
  - **SSL Termination**: ALB can terminate SSL/TLS connections, This can simplify certificate management and reduce the computational load on backend instances.
  - **Web Application Firewall (WAF)**: 
  - **Authentication**: ALB supports user authentication using Amazon Cognito.
  - **Advanced Routing**: Using host and path based routing.

**Network Load Balancer (NLB)**
- **Security Features**:
  - **TLS Termination**: NLB can also terminate TLS connections
  - **Static IP**: NLB provides a static IP address for the load balancer, which can simplify firewall configurations.
  - **DDoS Protection**: NLB is integrated with AWS Shield
  - **Flow Hash Algorithm**: NLB uses a flow hash algorithm to distribute traffic, which can help in maintaining session persistence and ensuring secure and consistent routing of traffic.

### **Comparison Table**

| Feature                     | ALB (Application Load Balancer) | NLB (Network Load Balancer) |
|-----------------------------|----------------------------------|-----------------------------|
| **OSI Layer**               | Layer 7 (Application)            | Layer 4 (Transport)         |
| **Protocols Supported**     | HTTP, HTTPS, gRPC                | TCP, UDP, TLS               |
| **SSL/TLS Termination**     | Yes                              | Yes                         |
| **Web Application Firewall**| Yes (AWS WAF integration)        | No                          |
| **User Authentication**     | Yes (Amazon Cognito, OIDC)       | No                          |
| **Static IP**               | No                               | Yes                         |
| **DDoS Protection**         | Yes (AWS Shield)                 | Yes (AWS Shield)            |
| **Routing**                 | Content-based routing            | Flow hash algorithm         |



### **Health Check Configuration**

- **Health Check Path**: The URL path that the ALB uses to perform health checks on the targets. For example, `/health` or `/status`.
- **Health Check Interval**:
- **Timeout**: The amount of time to wait for a response before marking the health check as failed.
- **Healthy Threshold**: 
- **Unhealthy Threshold**:

### **Example Configuration**

```hcl
resource "aws_lb_target_group" "example" {
  name     = "example-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}
```


### **Checking Health Status**

You can check the health status of your targets using the AWS Management Console, AWS CLI, or AWS SDKs. For example, using the AWS CLI:

```sh
aws elbv2 describe-target-health --target-group-arn <target-group-arn>
```



- **ALB** is ideal for web applications that require advanced routing, user authentication, and integration with AWS WAF. It terminates SSL/TLS at the application layer, providing features like content-based routing and the `X-Forwarded-Proto` header.

## **Key Metrics to Monitor**

### **Application Load Balancer (ALB) Metrics**
1. **Request Count**: Number of requests handled by the load balancer.
2. **Target Response Time**: Time taken for targets to respond to requests.
3. **HTTP 4xx and 5xx Errors**: Count of client and server errors.
4. **HealthyHostCount**: Number of healthy targets.
5. **UnHealthyHostCount**: Number of unhealthy targets.
6. **Request Count per Target**: Number of requests received by each target.
7. **Target Connection Errors**: Number of connection errors to targets.

### **Network Load Balancer (NLB) Metrics**
1. **Active Flow Count**: Number of active flows.
2. **New Flow Count**: Number of new flows.
3. **Processed Bytes**: Number of bytes processed by the load balancer.
4. **HealthyHostCount**: Number of healthy targets.
5. **UnHealthyHostCount**: Number of unhealthy targets.
6. **TLS Negotiation Error Count**: Number of TLS negotiation errors.

## **Setting Up CloudWatch Monitoring**

### **Viewing Metrics**
1. **Using the AWS Management Console**:
   - Open the **Amazon EC2 console**.
   - Navigate to **Load Balancers** or **Target Groups**.
   - Select your load balancer or target group and go to the **Monitoring** tab to view metrics.

2. **Using the CloudWatch Console**:
   - Open the **CloudWatch console**.
   - Navigate to **Metrics**.
   - Select the **ApplicationELB** or **NetworkELB** namespace.
   - Filter metrics by load balancer, target group, or availability zone as needed.

### **Creating Alarms**
1. **Using the AWS Management Console**:
   - Open the **CloudWatch console**.
   - Navigate to **Alarms** and choose **Create Alarm**.
   - Select the relevant ELB metric (e.g., Latency, UnHealthyHostCount).
   - Configure the alarm threshold, evaluation period, and actions (e.g., sending notifications via SNS).

2. **Using the AWS CLI**:
   - Set up an SNS topic for notifications.
   - Use the `put-metric-alarm` command to create an alarm:
     ```sh
     aws cloudwatch put-metric-alarm --alarm-name "HighLatencyAlarm" \
       --metric-name Latency --namespace AWS/ApplicationELB \
       --statistic Average --period 60 --threshold 0.1 \
       --comparison-operator GreaterThanThreshold \
       --dimensions Name=LoadBalancerName,Value=my-load-balancer \
       --evaluation-periods 3 --alarm-actions arn:aws:sns:region:account-id:my-topic
     ```

## **Analyzing Logs**

### **Access Logs**
- Logs are stored in an Amazon S3 bucket and can be analyzed using tools like Amazon Athena or third-party log management solutions.

### **CloudTrail Logs**
- Logs are stored in an S3 bucket and can be analyzed to audit changes and troubleshoot issues.


## **Using CloudWatch Dashboards**
- Create customizable dashboards in CloudWatch to monitor ELB metrics in a single view.
- Dashboards can include graphs, alarms, and log insights widgets.


### **Types of Load Balancers and Their Logs**

1. **Application Load Balancer (ALB)**
2. **Network Load Balancer (NLB)**
3. **Classic Load Balancer (CLB)**

### **Enabling Access Logs**

#### **Step-by-Step Guide**

1. **Create an S3 Bucket**
2. **Set Bucket Policy**
   - Grant Elastic Load Balancing permission to write to the bucket.
   - Example bucket policy:
     ```json
     {
       "Version": "2012-10-17",
       "Statement": [
         {
           "Effect": "Allow",
           "Principal": {
             "Service": "elasticloadbalancing.amazonaws.com"
           },
           "Action": "s3:PutObject",
           "Resource": "arn:aws:s3:::your-bucket-name/AWSLogs/your-aws-account-id/*"
         }
       ]
     }
     ```

3. **Enable Access Logs for ALB**

4. **Enable Access Logs for NLB**

5. **Enable Access Logs for CLB**

## TROUBLESHOOTING LOAD BALANCER IS DOWN


### **Impact of ALB Downtime**

1. **Service Interruption**:
   - When the ALB is down, it cannot route incoming traffic to the backend instances, leading to a service interruption.

## **AWS Mitigations and Best Practices**

### **High Availability Configuration**

1. **Multi-AZ Deployment**:
2. **Automatic Replacement**:
   - If an individual ALB instance fails, AWS automatically replaces it.

### **DNS and Health Checks**

1. **DNS Failover**:
   - The ALB uses DNS to distribute traffic across multiple instances. 
    - If an instance fails, the DNS is updated to route traffic to healthy instances. 
       - The DNS (TTL) is set to a low value (typically 60 seconds).

2. **Route 53 Health Checks**:
   - Amazon Route 53 health checks and DNS failover features. Route 53 can detect if the ALB is unhealthy and reroute traffic to a healthy endpoint.

### **Troubleshooting and Recovery**

1. **Troubleshooting Tools**:
2. **Monitoring and Alerts**:
   -This includes monitoring metrics like `HealthyHostCount` and `UnHealthyHostCount`.

### **Best Practices**
1. **Use Multiple ALBs**:
2. **Pre-Warming**:
3. **Regular Testing**:
### METRICS IN ALB:

- `RequestCount`
- `ProcessedBytes`
- `HealthyHostCount`
- `UnHealthyHostCount`
- `TargetResponseTime`