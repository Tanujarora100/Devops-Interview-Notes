## Pod Disruption Budgets (PDBs) in Kubernetes

Pod Disruption Budgets (PDBs) are a crucial feature in Kubernetes designed to maintain application availability during voluntary disruptions such as maintenance, upgrades, and scaling operations. 

### **Scenario 1: Ensuring High Availability During Node Maintenance**

**Question:** You are planning to perform maintenance on a node in your Kubernetes cluster. How can you ensure that your application remains highly available during this maintenance?

**Answer:** To ensure high availability during node maintenance, you can define a Pod Disruption Budget (PDB) for your application. 

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-app-pdb
spec:
  minAvailable: 4
  selector:
    matchLabels:
      app: my-app
```

### **Scenario 2: Handling Rolling Updates**

**Question:** You need to perform a rolling update on a deployment with 10 replicas. How can you ensure that the update process does not reduce the number of available pods below a certain threshold?

**Answer:** To handle rolling updates without reducing the number of available pods below a certain threshold, you can set a PDB with a `minAvailable` or `maxUnavailable` value. For instance, if you want to ensure that at least 8 pods are always available during the update, you can set `minAvailable` to 8.

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-app-pdb
spec:
  minAvailable: 8
  selector:
    matchLabels:
      app: my-app
```
```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-app-pdb
spec:
  maxUnavailable: 2
  selector:
    matchLabels:
      app: my-app
```

### **Scenario 3: Scaling Operations**

**Question:** You plan to scale down a deployment from 10 replicas to 5. How can you ensure that this scaling operation does not disrupt your application's availability?

**Answer:** To ensure that scaling down does not disrupt your application's availability, you can define a PDB that specifies the minimum number of pods that must remain available. 
- For example, if you want at least 6 pods to be available during the scaling operation, you can set `minAvailable` to 6.

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-app-pdb
spec:
  minAvailable: 6
  selector:
    matchLabels:
      app: my-app
```


### **Scenario 4: Multi-Zone Cluster Management**

**Question:** Your application is deployed across multiple zones in a Kubernetes cluster. How can you use PDBs to ensure high availability during zone-specific disruptions?

**Answer:** In a multi-zone Kubernetes cluster, you can use PDBs in conjunction with `anti-affinity rules to ensure high availability` during zone-specific disruptions. 
- For example, if your application `has 6 replicas spread across 3 zones, you can set a PDB to ensure that at least 4 pods` are always available.

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-app-pdb
spec:
  minAvailable: 4
  selector:
    matchLabels:
      app: my-app
```

Additionally, you can use anti-affinity rules to ensure that pods are distributed across different zones, reducing the impact of zone-specific disruptions.

```yaml
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app
              operator: In
              values:
                - my-app
        topologyKey: "failure-domain.beta.kubernetes.io/zone"
```

### **Scenario 5: Dealing with Involuntary Disruptions**

**Question:** How do PDBs help in managing involuntary disruptions such as hardware failures?

**Answer:** While PDBs primarily protect against voluntary disruptions, they also help manage the impact of involuntary disruptions. By ensuring a minimum number of pods remain available, PDBs provide a buffer that can help absorb the impact of unexpected failures. 
- For example, if a node fails and you have a PDB that specifies a minimum of 3 available pods, Kubernetes will try to reschedule the affected pods to maintain the desired availability.


### **Consequences of Not Setting a PDB**

1. **Increased Risk of Downtime:**
2. **Uncontrolled Disruptions:**
3. **Impact on Stateful Applications:**
   - For stateful applications that require a certain number of instances to maintain quorum (e.g., databases like etcd, ZooKeeper), not having a PDB can lead to a loss of quorum, making the application unable to process writes.
4. **Increased Latency and Performance Degradation:**


## Differences Between Pod Disruption Budgets (PDBs) and Max Surge in Deployments


### **Pod Disruption Budgets (PDBs)**

**Purpose:**
- PDBs are used to ensure that a minimum number of pods remain available during voluntary disruptions such as maintenance, upgrades, or scaling operations.

**Functionality:**
- **MinAvailable:** Specifies the minimum number of pods that must be available at any time.
- **MaxUnavailable:** Specifies the maximum number of pods that can be unavailable at any time.

**Use Cases:**
- PDBs are particularly useful for maintaining high availability during node maintenance, cluster upgrades, or other administrative tasks that might temporarily disrupt pods.
**Key Points:**
- PDBs apply to voluntary disruptions and do not control involuntary disruptions such as hardware failures.

### **Max Surge in Deployments**

**Purpose:**
- Max surge is used to control the number of additional pods that can be created during a rolling update of a deployment.

**Functionality:**
- **MaxSurge:** Specifies the maximum number of pods that can be created above the desired number of pods during an update.
- **MaxUnavailable:** Specifies the maximum number of pods that `can be unavailable during the update process.`

**Use Cases:**
- Max surge is useful during rolling updates to ensure that new pods are created before old pods are terminated, thereby maintaining service availability.

**Example:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
```

### **Comparison Table**

| Feature                 | Pod Disruption Budgets (PDBs)                 | Max Surge in Deployments                      |
|-------------------------|-----------------------------------------------|-----------------------------------------------|
| **Primary Purpose**     | Maintain availability during voluntary disruptions | Control pod creation during rolling updates   |
| **Key Parameters**      | `minAvailable`, `maxUnavailable`              | `maxSurge`, `maxUnavailable`                  |
| **Scope**               | Applies to voluntary disruptions (e.g., maintenance, scaling) | Applies to rolling updates of deployments     |
| **Enforcement**         | Eviction API                                  | Deployment controller                         |
| **Use Case Example**    | Ensuring a minimum number of pods are available during node maintenance | Adding new pods before terminating old ones during updates |
| **Applicability**       | All types of controllers (Deployments, StatefulSets, etc.) | Specific to Deployments                       |

