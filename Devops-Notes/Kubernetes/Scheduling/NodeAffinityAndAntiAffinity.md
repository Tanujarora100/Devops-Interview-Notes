## Node Affinity and Anti Affinity

### **Overview**
- **Purpose:** Constrain or prefer Pods to run on particular nodes using label selectors.
- **Default Behavior:** Scheduler automatically places Pods based on resource availability and other factors.

### **Methods to Assign Pods to Nodes**
1. **nodeSelector**
2. **Affinity and Anti-affinity**
3. **nodeName**
4. **Pod Topology Spread Constraints**

### **Node Labels**
- Nodes have labels that can be manually attached or automatically populated by Kubernetes.
- **Security Note:** Use labels that the kubelet cannot modify to prevent compromised nodes from setting labels.

### **Node Isolation/Restriction**
- Use labels with the `node-restriction.kubernetes.io/` prefix for node isolation.
- Ensure `NodeRestriction` admission plugin is enabled.

### **nodeSelector**
- Simplest form of node selection constraint.
- Add `nodeSelector` field in Pod specification to specify required node labels.
- Example:
  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: my-pod
  spec:
    nodeSelector:
      disktype: ssd
    containers:
    - name: my-container
      image: my-image
  ```

### **Affinity and Anti-affinity**
- **Benefits:**
  - More expressive than `nodeSelector`.
  - Can specify soft (preferred) and hard (required) rules.
  - Can use labels on other Pods for constraints.
- **Types:**
  - **Node Affinity:** Similar to `nodeSelector` but more expressive.
    - `requiredDuringSchedulingIgnoredDuringExecution`: Must be met for scheduling.
    - `preferredDuringSchedulingIgnoredDuringExecution`: Preferred but not mandatory.
  - **Inter-pod Affinity/Anti-affinity:** Constrain Pods based on labels of other Pods.
    - `requiredDuringSchedulingIgnoredDuringExecution`
    - `preferredDuringSchedulingIgnoredDuringExecution`

#### **Node Affinity Example**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: with-node-affinity
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: topology.kubernetes.io/zone
            operator: In
            values:
            - antarctica-east1
            - antarctica-west1
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: another-node-label-key
            operator: In
            values:
            - another-node-label-value
  containers:
  - name: with-node-affinity
    image: registry.k8s.io/pause:2.0
```

### **Node Affinity Weight**
- Specify a `weight` between 1 and 100 for `preferredDuringSchedulingIgnoredDuringExecution`.
- Nodes with higher total scores are prioritized.

#### **Node Affinity Weight Example**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: with-affinity-preferred-weight
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/os
            operator: In
            values:
            - linux
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: label-1
            operator: In
            values:
            - key-1
      - weight: 50
        preference:
          matchExpressions:
          - key: label-2
            operator: In
            values:
            - key-2
  containers:
  - name: with-node-affinity
    image: registry.k8s.io/pause:2.0
```

### **Inter-pod Affinity and Anti-affinity**
- Constrain Pods based on labels of other Pods on the same node or other topological domains.
- **Note:** Requires substantial processing and consistent labeling across nodes.

#### **Inter-pod Affinity Example**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: with-pod-affinity
spec:
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: security
            operator: In
            values:
            - S1
        topologyKey: topology.kubernetes.io/zone
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
            - key: security
              operator: In
              values:
              - S2
          topologyKey: topology.kubernetes.io/zone
  containers:
  - name: with-pod-affinity
    image: registry.k8s.io/pause:2.0
```

### **nodeName**
- Directly specify the node for the Pod.
- **Limitations:**
  - Pod will not run if the node does not exist or lacks resources.
  - Node names in cloud environments may not be predictable or stable.
- **Warning:** Intended for advanced use cases and custom schedulers.

#### **nodeName Example**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeName: kube-01
```

### **Pod Topology Spread Constraints**
- Control how Pods are spread across the cluster among failure-domains.
- **Use Cases:** Improve performance, availability, and utilization.

### **Operators for Affinity/Anti-affinity**
- **Common Operators:**
  - `In`, `NotIn`, `Exists`, `DoesNotExist`
- **Node Affinity Only:**
  - `Gt`, `Lt`
