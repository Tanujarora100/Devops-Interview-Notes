
## Common CloudFront Interview Questions


### 1. **What are the benefits of using Amazon CloudFront?**
The benefits include:
- Improved website performance by reducing latency.
- Enhanced security features, such as DDoS protection and SSL/TLS encryption.
- Scalability to handle high traffic loads.

### 2. **What is Geo Restriction in CloudFront?**
Geo restriction allows you to restrict access to your content based on the geographical location of the users.

### 3. **Can CloudFront be used for dynamic content?**
- Yes, CloudFront can be used for both static and dynamic content. 
- It supports caching of **dynamic content** by configuring caching rules based on query strings, cookies, or headers.


### 4. **How does CloudFront handle security and encryption?**
CloudFront offers several security features, including:
- SSL/TLS encryption
- AWS WAF
- Signed URLs and Signed Cookies
- Origin access identity to restrict access to content in S3 buckets.

### 5. **How can you disable caching for CloudFront?**
To disable caching, you can set the following TTL values to 0 seconds:
- Minimum TTL: 0 seconds
- Maximum TTL: 0 seconds
- Default TTL: 0 seconds
This forces CloudFront to forward all requests to the origin server[1].

### 11. **What is Origin Shield in CloudFront?**
- Origin Shield is an additional caching layer that helps increase cache hit ratios and reduce the load on the origin server. 
- When enabled, CloudFront routes all origin fetches through Origin Shield, which collapses multiple requests into a single request to the origin.

### 12. **What are CloudFront Functions?**
- serverless edge compute
- you to run JavaScript code

**Points of Presence (PoPs) in Amazon CloudFront**
- strategically located data centers 

## Key Features of Points of Presence

### 1. **Network Peering**
AWS peers with thousands of Tier 1/2/3 telecom carriers globally, ensuring optimal performance and connectivity. This extensive peering network allows CloudFront to deliver content efficiently and reliably[2].

### 2. **Security and Performance**
CloudFront PoPs are integrated with AWS security services such as AWS Shield for DDoS protection.

### 3. **Content Delivery and Caching**
- **Static Content**: CloudFront caches static content like images, CSS, and JavaScript files at edge locations.
- **Dynamic Content**: CloudFront can also accelerate dynamic content by caching responses based on query strings, cookies, and headers.
- **Streaming**: CloudFront supports both live and on-demand video streaming, leveraging its PoPs.

