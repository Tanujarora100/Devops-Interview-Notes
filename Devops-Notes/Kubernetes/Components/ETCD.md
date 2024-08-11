
# ETCD

## Overview
ETCD is a distributed key-value store that stores the cluster state.
- It replicates data across all its instances, ensuring data availability even if one instance crashes. 

### Key Features
- **Document Format**: Stores information in a document format where changes to one document do not affect other similar documents.
- **Cluster State Storage**: Every change made to a node is updated in the ETCD server by the kube api server.

## Setup and Configuration

### Manual Setup
- **Download and Run**: The ETCD binary needs to be downloaded manually and run as a service on the master node.
- **Default Port**: listens on port `2379`.
- **KubeAdmin Setup**: When setting up the cluster using KubeAdmin, ETCD is automatically deployed as a static pod on the master node in the `kube-system` namespace.

### ETCDCTL Utility
- **Usage**: `etcdctl` is the default command-line.


### High Availability
- **Multiple Master Nodes**: In a cluster with multiple master nodes, the ETCD service runs on each master node and communicates on port 2380.


## ETCD Versions

### API Versions
- **Version 3**: Default API version.
- **Version 2**: Older version with different command syntax.

### Commands
- **Version 3**:
  - `etcdctl put key1 value1`
  - `etcdctl snapshot save`
  - `etcdctl endpoint health`
  - `etcdctl get`


### Setting API Version
- **Environment Variable**: Set the environment variable to version 3 and export it to ensure persistence.

### Authentication
- **Certificate Files**: Specify the path to certificate files for authentication.
  - `--cacert /etc/kubernetes/pki/etcd/ca.crt`
  - `--cert /etc/kubernetes/pki/etcd/server.crt`
  - `--key /etc/kubernetes/pki/etcd/server.key`

## Installation

### Backup a Cluster's ETCD
```sh
ETCDCTL_API=3 etcdctl \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save <backup-filename>
```


## Highly Available Topology

### Options
1. **Stacked Control Plane Nodes**: ETCD nodes are collocated with control plane nodes.
2. **External ETCD Nodes**: ETCD runs on separate nodes from the control plane.

### Stacked ETCD Topology
- **Description**: The distributed data storage cluster provided by ETCD is stacked on top of the cluster formed by nodes managed by kubeadm that run control plane components.
- **Components**: Each control plane node runs an instance of `kube-apiserver`, `kube-scheduler`, and `kube-controller-manager`.
- **Risk**: If one node goes down, both an ETCD member and a control plane instance are lost.
- **Mitigation**: Run a minimum of three stacked control plane nodes for an HA cluster.
- **Default**: This is the default topology in kubeadm.

![Stacked ETCD Topology](https://kubernetes.io/images/kubeadm/kubeadm-ha-topology-stacked-etcd.svg)

### External ETCD Topology
- **Description**: The distributed data storage cluster provided by ETCD is external to the cluster formed by nodes that run control plane components.
- **Components**: Each control plane node runs an instance of `kube-apiserver`, `kube-scheduler`, and `kube-controller-manager`.
- **Advantage**: Losing a control plane instance or an ETCD member has less impact on cluster redundancy.
- **Requirement**: Requires twice the number of hosts as the stacked HA topology (minimum of three hosts for control plane nodes and three hosts for ETCD nodes).

![External ETCD Topology](https://kubernetes.io/images/kubeadm/kubeadm-ha-topology-external-etcd.svg)


### 1. **Core Components of etcd**

- **Raft Consensus Algorithm**:
- **WAL (Write-Ahead Log)**: Every change in etcd is written to a write-ahead log before it’s applied. 
  - This ensures that even if the system crashes, the changes can be recovered.
- **Snapshot**: To avoid the WAL from growing indefinitely, etcd periodically takes snapshots of the entire key-value store. This reduces the size of the WAL and makes recovery faster.
- **State Machine**: Etcd’s state machine applies changes to the key-value store once they are committed by Raft.
- **gRPC API**: Etcd exposes its functionalities through a gRPC-based API, which clients can use to interact with the store (e.g., reading, writing, watching keys).

### 2. **Internal Processes in etcd**

#### a. **Leader Election**
   - **Leader Role**: 
   - **Election Process**: If the leader fails, the remaining nodes will elect a new leader using the Raft consensus algorithm. 
    - The node with the highest term number (a monotonically increasing counter) usually becomes the leader.
   - **Heartbeat Mechanism**: The leader periodically sends heartbeats to the follower nodes to assert its leadership.

#### b. **Log Replication**
   - **Appending Entries**: When a client sends a write request (e.g., to set a key-value pair), the leader appends this request to its WAL as a new entry.
   - **Replication to Followers**: The leader then replicates this log entry to all follower nodes. 
    - The leader waits until a majority of the followers (a quorum) acknowledge the receipt of this entry.
   - **Committing Entries**: Once a majority of the followers have written the entry to their logs, the leader commits the entry. 
    - Only after the entry is committed is it applied to the state machine, which modifies the actual key-value store.
   - **Follower Synchronization**: If a follower falls behind (e.g., it was down for some time), it requests missing log entries from the leader to catch up.

#### c. **Handling Read Requests**
   - **Linearizability**: Etcd ensures that all read requests are linearizable. This means that a read will always return the most recent write. 
    - To achieve this, etcd uses a process called read-index, where the leader ensures that the follower nodes are up-to-date before responding to a read request.
   - **Serving Reads**: Typically, the leader serves the read requests directly from its state machine.
    - However, etcd can be configured to allow followers to serve reads if strict consistency is not required.

#### d. **Snapshotting**
   - **Periodic Snapshots**: As the write-ahead log grows, it can become large, which would slow down recovery in case of a failure. To manage this, etcd takes snapshots of the key-value store at intervals.
   - **Applying Snapshots**: When etcd restarts, it can restore the state by loading the latest snapshot and then replaying any log entries that were recorded after the snapshot was taken.
   - **Compaction**: After a snapshot is taken, the log entries prior to the snapshot can be compacted (i.e., deleted) to save space.

#### e. **Handling Failures**
   - **Leader Failure**: If the leader fails, a new leader is elected as described earlier. The cluster remains operational as long as a majority of nodes are available.
   - **Network Partitions**: If a network partition occurs, the partition with a majority of nodes can continue to operate and elect a new leader if needed. The minority partition will be unable to commit any new entries until it reconnects to the majority.
   - **Data Recovery**: Etcd uses its WAL and snapshots to recover from crashes. The WAL ensures that no data is lost, and snapshots speed up the recovery process.

#### f. **Watching for Changes**
   - **Watch Mechanism**: Etcd provides a watch mechanism that allows clients to subscribe to changes to specific keys or prefixes. 
    - When a key changes, the client is notified.
   - **Efficient Watch Implementation**: Watches are implemented efficiently to minimize the load on etcd. 
    - Clients receive updates only when changes occur, and they can resume watching from a specific revision in case of disconnection.


### 3. **Security Features**

Etcd also includes several security features:

- **TLS Encryption**: All communication between etcd nodes and between etcd and clients is encrypted using TLS.
- **Authentication and Authorization**: Etcd supports user authentication and role-based access control (RBAC) to restrict access to data.
- **Audit Logging**: Etcd can log access to sensitive data for auditing purposes.
