The Kubernetes Metrics Server is a vital component for monitoring resource usage within a Kubernetes cluster. 
- It collects metrics from the kubelets running on each node and exposes these metrics through the Kubernetes API server. 
- These metrics are primarily used for autoscaling purposes, such as with the Horizontal Pod Autoscaler (HPA) and Vertical Pod Autoscaler (VPA). 

## **Overview**


### **Use Cases**
- **Horizontal Pod Autoscaling (HPA)**: 
- **Vertical Pod Autoscaling (VPA)**: 


### **Installation Steps**
**Test the Metrics Server**
   - Check node metrics:
     ```sh
     kubectl top nodes
     ```
   - Check pod metrics:
     ```sh
     kubectl top pods
     ```

## **Configuration**

### **Important Flags**
- **`--kubelet-preferred-address-types`**: Specifies the priority of node address types used when connecting to nodes (default: `[Hostname,InternalDNS,InternalIP,ExternalDNS,ExternalIP]`).
- **`--kubelet-insecure-tls`**: Disables TLS certificate verification (useful for testing).
- **`--metric-resolution`**: Sets the interval at which metrics are collected (default: `60s`).

### **Example Configuration**
Here’s an example of a modified `components.yaml` with additional configurations:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: metrics-server
  namespace: kube-system
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: metrics-server
  template:
    metadata:
      labels:
        k8s-app: metrics-server
    spec:
      containers:
      - name: metrics-server
        image: k8s.gcr.io/metrics-server/metrics-server:v0.6.4
        args:
        - --cert-dir=/tmp
        - --secure-port=4443
        - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
        - --kubelet-insecure-tls
        - --metric-resolution=15s
        ports:
        - name: main-port
          containerPort: 4443
          protocol: TCP
        livenessProbe:
          httpGet:
            path: /healthz
            port: 4443
            scheme: HTTPS
          initialDelaySeconds: 20
          timeoutSeconds: 1
```

## **Limitations and Considerations**

- **Not for Monitoring Solutions**: Metrics Server is not designed for long-term monitoring or forwarding metrics to external systems. For comprehensive monitoring, consider using solutions like Prometheus.
- **Scalability**: Default configurations are suitable for clusters up to 100 nodes. 

