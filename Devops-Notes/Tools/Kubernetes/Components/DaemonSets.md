

1. **What is a DaemonSet in Kubernetes?**
   - A DaemonSet ensures that a copy of a Pod runs on all (or some) nodes in a Kubernetes cluster. 
   - When nodes are added to the cluster, Pods are added to them. When nodes are removed from the cluster, those Pods are garbage collected.

2. **When would you use a DaemonSet?**
   - used for running background services on all nodes, such as:
     - Log collection (e.g., Fluentd, Logstash)
     - Node monitoring (e.g., Prometheus Node Exporter)
     - Cluster storage (e.g., glusterd, ceph).

3. **How do you create a DaemonSet?**
   - YAML configuration file and applying it using `kubectl apply -f <file-name>`.

4. **What are the update strategies available for DaemonSets?**
     - **RollingUpdate**: This is the default strategy. 
     - **OnDelete**: This strategy requires manual deletion of old Pods.

5. **How can you restrict a DaemonSet to run on specific nodes?**
     - **nodeSelector**: Specifies a label selector to match nodes.
     - **nodeAffinity**: Provides more expressive rules for node selection.
     - **Taints and Tolerations**: Allows Pods to be scheduled on nodes with specific taints.

6. **How do you perform a rolling update on a DaemonSet?**
   - you can update the DaemonSet's Pod template and apply the changes using `kubectl apply -f <updated-file>`.


7. **What are the differences between a DaemonSet and a Deployment?**
   - **DaemonSet**:  node-level operations like logging
   - **Deployment**: Manages stateless applications

8. **How does Kubernetes handle DaemonSet Pods on nodes marked as unschedulable?**
   - Kubernetes automatically adds a toleration for `node.kubernetes.io/unschedulable:NoSchedule` **to DaemonSet Pods, allowing them to run on nodes marked as unschedulable**

9. **What are some best practices for using DaemonSets?**
     - restart policy to `Always`.
     - Using namespaces
     - Using `preferredDuringSchedulingIgnoredDuringExecution` for node affinity to avoid scheduling issues.
     - Ensuring DaemonSet Pods have a high priority

10. **Can you explain how to delete a DaemonSet and its associated Pods?**
    -use the command `kubectl delete daemonset <daemonset-name>`.


