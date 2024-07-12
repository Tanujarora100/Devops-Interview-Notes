## **Amazon Web Application Firewall (AWS WAF)**

- web application firewall
-control bot traffic and block common attack patterns such as SQL injection or cross-site scripting.

### **Key Features**

- **Web Traffic Filtering**: Create rules to filter web requests based on condition 
    - IP addresses, HTTP headers, HTTP body.
- **Bot Control**: Monitor, block
    - rate-limit common and pervasive bot
- **Web ACLs (Access Control Lists)**: 
- **Real-time Visibility**

3. **How does AWS WAF integrate with other AWS services?**
   - Amazon CloudFront, Application Load Balancer (ALB), Amazon API Gateway.

1. **What are Managed Rules in AWS WAF?**
   - Managed Rules are pre-configured rule sets provided by AWS or third-party vendors that offer protection against common web vulnerabilities and threats

2. **Explain the concept of Web ACLs in AWS WAF.**
   - Web ACLs (Web Access Control Lists) are used to group together rules that you can apply to one or more web applications. 

### **Advanced Questions**

1. **How does AWS WAF handle bot traffic?**
   - AWS WAF includes Bot Control, a managed rule group that gives visibility and control over common and pervasive bot traffic. 

2. **Describe the process of creating a custom rule in AWS WAF.**
   - To create a custom rule in AWS WAF, you need to define the conditions (e.g., IP addresses, HTTP headers, URI strings) and the action to take (allow, block, or count).
