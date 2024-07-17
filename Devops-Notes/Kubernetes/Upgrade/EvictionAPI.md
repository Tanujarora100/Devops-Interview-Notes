## Eviction API and Pod Disruption Budgets (PDBs)

### **Eviction API**

**Purpose:**
- The Eviction API in Kubernetes is used to programmatically trigger the eviction of pods from nodes.

**Functionality:**
- When an eviction is requested via the Eviction API, an **`Eviction`** object is created, which triggers the graceful termination of the specified pod.
- The API performs admission checks to ensure that the eviction does not violate any Pod Disruption Budgets (PDBs) 
**How It Works:**
1. **Request Eviction:** An eviction request is made by creating an `Eviction` object.
    ```yaml
    apiVersion: policy/v1
    kind: Eviction
    metadata:
      name: <pod-name>
      namespace: <namespace>
    ```
2. **Admission Checks:** The API server checks if the eviction respects the PDBs and other policies.
    - If the eviction is allowed, the pod is marked for termination.
    - If the eviction would violate a PDB, the request is denied with a `429 Too Many Requests`.
3. **Graceful Termination:** The kubelet on the node where the pod is running initiates the graceful shutdown process, respecting the `terminationGracePeriodSeconds`.
4. **Pod Deletion:** After the grace period, the pod is forcefully terminated and removed from the API server.

**Example Usage:**
- Using `kubectl` to drain a node, which internally uses the Eviction API:
    ```sh
    kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
    ```

### **Comparison: Eviction API vs. PDBs**

| Feature                  | Eviction API                               | Pod Disruption Budgets (PDBs)                |
|--------------------------|--------------------------------------------|----------------------------------------------|
| **Primary Purpose**      | Programmatically trigger pod evictions     | Ensure minimum pod availability during disruptions |
| **Scope**                | Applies to specific pods                   | Applies to sets of pods defined by label selectors |
| **Enforcement Mechanism**| Admission checks during eviction requests  | Limits voluntary disruptions based on defined budgets |
| **Use Cases**            | Node maintenance, resource management      | High availability during maintenance, upgrades, scaling |
| **Interaction**          | Respects PDBs during eviction requests     | Blocks or limits operations that violate PDBs |




### **Behavior of `kubectl drain` with PDBs**

1. **Respecting PDBs:**
   - The `kubectl drain` command respects PDBs by default. This means that it will not evict more pods than allowed by the PDB. 
   - If evicting a pod would violate the PDB, the drain operation will block and retry until it can proceed without violating the PDB.

2. **Blocking Drain Operations:**
   - If a PDB specifies that a certain number of pods must remain available, and evicting a pod would reduce the number of available pods below this threshold, the drain operation will not complete. 
   - For example, if a PDB specifies `minAvailable: 3` and draining the node would bring the number of available pods below 3, the drain operation will be blocked.

### **Example Scenario**

**Scenario: Draining a Node with a PDB**

Suppose you have a deployment with 5 replicas and a PDB that specifies `minAvailable: 4`. You want to drain a node that is hosting 2 of these pods.

1. **PDB Definition:**
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

2. **Draining the Node:**
    ```sh
    kubectl drain <node-name> --ignore-daemonsets
    ```

3. **Expected Behavior:**
   - The `kubectl drain` command will attempt to evict the pods on the node.
   - Since evicting 2 pods would reduce the number of available pods to 3, which violates the PDB (`minAvailable: 4`), the drain operation will block and retry until the PDB conditions are met.
   - `429 error` comes.

#### **Forcing a Drain Operation**
- Temporary delete the PDB is solution to this problem.



## **Types of Evictions**

### **1. Node-Pressure Eviction**
- Kubelet => High Resource Utilization

### **2. API-Initiated Eviction**
- Drain Operation=> API Server

## **Internal Working of Eviction API**

### **1. Node-Pressure Eviction**

#### **Monitoring and Thresholds**
- The kubelet continuously monitors the resource usage on the node.

#### **Eviction Process**
- **Pod Selection**: The kubelet selects Pods for eviction based on their Quality of Service (QoS) class. Best-effort Pods are evicted first, followed by Burstable, and Guaranteed Pods are evicted last.
- **Pod Status Update**: The kubelet updates the Pod status to `Failed` with the reason `Evicted`.

### **2. API-Initiated Eviction**

#### **Eviction Request**


#### **Validation**
- The API server validates the eviction request against any existing Pod Disruption Budgets (PDBs). PDBs ensure that a minimum number of Pods remain available during voluntary disruptions.
- If the eviction request violates a PDB, the request is denied with 429.

#### **Pod Deletion**
- If the eviction request is validated, the API server marks the Pod for deletion.

### **Node-Pressure Eviction Example**
1. **Resource Monitoring**: The kubelet monitors node resources.
2. **Threshold Exceeded**: Memory usage exceeds the threshold.
3. **Pod Selection**: The kubelet selects a Best-effort Pod for eviction.
4. **Pod Termination**: The kubelet updates the Pod status to `Failed` with reason `Evicted` and terminates the Pod.

### **API-Initiated Eviction Example**
1. **Eviction Request**: An eviction request is sent using the Eviction API.
2. **Validation**: The API server checks PDBs and validates the request.
3. **Pod Deletion**: The API server marks the Pod for deletion.
4. **Graceful Termination**: The kubelet respects the termination grace period and terminates the Pod.

