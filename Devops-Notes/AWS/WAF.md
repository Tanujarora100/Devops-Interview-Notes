## **Amazon Web Application Firewall (AWS WAF)**

- web application firewall
#### Available Actions
- Count
- Block
- Allow

### **Key Features**

- **Web Traffic Filtering**: Create rules to filter
    - IP addresses
    - HTTP headers
    - HTTP body.
- **Bot Control**: Monitor, block
- **Web ACLs (Access Control Lists)**: 

 **How does AWS WAF integrate with other AWS services?**
   - Amazon CloudFront
   - Application Load Balancer (ALB)
   - Amazon API Gateway.

**What are Managed Rules in AWS WAF?**
   - Managed Rules are pre-configured rule sets provided by AWS or third-party vendors


 **How does AWS WAF handle bot traffic?**
   - It has a managed group of rules for bot control.

 **Describe the process of creating a custom rule in AWS WAF.**
   - you need to define the conditions (e.g., IP addresses, HTTP headers, URI strings)
   - the action to take (allow, block, or count).
