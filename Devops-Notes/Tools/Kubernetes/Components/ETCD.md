
# ETCD

## Overview
ETCD is a distributed key-value store that stores the cluster state. It replicates data across all its instances, ensuring data availability even if one instance crashes. It is crucial for Kubernetes as it stores all cluster configuration data.

### Key Features
- **Document Format**: Stores information in a document format where changes to one document do not affect other similar documents.
- **Cluster State Storage**: Every change made to a node is updated in the ETCD server, and Kubernetes considers a change successful once it is updated in ETCD.

## Setup and Configuration

### Manual Setup
- **Download and Run**: The ETCD binary needs to be downloaded manually and run as a service on the master node.
- **Default Port**: By default, it listens on port 2379.
- **KubeAdmin Setup**: When setting up the cluster using KubeAdmin, ETCD is automatically deployed as a static pod on the master node in the `kube-system` namespace.

### ETCDCTL Utility
- **Usage**: `etcdctl` is the default command-line utility that comes with the binary itself.
- **Commands**:
  - `etcdctl set key1 value1` - Store information as key-value.
  - `etcdctl get key1` - Retrieve information of the key-value.

### High Availability
- **Multiple Master Nodes**: In a cluster with multiple master nodes, the ETCD service runs on each master node and communicates on port 2380.
- **Configuration**: The initial configuration needs to ensure master nodes communicate with each other.

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
- **Version 2**:
  - `etcdctl set key1 value1`
  - `etcdctl backup`
  - `etcdctl cluster-health`
  - `etcdctl mk`
  - `etcdctl mkdir`

### Setting API Version
- **Environment Variable**: Set the environment variable to version 3 and export it to ensure persistence.

### Authentication
- **Certificate Files**: Specify the path to certificate files for authentication.
  - `--cacert /etc/kubernetes/pki/etcd/ca.crt`
  - `--cert /etc/kubernetes/pki/etcd/server.crt`
  - `--key /etc/kubernetes/pki/etcd/server.key`

## Installation

### Steps
1. Follow the release notes for any ETCD release.
2. Download and unzip the ETCD and `etcdctl` binary from [ETCD Releases](https://github.com/etcd-io/etcd/releases/).
3. Move the extracted binaries to `/usr/local/bin` or `/usr/bin`.

## Commands

### Backup a Cluster's ETCD
```sh
ETCDCTL_API=3 etcdctl \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save <backup-filename>
```

### Restore a Cluster from an ETCD Backup
```sh
ETCDCTL_API=3 etcdctl snapshot restore --data-dir="/var/lib/etcd-snapshot" <backup-filename>
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
