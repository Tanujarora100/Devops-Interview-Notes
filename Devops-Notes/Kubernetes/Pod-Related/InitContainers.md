### INIT CONTAINERS
- Runs before the main containers and perform initialization
- Sends a Zero signal to signify success.
- They are sequential in nature, if the previous container does not send a zero signal then the next container will not run.
- App do not start unless all are completed
- Contains Utilities or setup scripts
- Isolated and have own environment and file system
- If an init container fails, the pod’s restart policy determines the next steps. 
- For `Always or OnFailure policies`, the pod will restart from the first init container.
- The pod status will show Init:Error or Init:CrashLoopBackOff if there are repeated failures.
``` yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', "until nslookup myservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for myservice; sleep 2; done"]
  - name: init-mydb
    image: busybox:1.28
    command: ['sh', '-c', "until nslookup mydb.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for mydb; sleep 2; done"]

```
### CONS OF INIT CONTAINERS
- Resource Allocation and Scheduling
    - Since scheduling is based on the effective requests/limits, init containers can affect the scheduling of the pod. 
- Pods with high resource requests for init containers might wait longer to be scheduled if the cluster is resource-constrained.
- Initialization Time
- Handling Failures: If an init container fails, the pod will restart according to its restart policy, which can lead to repeated initialization attempts
- `There are no liveness probes or readiness probes in init containers`.
## Real-Time Use Cases of Init Containers in Kubernetes

### 2. **Configuration and Secret Management**

**Example**:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
spec:
  initContainers:
  - name: fetch-secrets
    image: busybox
    command: ['sh', '-c', 'fetch-secrets-script.sh']
  containers:
  - name: myapp-container
    image: busybox
    command: ['sh', '-c', 'use-secrets-script.sh']
```

### 3. **Database Migrations**

### 4. **Cache Warm-Up**
Init containers can preload data into a cache to improve the performance of the main application.
### 5. **Network Configuration**


### 6. **Security Checks**
