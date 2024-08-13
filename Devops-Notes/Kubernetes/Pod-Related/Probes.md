## Liveness Probes
### Purpose:
- Liveness probes are used to determine if an application running inside a container is still operational. 
- If a liveness probe fails, Kubernetes will restart the container to recover from the faulty state.

### Types of Liveness Probes:
- HTTP GET Probe:if the response status code is between 200 and 399.
- TCP Socket Probe: 
- Command Probe: Executes a command inside the container. 
  - The container is considered healthy if the command exits with a status code of 0.

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
- HTTP GET Probe
- TCP Socket Probe
- Command Probe

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
## STARTUP PROBES
Startup probes in Kubernetes are a specific type of probe designed to determine whether an application within a container has started successfully. 

## Purpose of Startup Probes

1. **Initialization Check**: Startup probes verify that the application has started before any liveness or readiness checks are performed. 
- This is important for applications that may take longer to initialize, as it prevents Kubernetes from prematurely killing a container that is still starting up.

2. **Disabling Other Probes**: When a startup probe is configured and succeeds, both liveness and readiness probes are disabled until the startup probe completes. 
- This allows the application to finish its startup process without being interrupted.

3. **Failure Handling**: If the startup probe fails after a specified number of attempts, Kubernetes will consider the container as failed and will take action according to the pod's restart policy. 
- This helps ensure that only healthy applications are allowed to run.

## Configuration

To configure a startup probe in a Kubernetes pod specification, you can define it similarly to liveness and readiness probes. Here’s an example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: example-container
    image: your-image:latest
    startupProbe:
      httpGet:
        path: /healthz
        port: 8080
      initialDelaySeconds: 30
      periodSeconds: 10
      failureThreshold: 5
```

### Key Parameters

- **httpGet**: Specifies the HTTP GET request to check the health of the application.
- **initialDelaySeconds**: The number of seconds to wait after the container starts before performing the first probe.
- **periodSeconds**: How often (in seconds) to perform the probe.
- **failureThreshold**: The number of consecutive failures required to consider the startup probe as failed.
