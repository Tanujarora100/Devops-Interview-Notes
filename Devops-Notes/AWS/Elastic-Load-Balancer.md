## AWS Elastic Load Balancer and Elastic IP Overview

### **Elastic IP**

An Elastic IP is a static IPv4 address designed for dynamic cloud computing in AWS. It can be associated with any instance or network interface in your VPC.

- **Association**: An Elastic IP can only be associated with one instance or network interface at a time.
- **Limit**: By default, AWS allows up to 5 Elastic IPs per region per account[1][3].
- **Usage**: Elastic IPs are used to mask the failure of an instance by quickly remapping the address to another instance in your account[1][2].

### **Subnets**

- **Public Subnet**: Has a direct route to an internet gateway, allowing instances to communicate directly with the internet.
- **Private Subnet**: Does not have a direct route to the internet and typically uses a NAT gateway for internet access[4][5][6].

### **Kinds of Load Balancers**

AWS provides several types of load balancers to handle different types of traffic and use cases:

#### **Application Load Balancer (ALB)**
- **Components**:
  - **Listeners**: Check for connection requests based on configured protocol/port.
  - **Rules**: Define how to route traffic to target groups.
  - **Target Groups**: Groups of resources to which traffic is directed.
- **Features**:
  - Operates at Layer 7 (HTTP/HTTPS).
  - Supports WebSockets and HTTP/2.
  - IPv6 support.
  - Path-based and host-based routing.
  - Integration with AWS WAF.
  - Sticky sessions (session affinity)[7][8][9].

#### **Network Load Balancer (NLB)**
- **Handles**: TCP and UDP traffic.
- **Features**:
  - High performance and low latency.
  - Operates at Layer 4.
  - Preserves the source IP address of the client.

#### **Gateway Load Balancer (GWLB)**
- **Purpose**: Integrates third-party virtual appliances like firewalls.
- **Features**:
  - Operates at Layer 3 (network layer).
  - Uses the GENEVE protocol on port 6081.
  - Acts as a single entry and exit point for network traffic[7][8][9].

#### **Classic Load Balancer (CLB)**
- **Legacy**: An older type of load balancer that supports both Layer 4 and Layer 7 traffic.

### **Key Concepts and Features**

#### **Connection Draining**
- **Definition**: Allows existing connections to complete while preventing new connections to instances that are deregistering or unhealthy.

#### **Cross-Zone Load Balancing**
- **Definition**: Distributes traffic evenly across all registered targets in all enabled Availability Zones[9].

#### **Sticky Sessions**
- **Definition**: Ensures that a user's session is consistently routed to the same target using cookies to track sessions[9].

#### **Integration with Auto Scaling**
- **Definition**: Automatically adds or removes instances from the load balancer's target group as the Auto Scaling group scales in or out[9].

### **Security Measures**

- **SSL/TLS Termination**: Offloads the SSL/TLS encryption and decryption to the load balancer.
- **Integration with AWS WAF**: Protects web applications from common web exploits.
- **Security Groups and ACLs**: Control inbound and outbound traffic to the load balancer[9].

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
2. **Create an ELB**: Choose the appropriate type of load balancer.
3. **Enable Cross-Zone Load Balancing**: Distributes traffic evenly across all targets.
4. **Set Up Health Checks**: Regularly checks the health of targets.
5. **Integrate with Auto Scaling**: Automatically adjusts the number of instances based on demand.

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
