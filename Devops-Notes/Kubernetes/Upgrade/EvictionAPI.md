## Eviction API and Pod Disruption Budgets (PDBs)

### **Eviction API**

**Purpose:**
- The Eviction API in Kubernetes is used to programmatically trigger the eviction of pods from nodes. This is typically done to perform maintenance, upgrade nodes, or manage resources more effectively.

**Functionality:**
- When an eviction is requested via the Eviction API, an **`Eviction`** object is created, which triggers the graceful termination of the specified pod.
- The API performs admission checks to ensure that the eviction does not violate any Pod Disruption Budgets (PDBs) that apply to the pod.

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
    - If the eviction would violate a PDB, the request is denied with a `429 Too Many Requests` status.
3. **Graceful Termination:** The kubelet on the node where the pod is running initiates the graceful shutdown process, respecting the `terminationGracePeriodSeconds` setting.
4. **Pod Deletion:** After the grace period, the pod is forcefully terminated and removed from the API server.

**Example Usage:**
- Using `kubectl` to drain a node, which internally uses the Eviction API:
    ```sh
    kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
    ```

### **Pod Disruption Budgets (PDBs)**

**Purpose:**
- PDBs are used to limit the number of pods that can be simultaneously disrupted during voluntary operations like maintenance, upgrades, and scaling. They help ensure that a minimum number of pods remain available to maintain application availability.

**Functionality:**
- **MinAvailable:** Specifies the minimum number of pods that must be available at any time.
- **MaxUnavailable:** Specifies the maximum number of pods that can be unavailable at any time.

**How It Works:**
1. **Define PDB:** Create a PDB that specifies the availability requirements for your application.
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
2. **Enforcement:** During voluntary disruptions, Kubernetes checks the PDB to ensure that the number of disrupted pods does not exceed the specified limits.
3. **Blocking Operations:** If a proposed operation would violate the PDB, it is either blocked or limited to ensure compliance with the PDB.

**Example Usage:**
- Ensuring that at least 4 pods of an application are always available:
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

### **Forcing a Drain Operation**

In some cases, you might need to drain a node even if it violates the PDB. Kubernetes does not provide a built-in flag to ignore PDBs during a drain operation. However, you can manually handle such situations by temporarily modifying or deleting the PDB:

1. **Delete the PDB:**
    ```sh
    kubectl delete pdb my-app-pdb
    ```

2. **Drain the Node:**
    ```sh
    kubectl drain <node-name> --ignore-daemonsets
    ```

3. **Recreate the PDB:**
    ```sh
    kubectl apply -f my-app-pdb.yaml
    ```

