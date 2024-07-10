
## Common Kubernetes Errors and How to Troubleshoot Them

### 1. **CrashLoopBackOff**

#### Description
The `CrashLoopBackOff` error indicates that a Pod is repeatedly crashing after starting.

```bash
kubectl describe pod <pod-name>
```
#### Common Causes and Resolutions
- **Lack of Resources**: The node may lack the necessary resources (CPU, memory) to run the Pod.
  - **Solution**: Scale up the cluster or allocate more resources to the Pod.
- **Application Errors**: The application inside the container might be crashing due to bugs or misconfigurations.
  - **Solution**: Check the application logs using `kubectl logs <pod-name>` and fix any issues.
- **Volume Mounting Errors**: Problems with mounting storage volumes.
  - **Solution**: Verify the volume configuration

### 2. **ImagePullBackOff**

#### Common Causes and Resolutions
- **Incorrect Image Name or Tag**: The specified image name or tag might be incorrect.
  - **Solution**: Verify the image name and tag in the Pod specification.
- **Registry Authentication Issues**: Kubernetes might not have the correct credentials .
- **Network Issues**: Network problems might be preventing access to the registry.
  - **Solution**: Check network connectivity and DNS resolution.

### 3. **CreateContainerConfigError**

#### Description
The `CreateContainerConfigError` indicates an issue with the container configuration, preventing it from being created.

#### Identifying the Error
Use the following command to identify the error:
```bash
kubectl get pods
```
The affected Pod will show a `CreateContainerConfigError` status. To get more details:
```bash
kubectl describe pod <pod-name>
```

#### Common Causes and Resolutions
- **Invalid Environment Variables**: Incorrectly specified environment variables.
  - **Solution**: Verify the environment variables in the Pod specification.
- **Missing ConfigMaps or Secrets**: Referenced ConfigMaps or Secrets might be missing.
  - **Solution**: Ensure that the referenced ConfigMaps or Secrets exist.

### 4. **Kubernetes Node Not Ready**

#### Description
A node in the cluster is not ready to schedule Pods.

#### Identifying the Error
Use the following command to identify the error:
```bash
kubectl get nodes
```
The affected node will show a `NotReady` status. To get more details:
```bash
kubectl describe node <node-name>
```

#### Common Causes and Resolutions
- **Kubelet Issues**: The kubelet might be down or misconfigured.
  - **Solution**: Check the kubelet logs on the node for errors.
- **Resource Pressure**: The node might be under disk or memory pressure.
  - **Solution**: Free up resources or add more capacity to the node.
- **Network Issues**: Network connectivity problems might be affecting the node.
  - **Solution**: Check network connectivity and ensure the node can communicate with the control plane.

## General Troubleshooting Strategies

### 1. **Gather Information**
- Use `kubectl describe` to get detailed information about resources.
- Use `kubectl logs` to view logs from Pods and containers.
- Check node logs, especially kubelet logs, for node-related issues.

### 2. **Monitor and Observe**
- Use monitoring tools like Prometheus, Grafana, Datadog, or New Relic to monitor cluster health and performance.
- Use observability tools like Lightstep or Honeycomb to trace and debug issues.

### 3. **Analyze and Compare**
- Compare the behavior of similar components to identify anomalies.
- Review recent changes to configurations, deployments, or the cluster itself.

### 4. **Use Automated Tools**
- Employ live debugging tools like Rookout or OzCode to debug running applications.
- Utilize logging tools like Splunk, LogDNA, or Logz.io to aggregate and analyze logs.

### 5. **Prevent Recurrence**
- Implement best practices for resource allocation and management.
- Regularly update and patch Kubernetes components and applications.
- Use health checks and readiness probes to ensure application stability.

By following these strategies and understanding common errors, you can effectively troubleshoot and resolve issues in your Kubernetes cluster, ensuring a stable and high-performing environment.

## Scenario-Based Kubernetes Troubleshooting

### Scenario 1: Pods Cannot Resolve DNS Names

#### Problem
Pods in your Kubernetes cluster are unable to resolve DNS names, leading to failures in service discovery and communication between Pods and Services.

#### Steps to Troubleshoot

1. **Check Pod Network Configuration**:
   - Ensure that the Pod network is correctly configured and functioning. DNS resolution relies on network connectivity between Pods and DNS services.
   - Verify that the network policies are not blocking DNS traffic.

   ```bash
   kubectl get pods --all-namespaces -o wide
   ```

2. **Verify DNS Service Health**:
   - Confirm that the DNS service (CoreDNS or kube-dns) is running and healthy within the Kubernetes cluster.
   - Check for any errors or warnings in the DNS service logs.

   ```bash
   kubectl get pods -n kube-system -l k8s-app=kube-dns
   kubectl logs -n kube-system <dns-pod-name>
   ```

