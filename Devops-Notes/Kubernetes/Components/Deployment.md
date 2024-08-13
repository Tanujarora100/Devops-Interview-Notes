
1. **What is a Kubernetes Deployment?**
   - manages the creation and scaling
   - ensures that the desired state

2. **How do you create a Deployment in Kubernetes?**
   - `kubectl apply -f <file-name>` command. 

3. **What are the typical use cases for Deployments?**
   - Deployments are used for:
     - Rolling out updates to applications.
     - Scaling applications up or down.
     - Rolling back to previous versions

4. **What are the update strategies available for Deployments?**
     - **RollingUpdate**: 
     - **Recreate**: Terminates all old Pods before creating new ones, leading to downtime.

5. **How can you perform a rolling update on a Deployment?**
   -using `kubectl apply -f <updated-file>`. 

6. **How do you roll back a Deployment to a previous version?**
   -  `kubectl rollout undo deployment/<deployment-name>` command. 
   You can also specify a particular revision to roll back to using the `--to-revision=<revision-number>` flag.


7. **What are the differences between a Deployment and a StatefulSet?**
   - **Deployment**: Manages stateless applications
   - **StatefulSet**: Manages stateful applications, ensuring that each Pod has a unique, stable identity and persistent storage.

. **What are some best practices for using Deployments in Kubernetes?**
     - Using readiness and liveness probes to ensure application health.
     - Using resource requests and limits
     - Using namespaces for resource isolation.
     - Storing configuration files in version control

10. **Can you explain the concept of Canary Deployments and how they are implemented in Kubernetes?**
    - **Canary Deployment**: A deployment strategy where a new version of the application is released to a small subset of users before rolling it out to the entire infrastructure. 
    - This allows for testing in a production environment with minimal risk.

### **Stable Deployment**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-stable
  labels:
    app: myapp
    version: stable
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      version: stable
  template:
    metadata:
      labels:
        app: myapp
        version: stable
    spec:
      containers:
      - name: myapp
        image: myapp:stable
        ports:
        - containerPort: 8080
```

### **Canary Deployment**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-canary
  labels:
    app: myapp
    version: canary
spec:
  replicas: 1  
  selector:
    matchLabels:
      app: myapp
      version: canary
  template:
    metadata:
      labels:
        app: myapp
        version: canary
    spec:
      containers:
      - name: myapp
        image: myapp:canary
        ports:
        - containerPort: 8080
```

### **Service**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  selector:
    app: myapp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
```

### **Ingress (Optional)**
#### **Example with NGINX Ingress**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp-ingress
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "10"  
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapp-service
            port:
              number: 80
```

## **maxSurge**

- **Definition**: `maxSurge` specifies the maximum number of Pods that can be created over the desired number of Pods during an update.
- **Usage**: It can be set as an absolute number or a percentage of the desired Pods. For example, if you have a Deployment with 10 replicas and set `maxSurge` to 20%, Kubernetes can create up to 2 additional Pods (10 * 0.20 = 2) during the update process.
- **Purpose**: This allows you to temporarily exceed the desired number of Pods to ensure that new Pods are ready before old ones are terminated, thus minimizing downtime.
- **Example**:
  ```yaml
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2  # or "20%"
  ```

## **maxUnavailable**

- **Definition**: `maxUnavailable` specifies the maximum number of Pods that can be unavailable during the update process.
- **Usage**: Like `maxSurge`, it can be set as an absolute number or a percentage of the desired Pods. For instance, if you have a Deployment with 10 replicas and set `maxUnavailable` to 30%, Kubernetes ensures that at least 7 Pods (10 - 3 = 7) are always available during the update.
- **Purpose**: This parameter ensures that a certain number of Pods remain available to handle requests, maintaining the application's availability during the update.
- **Example**:
  ```yaml
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1  # or "10%"
  ```


### **Example Scenario**

Let's consider a Deployment with 10 replicas, `maxSurge` set to 20%, and `maxUnavailable` set to 30%:
- **Desired Pods**: 10
- **maxSurge**: 2 (20% of 10)
- **maxUnavailable**: 3 (30% of 10)

During the update:
- Kubernetes can create up to 2 additional Pods, making a total of 12 Pods (10 desired + 2 maxSurge).
- At the same time, up to 3 Pods can be unavailable, ensuring that at least 7 Pods (10 - 3) are always available.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-deployment
  labels:
    app: example
spec:
  replicas: 10
  selector:
    matchLabels:
      app: example
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2  # or "20%"
      maxUnavailable: 3  # or "30%"
  template:
    metadata:
      labels:
        app: example
    spec:
      containers:
      - name: example-container
        image: example-image:latest
        ports:
        - containerPort: 8080
```