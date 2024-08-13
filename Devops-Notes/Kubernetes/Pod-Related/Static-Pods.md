## **Static Pods in Kubernetes**

Static Pods are a special type of pod in Kubernetes that are `managed directly by the kubelet daemon service` on a specific node, without the involvement of the Kubernetes API server. 

### **Key Characteristics**

- Managed by Kubelet
- No API Server Involvement
- **Mirror Pods**: For visibility, the **kubelet creates a mirror pod on the Kubernetes API server for each static pod**. 
    - These mirror pods make it visible in the kubectl get pods commands.
- **Node-Specific**: Static pods are always bound to the node where their manifest files are located. 
    - `They do not get rescheduled to other nodes if the node fails`.

### **Use Cases**

1. **Control Plane Components**: Static pods are commonly used to run Kubernetes control plane components such as `kube-apiserver`, `kube-controller-manager`, and `kube-scheduler`. 
2. **System-Level Applications**: They can be used to run essential system-level applications directly on the node, such as monitoring agents or custom load balancers


### **Creating Static Pods**
- A running Kubernetes cluster.
- Access to the node where you want to create the static pod.
- `kubectl` installed and configured to communicate with your cluster.

#### **Steps to Create a Static Pod**

1. **Create a Pod Manifest File**: 

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: static-nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
    ```

2. **Place the Manifest File in the Static Pod Directory**: By default, the kubelet looks for static pod manifest files in `/etc/kubernetes/manifests`. Copy the manifest file to this directory:

    ```bash
    sudo cp static-nginx.yaml /etc/kubernetes/manifests/
    ```

3. **Verify the Static Pod**: The kubelet will automatically detect the new manifest file and start the static pod. You can verify that the static pod is running using:

    ```bash
    kubectl get pods -o wide
    ```

### **Managing Static Pods**

- **Modifying Static Pods**: To modify a static pod, edit the corresponding manifest file.
- **Deleting Static Pods**: To delete a static pod, remove the manifest file from the static pod directory. The kubelet will stop and remove the pod.

    ```bash
    sudo rm /etc/kubernetes/manifests/static-nginx.yaml
    ```

### **Comparison: Static Pods vs. Regular Pods**

| Feature                  | Static Pods                                      | Regular Pods                                       |
|--------------------------|--------------------------------------------------|----------------------------------------------------|
| Management               | Managed directly by kubelet                      | Managed by Kubernetes control plane                |
| Scheduling               | Always run on the node where the manifest is placed | Scheduled by the Kubernetes scheduler               |
| Visibility               | Visible via mirror pods in the API server        | Fully visible and managed by the API server         |
| Use Cases                | Control plane components, system-level applications | General application workloads                      |
| Configuration            | Defined in manifest files on the node            | Defined in Kubernetes API objects (e.g., Deployment, StatefulSet) |


1. **How do static pods differ from DaemonSets?**
   - Static pods are managed directly by the kubelet and are specific to a node, while DaemonSets are managed by the Kubernetes control plane.

2. **Can you schedule a static pod on multiple nodes?**
   - No, static pods are bound to the specific node where their manifest files are located. 
   - To run static pods on multiple nodes, you need to place the manifest files on each node.
