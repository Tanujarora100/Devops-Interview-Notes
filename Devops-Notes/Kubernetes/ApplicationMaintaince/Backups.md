The following can be backed up:

- Resource Configurations
    - Good practice to keep this on SCM.
    - Declarative approach is the better approach.
- ETCD Cluster
- Persistent Volumes

### Backing up Resource Configuration

If all the k8s resources are created using config files (declarative approach), then the configuration directory can be backed up using a version control system like Git. 

If all the resources are not created this way, we can generate resource configuration by running `kubectl get all --all-namespaces -o yaml > all.yaml`. 

Recommended to use **Velero,** a managed tool for backups.

### Backing up ETCD Cluster

ETCD cluster can be backed up instead of generating the resource configuration for the cluster. **For this, backup the data directory of the ETCD cluster.** 

In managed k8s engine, ETCD data directory is not accessible. In such cases, backup the resource configuration.

`etcdctl` is a command line client for [etcd](https://github.com/coreos/etcd).

- etcdctl snapshot save -h and keep a note of the mandatory global options.
- Since our ETCD database is TLS-Enabled, the following options are mandatory:
- –cacert                verify certificates of TLS-enabled secure servers using this CA bundle
- –cert                    identify secure client using this TLS certificate file
- –endpoints=[127.0.0.1:2379] This is the default as ETCD is running on master node and exposed on localhost **2379.**
- –key                  identify secure client using this TLS key file

etcd certificates are **used for encrypted communication between etcd member peers, as well as encrypted client traffic**. The following certificates are generated and used by etcd and other processes that communicate with etcd: Peer certificates: Used for communication between etcd members.

## Velero

- Open-source
- Supports various plugins to backup the cluster to different storage locations like S3, Azure Blob Storage, etc.
- Download the binary and run the `velero install` command along with the storage plugin and credentials to create the Velero pod looking for backups in the storage destination.
- **Works in CLI only**
- **Runs a velero container in the cluster**
- We can define a TTL for the backups stored in the storage location.
- [Kubernetes Backup & Restore using Velero | ADITYA JOSHI | - YouTube](https://www.youtube.com/watch?v=_y0yGAbLknU)
- [Kubernetes Cluster Migration | Migrating Data Across Clusters | ADITYA JOSHI | - YouTube](https://www.youtube.com/watch?v=QWIk1UdIh5c)
- [Kubernetes Backups, Upgrades, Migrations - with Velero - YouTube](https://www.youtube.com/watch?v=zybLTQER0yY&t=923s)

---

### Take a snapshot -Backup Command

```jsx
root@controlplane:~# ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /opt/snapshot-pre-boot.db
```