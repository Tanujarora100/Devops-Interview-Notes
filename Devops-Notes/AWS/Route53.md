
## Types of Routing Policies

### 1. **Simple Routing Policy**
- **Use Case**: For a single resource that performs a given function for your domain, such as a web server.
- **Behavior**: Route 53 returns all values in the record set in a random order.

### 2. **Weighted Routing Policy**
- **Use Case**: To route traffic to multiple resources in proportions that you specify.
- **Behavior**: You assign weights to resource record sets to specify the proportion of traffic to route to each resource.

### 3. **Latency Routing Policy**
- **Use Case**: When you have resources in `multiple AWS Regions` and want to route traffic to the region that provides the best latency.
- **Behavior**: Route 53 routes traffic based on latency measurements between users and AWS data centers. It selects the region that provides the lowest latency for the user.

### 4. **Failover Routing Policy**
- **Use Case**: To configure active-passive failover.
- **Behavior**: Route 53 routes traffic to a primary resource unless it is unhealthy, in which case it routes traffic to a secondary resource.

### 5. **Geolocation Routing Policy**
- **Use Case**: To route traffic based on the geographic location of your users.
- **Behavior**: Route 53 routes traffic to resources based on the user's location (e.g., country, continent).

### 6. **Geoproximity Routing Policy**
- **Use Case**: To route traffic based on the geographic location of your resources and optionally shift traffic from one resource to another.
- **Behavior**: You can specify bias values to route more or less traffic to a given resource based on its proximity to the user.

### 7. **Multivalue Answer Routing Policy**
- **Use Case**: To respond to DNS queries with multiple IP addresses.
- **Behavior**: Route 53 returns up to eight healthy records selected at random. It is not a substitute for a load balancer but can improve availability and load balancing.

### 8. **IP-based Routing Policy**
- **Use Case**: To route traffic based on the IP address of the user.
- **Behavior**: `You can create CIDR blocks that represent the client IP network range` and associate these blocks with specific resources.

## Summary

Amazon Route 53 provides a variety of routing policies to meet different use cases and requirements:

| **Routing Policy**           | **Use Case**                                                                 | **Behavior**                                                                                      |
|------------------------------|------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| Simple Routing               | Single resource                                                              | Returns all values in the record set in random order                                              |
| Weighted Routing             | Multiple resources with specified traffic proportions                        | Routes traffic based on assigned weights                                                          |
| Latency Routing              | Multiple AWS Regions, best latency                                            | Routes traffic to the region with the lowest latency for the user[3]                               |
| Failover Routing             | Active-passive failover                                                      | Routes traffic to primary resource unless it is unhealthy, then routes to secondary resource      |
| Geolocation Routing          | Geographic location of users                                                 | Routes traffic based on user's geographic location                                                |
| Geoproximity Routing         | Geographic location of resources, traffic shifting                           | Routes traffic based on resource proximity and optionally shifts traffic between resources        |
| Multivalue Answer Routing    | Multiple IP addresses                                                        | Returns up to eight healthy records selected at random                                            |
| IP-based Routing             | IP address of the user                                                       | Routes traffic based on client IP network range using CIDR blocks                                  |


---
## PUBLIC AND PRI

### **Public Hosted Zones**

A **public hosted zone** is a container for records that define how you want to route traffic on the internet for a domain (and its subdomains). These records are publicly accessible, meaning they can be queried by anyone on the internet.

#### **Key Characteristics:**

1. **Accessibility**: 
   - Public hosted zones can be queried by any internet user. They provide DNS resolution to public-facing domains and services.

2. **Use Cases**:
   - Hosting a website or application that should be accessible to users on the internet.
   - Email routing for a public domain (e.g., `example.com`).

3. **Example**:
   - A company hosts its website `www.example.com` using a public hosted zone. 
   - The DNS records within this zone will include an A record pointing to the public IP address of the web server hosting the site.

4. **Record Types**:
   - Common DNS records (A, AAAA, CNAME, MX, TXT, etc.) that map domain names to IP addresses or other resources.

5. **Domain Registration**:
   - Typically, public hosted zones are associated with a registered domain name, which can be managed using the same DNS service.

6. **Propagation**:
   - Changes made to public hosted zones are propagated across the internet. This can take some time due to DNS caching mechanisms.