3. **Check DNS Configurations**:
   - Review DNS configurations, such as ConfigMaps and CoreDNS settings, for any misconfigurations or conflicts.
   - Ensure that DNS policies align with the cluster’s requirements.

   ```bash
   kubectl get configmap coredns -n kube-system -o yaml
   ```

4. **Test DNS Resolution**:
   - Verify that Pods can resolve DNS names both within and outside the cluster. Test DNS resolution from various Pods to ensure consistency and correctness.

   ```bash
   kubectl exec -it <pod-name> -- nslookup <service-name>
   ```

5. **Review Pod DNS Policy**:
   - Check the DNS policy of the affected Pods. By default, Pods inherit the DNS settings from the node. Ensure that the DNS policy is set correctly.

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: example-pod
   spec:
     containers:
     - name: example-container
       image: nginx
     dnsPolicy: ClusterFirst
   ```

### Scenario 2: Service Discovery Fails for a New Service

#### Problem
A newly created Service is not discoverable by other Pods in the cluster, leading to connectivity issues.

#### Steps to Troubleshoot

1. **Check Service and Endpoints**:
   - Ensure that the Service and its associated Endpoints are correctly created and populated.

   ```bash
   kubectl get svc <service-name>
   kubectl get endpoints <service-name>
   ```

2. **Verify Labels and Selectors**:
   - Confirm that the Service's selector matches the labels on the Pods it is supposed to target.

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: my-service
   spec:
     selector:
       app: my-app
     ports:
       - protocol: TCP
         port: 80
         targetPort: 9376
   ```

3. **Check DNS Records**:
   - Verify that the DNS records for the Service are correctly created and resolvable.

   ```bash
   kubectl exec -it <pod-name> -- nslookup <service-name>.<namespace>.svc.cluster.local
   ```

4. **Review CoreDNS Logs**:
   - Check the CoreDNS logs for any errors or issues related to the Service's DNS records.

   ```bash
   kubectl logs -n kube-system -l k8s-app=kube-dns
   ```

### Scenario 3: Node Not Ready

#### Problem
A node in the cluster is showing a `NotReady` status, preventing Pods from being scheduled on it.

#### Steps to Troubleshoot

1. **Check Node Status**:
   - Get detailed information about the node's status to identify the cause of the `NotReady` status.

   ```bash
   kubectl describe node <node-name>
   ```

2. **Review Kubelet Logs**:
   - Check the kubelet logs on the affected node for any errors or warnings.

   ```bash
   journalctl -u kubelet
   ```

3. **Check Resource Pressure**:
   - Ensure that the node is not under disk, memory, or CPU pressure. Free up resources if necessary.

   ```bash
   kubectl top node <node-name>
   ```

4. **Verify Network Connectivity**:
   - Ensure that the node has network connectivity and can communicate with the control plane and other nodes.

   ```bash
   ping <control-plane-ip>
   ```

5. **Inspect Node Conditions**:
   - Review the node conditions to identify specific issues such as `DiskPressure`, `MemoryPressure`, or `NetworkUnavailable`.

   ```bash
   kubectl get nodes -o json | jq '.items[] | {name: .metadata.name, conditions: .status.conditions}'
   ```

### Scenario 4: Pods Stuck in Pending State

#### Problem
Pods are stuck in the `Pending` state and are not being scheduled on any nodes.

#### Steps to Troubleshoot

1. **Check Pod Events**:
   - Review the events associated with the Pod to identify why it is not being scheduled.

   ```bash
   kubectl describe pod <pod-name>
   ```

2. **Verify Resource Requests and Limits**:
   - Ensure that the Pod's resource requests and limits are within the available resources of the nodes.

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: example-pod
   spec:
     containers:
     - name: example-container
       image: nginx
       resources:
         requests:
           memory: "64Mi"
           cpu: "250m"
         limits:
           memory: "128Mi"
           cpu: "500m"
   ```

3. **Check Node Affinity and Tolerations**:
   - Verify that the Pod's node affinity and tolerations match the available nodes.

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: example-pod
   spec:
     containers:
     - name: example-container
       image: nginx
     affinity:
       nodeAffinity:
         requiredDuringSchedulingIgnoredDuringExecution:
           nodeSelectorTerms:
           - matchExpressions:
             - key: kubernetes.io/e2e-az-name
               operator: In
               values:
               - e2e-az1
               - e2e-az2
   ```

4. **Inspect Cluster Resource Quotas**:
   - Ensure that the cluster resource quotas are not being exceeded.

   ```bash
   kubectl get resourcequotas --all-namespaces
   ```
