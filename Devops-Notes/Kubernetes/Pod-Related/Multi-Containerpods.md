
# Shared Resources in Kubernetes

## Network Namespace
- **Description**: Containers within the same pod share the same IP address and port space.
- **Benefit**: Allows containers to communicate with each other using `localhost`.

## Storage Volumes
- **Description**: Containers can share storage volumes.
- **Benefit**: Facilitates data sharing and synchronization between containers.

## Co-location and Co-scheduling
- **Description**: Containers in a pod are co-located on the same physical or virtual machine and are scheduled together.
- **Benefit**: Ensures containers run in the same environment.

# Use Cases for Multi-Container Pods

## Sidecar Pattern
- **Purpose**: Enhance or extend the functionality of the main application container.
- **Examples**: Log watchers, monitoring agents, configuration updaters.

### Example YAML for Sidecar Pattern
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
spec:
  containers:
  - name: main-app
    image: myapp:latest
    ports:
    - containerPort: 8080
  - name: log-watcher
    image: log-watcher:latest
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/app
  volumes:
  - name: shared-logs
    emptyDir: {}
```

## Ambassador Pattern
- **Purpose**: Proxy requests to external services.
- **Examples**: API gateways, request routers.
- **Benefits**: Simplifies the main application by offloading communication logic to the ambassador container.

### Proxy Functionality
- **Description**: The ambassador container acts as an out-of-process proxy that handles network communication between the main application container and external services.
- **Tasks**: Routing, logging, circuit breaking, and security (e.g., TLS termination).

### Decoupling
- **Description**: By using an ambassador container, the main application container is decoupled from the complexities of accessing external services.
- **Benefit**: Allows the main application to focus on its core functionality.

### Unified Interface
- **Description**: The ambassador provides a consistent and unified interface for accessing various external services.
- **Benefit**: Makes it easier to manage dependencies and configurations.

### Use Cases
- **Service Discovery and Load Balancing**: The ambassador can handle dynamic service discovery and load balancing.
- **Security and Authentication**: The ambassador can manage security aspects such as TLS termination, authentication, and authorization, offloading these responsibilities from the main application container.

### Example YAML for Ambassador Pattern
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
spec:
  containers:
  - name: main-app
    image: myapp:latest
    ports:
    - containerPort: 8080
  - name: ambassador
    image: envoyproxy/envoy:latest
    ports:
    - containerPort: 8081
    env:
    - name: SERVICE_HOST
      value: "external-service"
    - name: SERVICE_PORT
      value: "80"
```
