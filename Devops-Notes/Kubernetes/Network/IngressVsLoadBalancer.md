## Why Ingress Controllers are Preferred Over Load Balancer Services
### **Key Advantages of Ingress Controllers**

1. **Routing Flexibility**
   - **Host and Path-Based Routing**: Ingress Controllers can route traffic based on the host (domain name) and the path of the request. 
   - This allows multiple services to be accessed through a single IP address, making it possible to direct traffic to different services based on URL patterns.
   - **Layer 7 Routing**: Ingress operates at the application layer (Layer 7)

2. **Cost Efficiency**
   - **Single Load Balancer for Multiple Services**: An Ingress Controller requires only one external load balancer to manage traffic for multiple services. This significantly reduces the cost compared to using a separate Load Balancer

3. **Advanced Traffic Management**
   - **SSL/TLS Termination**: Ingress Controllers can handle SSL/TLS termination, offloading the encryption and decryption workload from the backend services..

4. **Enhanced Features**
   - **Name-Based Virtual Hosting**: Ingress can route traffic to different services based on the host header, allowing multiple domains to be served from the same IP address.
   - **Additional Capabilities**: Many Ingress Controllers support features like rate limiting, web application firewall (WAF) integration, and canary deployments.

### **Limitations of Load Balancer Services**

1. **Single Service Routing**
   - **One Load Balancer per Service**: Load Balancer services in Kubernetes are designed to expose a single service to the internet. Each service requires its own load balancer

2. **Layer 4 Limitations**
   - **Limited to Layer 4**: Load Balancer services operate at the transport layer (Layer 4), meaning they can only route traffic based on IP addresses and ports.
   - They lack the advanced routing capabilities provided by Ingress Controllers at Layer



