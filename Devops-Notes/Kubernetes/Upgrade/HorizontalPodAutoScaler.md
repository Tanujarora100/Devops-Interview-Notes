
### **1. How HPA Works**
- **Metrics Collection:** HPA continuously monitors resource usage metrics (e.g., CPU, memory) of the pods using the Kubernetes metrics server or Prometheus Adapter.
- **Target Utilization:** You define a target resource utilization level (e.g., 70% CPU utilization).
- **Control Loop:** HPA works in Loop and keeps checking the resource usage.

### **3. Configuration and API Versions**
- **API Versions:** HPA can be configured using `autoscaling/v1` (supports CPU-based scaling) or `autoscaling/v2` (supports multiple metrics including custom and external metrics).
- `v2` supports the custom metrics here.

### **4. Example Configuration**


```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  minReplicas: 2
  maxReplicas: 10
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

- **Viewing HPA Status:** Use `kubectl get hpa` to view the status of HPAs.
  ```sh
  kubectl get hpa
  ```

### **6. Handling Load Spikes and Stability**
- **Thrashing Prevention:** HPA includes mechanisms to prevent frequent scaling actions (thrashing) by using `stabilization windows and choosing the highest recommendation within a configurable time window.`
- **Custom Metrics:** In V2 Version of API.

### **7. Integration with Cluster Autoscaler**
- **Cluster Autoscaler:** Works at the infrastructure level to add or remove nodes based on the overall resource requirements of the cluster.

### **8. Best Practices**
- **Set Appropriate Metrics:** Ensure that the metrics used for scaling are appropriate for the application's performance characteristics.
- **Monitor and Adjust:** Continuously monitor the performance and adjust the HPA configuration as needed to optimize resource usage and application performance.
- **Combine with VPA:** Use VPA to get recommendations for resource requests and limits, and then use HPA to handle traffic spikes.

### **Example Workflow**
1. **Create a Deployment:**
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: my-app
   spec:
     replicas: 3
     selector:
       matchLabels:
         app: my-app
     template:
       metadata:
         labels:
           app: my-app
       spec:
         containers:
         - name: my-app
           image: my-app-image
           resources:
             requests:
               cpu: "200m"
             limits:
               cpu: "500m"
   ```
   Apply the deployment:
   ```sh
   kubectl apply -f my-app-deployment.yaml
   ```

2. **Create the HPA:**
   ```yaml
   apiVersion: autoscaling/v2beta2
   kind: HorizontalPodAutoscaler
   metadata:
     name: my-app-hpa
   spec:
     minReplicas: 2
     maxReplicas: 10
     scaleTargetRef:
       apiVersion: apps/v1
       kind: Deployment
       name: my-app
     metrics:
     - type: Resource
       resource:
         name: cpu
         target:
           type: Utilization
           averageUtilization: 70
   ```
   Apply the HPA:
   ```sh
   kubectl apply -f my-app-hpa.yaml
   ```

3. **Monitor the HPA:**
   ```sh
   kubectl get hpa my-app-hpa
   ```
-------------------
## **Step-by-Step Guide to Configure HPA with Custom Metrics**

### **1. Prerequisites**
- **Kubernetes Cluster:** Ensure you have a running Kubernetes cluster.
- **Metrics Server:** 
- **Custom Metrics API:** You need a custom metrics adapter, such as the Prometheus Adapter.

### **2. Deploy the Metrics Server**
```sh
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```
Verify its deployment:
```sh
kubectl get deployment metrics-server -n kube-system
```

### **3. Deploy Prometheus and the Prometheus Adapter**

#### **Deploy Prometheus:**
You can use Helm to deploy Prometheus:
```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus
```

#### **Deploy Prometheus Adapter:**
Save the following manifest to a file named `prometheus-adapter.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus-adapter
  namespace: kube-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus-adapter
  template:
    metadata:
      labels:
        app: prometheus-adapter
    spec:
      containers:
      - name: prometheus-adapter
        image: directxman12/k8s-prometheus-adapter:v0.8.4
        args:
        - /adapter
        - --config=/etc/adapter/config.yaml
        volumeMounts:
        - name: config
          mountPath: /etc/adapter
          readOnly: true
      volumes:
      - name: config
        configMap:
          name: prometheus-adapter-config
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-adapter-config
  namespace: kube-system
data:
  config.yaml: |
    rules:
    - seriesQuery: 'http_requests_total{kubernetes_namespace!="",kubernetes_pod_name!=""}'
      resources:
        overrides:
          kubernetes_namespace: {resource: "namespace"}
          kubernetes_pod_name: {resource: "pod"}
      name:
        matches: "^(.*)_total"
        as: "${1}_per_second"
      metricsQuery: 'sum(rate(<<.Series>>{<<.LabelMatchers>>}[5m])) by (<<.GroupBy>>)'

apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  name: v1beta1.custom.metrics.k8s.io
spec:
  service:
    name: prometheus-adapter
    namespace: kube-system
  group: custom.metrics.k8s.io
  version: v1beta1
  insecureSkipTLSVerify: true
  groupPriorityMinimum: 100
  versionPriority: 100
```

```sh
kubectl apply -f prometheus-adapter.yaml
```

### **4. Expose Custom Metrics**
Ensure your application exposes custom metrics that Prometheus can scrape. For example, if you want to scale based on HTTP request rate, your application should expose a metric like `http_requests_total`.

### **5. Configure HPA to Use Custom Metrics**


```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Pods
    pods:
      metric:
        name: http_requests_per_second
      target:
        type: AverageValue
        averageValue: 20
```
Apply the HPA configuration:
```sh
kubectl apply -f my-app-hpa.yaml
```
