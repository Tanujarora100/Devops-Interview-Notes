## Liveness Probes
### Purpose:
- Liveness probes are used to determine if an application running inside a container is still operational. 
- If a liveness probe fails, Kubernetes will restart the container to recover from the faulty state.

### Types of Liveness Probes:
- HTTP GET Probe: Sends an HTTP GET request to a specified endpoint. The container is considered healthy if the response status code is between 200 and 399.
- TCP Socket Probe: Attempts to open a TCP connection to a specified port..
- Command Probe: Executes a command inside the container. The container is considered healthy if the command exits with a status code of 0.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hello-app-liveness-pod
spec:
  containers:
  - name: hello-app-container
    image: gcr.io/google-samples/hello-app:1.0
    ports:
    - containerPort: 8080
    livenessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 15
      periodSeconds: 10
      timeoutSeconds: 1
      failureThreshold: 3
```
### Best Practices:
- Use liveness probes for applications with unpredictable or fluctuating startup times.
- Set appropriate initialDelaySeconds, periodSeconds, and timeoutSeconds values based on the application's behavior.

## Readiness Probes
- Readiness probes are used to determine if a container is ready to start accepting traffic. 
- If a readiness probe fails, Kubernetes will not send traffic to the container until it passes the probe.
### Types of Readiness Probes:
- HTTP GET Probe: Similar to liveness probes, it sends an HTTP GET request to a specified endpoint.
- TCP Socket Probe: Similar to liveness probes, it attempts to open a TCP connection.
- Command Probe: Executes a command inside the container, similar to liveness probes.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  template:
    metadata:
      labels:
        app: my-test-app
    spec:
      containers:
      - name: my-test-app
        image: nginx:1.14.2
        readinessProbe:
          httpGet:
            path: /ready
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 1
          successThreshold: 3
          failureThreshold: 3
```

### Best Practices:
- Use readiness probes to ensure that traffic is only sent to fully initialized and ready containers.
- Monitor probe results to detect issues early and adjust probe parameters as needed.
- Use readiness probes in conjunction with liveness probes to manage both the operational state and readiness of containers.
