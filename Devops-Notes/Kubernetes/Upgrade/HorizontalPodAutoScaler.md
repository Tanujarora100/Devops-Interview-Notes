
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

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
 name: my-app-hpa
spec:
 scaleTargetRef:
  apiVersion: apps/v1
  kind: Deployment
  name: my-app 
minReplicas: 2
maxReplicas: 3
metrics:
 - type: Resource
   metric: 
    name: cpu
    type: averageValue
    value: 70