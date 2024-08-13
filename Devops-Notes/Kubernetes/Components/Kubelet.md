### Working:

- It’s a process running on the worker nodes that registers the worker nodes to the cluster.
- When the scheduler schedules a pod on a given node (populates its `NodeName` property), the **`kubelet` service running on that node requests the the container runtime engine (eg. Docker) to pull the image** and run the container.
- It periodically monitors the status of the node and the pods on them and **reports them to the `kube-api` server.**
- Kubelet can be configured to look for **K8s manifest files in a directory.**
- Ran as a static pod.

### Installation
- The `kubelet` service must be run manually on the worker nodes. 
- **It is not setup automatically when we use KubeAdmin to setup the cluster.**