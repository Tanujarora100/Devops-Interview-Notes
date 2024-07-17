
# DNS Resolution

### CoreDNS and Kubernetes API

CoreDNS is the DNS server used in most Kubernetes clusters. It interacts with the Kubernetes API to keep track of the current state of all Services and Pods in the cluster.

1. **Pod Creation and Registration**:
   - When a Pod is created, it is assigned an IP address by the Kubernetes network plugin.
   - The Kubernetes API server registers this Pod and its IP address in the kube proxy.

2. **DNS Record Creation**:
   - CoreDNS watches the Kubernetes API for changes in the state of Pods and Services.
   - When a new Pod is created, CoreDNS creates a DNS A record for the Pod using its IP address and the naming convention `pod-ip-address.my-namespace.pod.cluster-domain.example`.
   - For example, a Pod with IP `10.44.0.7` in the `default` namespace would have a DNS record `10-44-0-7.default.pod.cluster.local`.

3. **Dynamic Updates**:
   - If a Pod is deleted or its IP address changes, the Kubernetes API server updates its state.
   - CoreDNS receives these updates and dynamically adjusts the DNS records to reflect the current state.
   - This ensures that DNS queries always return the current IP addresses of the active Pods.
   - Watch Mechanism: The API server uses a watch mechanism to keep track of changes in etcd. Components like kubelet and CoreDNS subscribe to these updates.
CoreDNS Updates: When there is a change in the state of a Pod (e.g., creation, deletion, IP change), CoreDNS receives these updates via the API server. 
   - CoreDNS dynamically adjusts the DNS records to reflect the current state, ensuring that DNS queries return the current IP addresses of active Pods.

#### Interaction Flow
- Client Request: A client (e.g., kubectl) sends a request to create, modify, or delete a Pod.
- API Server Processing:
    - Authorize
    - Validate
    - Persist in etd
- Watch Notification: kubelet and CoreDNS, which watch for changes, are notified of the update.
- CoreDNS Adjustment: CoreDNS adjusts its DNS records