### **Private Hosted Zones**

A **private hosted zone** is a container for DNS records that define how you want to route traffic within one or more Virtual Private Clouds (VPCs). These records are only accessible within the associated VPC(s) and are not publicly available.

#### **Key Characteristics:**

1. **Accessibility**:
   - Private hosted zones are only accessible from within the VPCs they are associated with. 

2. **Use Cases**:
   - Managing DNS records for internal services (e.g., databases, microservices) that should not be accessible from the public internet.
   - Resolving domain names within a private network (intranet).

3. **Example**:
   - A company has an internal service accessible via `internal-service.example.com`. 
   - This service is hosted on an EC2 instance within a VPC, and a private hosted zone is used to route traffic to the internal IP address of that instance.

4. **Record Types**:
   - Similar to public hosted zones, but the records point to private IP addresses within the VPC or other internal resources.

5. **Association**:
   - A private hosted zone must be explicitly associated with one or more VPCs. 
   - Only resources within these VPCs can resolve the DNS records in the private hosted zone.

6. **Security**:
   - Provides an additional layer of security by keeping internal resources and their DNS names isolated from the public internet.

### **Comparison of Private and Public Hosted Zones**

| Feature                  | Public Hosted Zone                           | Private Hosted Zone                        |
|--------------------------|----------------------------------------------|--------------------------------------------|
| **Accessibility**        | Accessible to anyone on the internet         | Accessible only within associated VPCs     |
| **Use Case**             | Public-facing websites, email routing        | Internal services, databases, internal communication |
| **Record Types**         | A, AAAA, CNAME, MX, TXT, etc.                | A, AAAA, CNAME, MX, TXT, etc.              |
| **Domain Registration**  | Typically associated with a registered domain | Not necessarily associated with public domains |
| **Association**          | Global, internet-wide reach                  | Specific to one or more VPCs               |
| **Security**             | Publicly accessible, requires security hardening | Isolated to internal network, inherently secure |

### **Common Scenarios for Using Private and Public Hosted Zones**

- **Hybrid Cloud Architectures**: Companies often use a combination of public and private hosted zones to manage public-facing services (e.g., customer-facing websites) and internal services (e.g., internal APIs, databases).

- **Multi-VPC Environments**: In a setup where multiple VPCs need to communicate with each other, private hosted zones can be associated with multiple VPCs to provide internal DNS resolution across VPC boundaries.

- **Security and Compliance**: Using private hosted zones helps in adhering to security and compliance requirements by restricting the exposure of internal services and infrastructure to the public internet.

### **Setting Up in AWS Route 53**

