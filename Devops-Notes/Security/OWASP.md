
1. **What is OWASP?**
   - OWASP stands for Open Web Application Security Project. 
   - non-profit organization

2. **What is the OWASP Top 10?**
   - ten most critical web application security risks, updated periodically.
        - SQL Injection
        - Cryptographic Mining.
        - Vulnerability
        - Server Side Request Forgery
        - Insecure System Design 
        - Security and Logging Failures.

3. **What is an injection attack?**
   - Injection attacks occur when untrusted data is sent to an interpreter as part of a command or query. 
   - The most common type is SQL injection, where malicious SQL statements are executed in the database.

4. **What is broken authentication?**
   - Broken authentication refers to vulnerabilities that allow attackers access to compromise passwords, keys, or session tokens.

5. **What is Cross-Site Scripting (XSS)?**
   - XSS attacks occur when an attacker injects malicious scripts into content from otherwise trusted websites.

6. **Describe the OWASP risk rating system.**
   - The OWASP risk rating system is a methodology for assessing the severity of security vulnerabilities based on factors such as exploitability, detectability, and impact.

7. **What is OWASP ESAPI?**
   - Enterprise Security API (ESAPI) is a free
   - open-source web application
   - easier for developers to build secure applications.

8. **How would you mitigate SQL injection vulnerabilities?**
   - use prepared statements with parameterized queries
   - sanitize user inputs
   - employ ORM frameworks
   - Have stored procedures in place.
## DDoS Attack vs. Brute Force Attack
### **Comparison Table**

| Aspect                | DDoS Attack                                                                 | Brute Force Attack                                                        |
|-----------------------|-----------------------------------------------------------------------------|---------------------------------------------------------------------------|
| **Objective**         | Disrupt service availability                                                | Gain unauthorized access                                                  |
| **Methodology**       | Overwhelm target with traffic from multiple sources                         | Systematically guess passwords/keys using automated tools                 |
| **Impact**            | Service outages, slowdowns, financial and reputational damage               | Unauthorized access, data breaches, system compromise                     |
| **Detection**         | Unusual traffic patterns, spikes in traffic                                 | Repeated failed login attempts, unusual login patterns                    |
| **Prevention**        | Rate limiting, IP blacklisting, DDoS protection services                    | Strong passwords, CAPTCHA, account lockout mechanisms, multi-factor auth  |