1. **Public Hosted Zone**:
   - In the AWS Route 53 console, create a public hosted zone and associate it with a registered domain.
   - Add DNS records that point to public-facing resources (e.g., an A record pointing to an EC2 instance's public IP).

2. **Private Hosted Zone**:
   - In the AWS Route 53 console, create a private hosted zone, and specify the domain name.
   - Associate the private hosted zone with one or more VPCs.
   - Add DNS records that point to private IP addresses of resources within the VPC.

## AUTHORITATIVE SERVER
An **authoritative server** is a crucial component of the Domain Name System (DNS) infrastructure. 
- It is responsible for providing definitive and reliable answers to DNS queries about a specific domain. When someone requests information about a domain name (e.g., `example.com`), the authoritative server is the one that knows the actual IP addresses and other DNS records associated with that domain. 

### **What is an Authoritative Server?**

1. **Definition:**
   - An authoritative server is a DNS server that holds the `original source of data for a domain's DNS records`. 
   - It is "authoritative" because it has the final say on the DNS records for the domains it manages. When queried, it provides definitive answers rather than referring to another source.

2. **Role in DNS:**
   - It stores DNS records (like A, AAAA, MX, TXT, CNAME, etc.) and responds to DNS queries with this information. 
   - The responses from an authoritative server are considered definitive and trusted because the server has `direct access to the domain's DNS records`.

3. **Zones and Records:**
   - A domain's DNS configuration is divided into zones. 
   - An authoritative server is responsible for serving these zones. Each zone contains the DNS records relevant to a particular domain or set of domains.

### **Types of DNS Servers in the Context of Authoritative Servers**

1. **Authoritative DNS Server:**
   - Contains the DNS records for domains (e.g., `example.com`).
   - Provides responses with authority. If you query for `www.example.com`, the authoritative server for `example.com` will give you the IP address of the web server for that domain.
   - Authoritative servers can be primary (master) or secondary (slave):
     - **Primary (Master) Server**: This is the main authoritative server where the original copies of the zone records are maintained. Any changes to DNS records are made here.
     - **Secondary (Slave) Server**: It obtains zone data from the primary server `through a process called zone transfer.` It serves as a backup and provides redundancy.

2. **Recursive DNS Server (Resolver):**
   - Does not `store authoritative data. Instead, it queries other DNS servers` to find the answer to a client's query.
   - It `caches results to improve response times` for subsequent queries.
   - When you type a domain name into your browser, your computer queries a recursive resolver, which then queries `authoritative servers` to find the final answer.

3. **Root DNS Server:**
   - A special type of authoritative server that holds information about the top-level domains (TLDs) (e.g., `.com`, `.net`, `.org`).
   - It directs `queries to the appropriate TLD authoritative servers`, which then further direct queries to authoritative servers for specific domains.

4. **TLD DNS Server:**
   - Authoritative for top-level domains. 
   - For example, for the domain `example.com`, the TLD server for `.com` knows where to find the authoritative server for `example.com`.

### **How Authoritative Servers Work**

1. **Storing DNS Records**: 
   - An authoritative server stores DNS records for one or more domains. These records include:
     - **A (Address) Record**: Maps a domain name to an IPv4 address.
     - **AAAA Record**: Maps a domain name to an IPv6 address.
     - **MX (Mail Exchange) Record**: Specifies the mail server responsible for receiving email on behalf of the domain.
     - **CNAME (Canonical Name) Record**: Creates an alias for a domain name.
     - **TXT Record**: Holds arbitrary text, often used for verification and security (e.g., SPF, DKIM).
     - **NS (Name Server) Record**: Specifies the authoritative name servers for the domain.

2. **Answering Queries**:
   - When a recursive resolver or a client directly queries an authoritative server for a domain, the authoritative server checks its stored DNS records and provides the corresponding response. `This response is authoritative, meaning it's from the primary source and not from a cached result`.

3. **Zone Transfers**:
   - Authoritative servers use zone transfers to synchronize DNS records between primary and secondary servers. This ensures that secondary servers have up-to-date records and can provide authoritative responses even if the primary server is unavailable.

4. **DNSSEC**:
   - Authoritative servers can also implement DNS Security Extensions (DNSSEC) to provide a layer of security. DNSSEC helps verify that the responses from authoritative servers have not been tampered with.

### **Importance of Authoritative Servers**

- **Accuracy**: Authoritative servers provide the most accurate and up-to-date information for a domain's DNS records, ensuring reliable and consistent responses.
- **Security**: By controlling the authoritative servers, domain owners can secure their DNS data, implement DNSSEC, and prevent unauthorized modifications.
- **Redundancy and Reliability**: Having both primary and secondary authoritative servers ensures high availability and fault tolerance. If one server fails, the other can continue providing DNS services.

### **Example Workflow: How a DNS Query Reaches an Authoritative Server**

1. **User Request**: A user wants to visit `www.example.com`. They enter this URL into their web browser.
2. **Local Resolver**: The browser asks the local resolver (ISP or configured DNS resolver) for the IP address of `www.example.com`.
3. **Recursive Querying**: If the local resolver doesn't have the answer cached, it starts a recursive query:
   - It queries a root DNS server to find the TLD server for `.com`.
   - The root server responds with the address of the `.com` TLD server.
   - The resolver queries the `.com` TLD server for `example.com`.
   - The TLD server responds with the address of the authoritative server for `example.com`.
4. **Authoritative Response**: The resolver queries the authoritative server for `example.com`, asking for the IP address of `www.example.com`.
5. **Final Answer**: The authoritative server responds with the IP address, which the resolver caches and returns to the user's browser.
6. **Accessing the Website**: The browser uses the IP address to access the website.

## CURL FLOW

1. **DNS Resolution**:
   - **Purpose**: The first step is to translate the human-readable domain name (`example.com`) into an IP address that computers can use to establish a connection.
   - **Process**:
     1. `curl` checks the local DNS cache or `/etc/hosts` file to see if the IP address for `example.com` is already known.
     2. If the IP address is not cached, `curl` sends a DNS query to a configured DNS resolver (often your ISP’s DNS server or a public DNS service like Google’s `8.8.8.8`).
     3. The DNS resolver performs recursive lookups:
        - It queries a root DNS server to find out which TLD (Top-Level Domain) server is responsible for `.com`.
        - It then queries the `.com` TLD server to find out which authoritative DNS server is responsible for `example.com`.
        - Finally, it queries the authoritative server to get the IP address of `example.com`.
     4. The resolver returns the IP address of `example.com` to `curl`.

2. **Establishing a TCP Connection**:
   - **Purpose**: Once `curl` knows the IP address, it needs to establish a network connection to that IP address to communicate with the server.
   - **Process**:
     1. `curl` uses the TCP to establish a connection. It sends a `SYN (synchronize) packet` to the server's IP address on port 80 (for HTTP) or port 443 (for HTTPS).
     2. The server responds with a SYN-ACK (synchronize-acknowledge) packet, indicating that it is ready to establish a connection.
     3. `curl` sends an ACK (acknowledge) packet back to the server, `completing the TCP three-way handshake`.
     4. At this point, a reliable TCP connection is established between `curl` and the server.

3. **TLS Handshake (if using HTTPS)**:
   - **Purpose**: To secure the communication, `curl` initiates a TLS handshake if the request is using HTTPS.
   - **Process**:
     1. `curl` sends a `ClientHello` message to the server, which includes information about supported encryption methods.
     2. The server responds with a `ServerHello` message, `selecting the encryption method and providing its SSL/TLS certificate`.
     3. `curl` verifies the server's certificate against its list of trusted Certificate Authorities (CAs). 
     - If the certificate is valid, it proceeds; otherwise, it may display a warning or terminate the connection.
     4. `curl` and the server exchange keys to establish a secure encrypted connection using `symmetric encryption`.

4. **HTTP Request**:
   - **Purpose**: To request the content from the server.
   - **Process**:
     1. `curl` sends an HTTP request to the server. This request typically includes:
        - A request line: `GET / HTTP/1.1`, which specifies the method (GET), the path (`/`), and the HTTP version (1.1).
        - Headers: Additional information like `Host: example.com`, `User-Agent: curl/7.68.0`, `Accept: */*`, etc.
     2. The request might also include other HTTP methods such as `POST`, `PUT`, `DELETE`, etc., and a body if required.

5. **Server Processing**:
   - **Purpose**: The server processes the request and prepares a response.
   - **Process**:
     1. The server’s web server software (e.g., Apache, Nginx) receives the request.
     2. It processes the request, which might involve fetching files, querying a database, or executing server-side scripts.
     3. It prepares an HTTP response that includes a status code, headers, and the requested content (e.g., HTML page, JSON data).

6. **HTTP Response**:
   - **Purpose**: To send the requested content back to `curl`.
   - **Process**:
     1. The server sends back an HTTP response message. This message typically includes:
        - Status line: E.g., `HTTP/1.1 200 OK`, which indicates the status of the response.
        - Headers: Metadata about the response, such as `Content-Type`, `Content-Length`, `Date`, etc.
        - Body: The actual content requested, such as an HTML document, image, or JSON data.
     2. If the response is compressed (e.g., `gzip`), `curl` will decompress it to display the original content.

7. **Display Content**:
   - **Purpose**: `curl` displays the response content to the user.
   - **Process**:
     1. `curl` reads the response and prints it to the standard output (terminal). It can also be configured to save the output to a file using the `-o` or `-O` options.

8. **Connection Termination**:
   - **Purpose**: To close the TCP connection and free up resources.
   - **Process**:
     1. Once the content is retrieved and displayed, `curl` sends a `FIN` (finish) packet to the server to indicate that it wants to terminate the connection.
     2. The server responds with a `FIN-ACK` packet, and then `curl` sends a final ACK packet, completing the connection teardown.
   - In the case of persistent connections (HTTP keep-alive), the connection may be kept open for future requests.


