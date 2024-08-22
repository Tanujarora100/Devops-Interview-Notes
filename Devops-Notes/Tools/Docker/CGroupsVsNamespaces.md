## cgroups vs. Namespaces in Linux

### cgroups (Control Groups)

**Description**:
Cgroups allow you to allocate, limit, and monitor the usage of system resources (e.g., CPU, memory, disk I/O, network bandwidth) among a collection of processes. 

**Key Features**:
- **Resource Limiting**: 
- **Prioritization**: 
- **Accounting**: Monitor and report resource usage.
- **Control**: 

**Use Cases**:
- **Resource Management**
- **Performance Isolation**

**Example**:
To limit a process to use only 50% of the CPU and 512MB of memory:
```bash
sudo cgcreate -g cpu,memory:/mygroup
sudo cgset -r cpu.shares=512 /mygroup
sudo cgset -r memory.limit_in_bytes=512M /mygroup
sudo cgexec -g cpu,memory:/mygroup /path/to/your/process
```

### Namespaces

**Description**:
Namespaces provide isolation by partitioning kernel resources so that one set of processes sees one set of resources while another set sees a different set. 
- They create isolated environments for processes

**Types of Namespaces**:
1. **Mount Namespace**: Isolates the set of mounted filesystems.
2. **UTS Namespace**: .
3. **IPC Namespace**: 
4. **Network Namespace**: Isolates network interfaces, IP addresses, routing tables, etc.
5. **PID Namespace**: Isolates process IDs.
6. **User Namespace**: Isolates user and group IDs.

**Key Features**:
- **Process Isolation**: 
- **Security**:


**Example**:
To create a new network namespace and run a process within it:
```bash
sudo ip netns add mynamespace
sudo ip netns exec mynamespace /path/to/your/process
```

### Comparison

| **Feature**         | **cgroups**                                                                 | **Namespaces**                                                     |
|---------------------|-----------------------------------------------------------------------------|--------------------------------------------------------------------|
| **Purpose**         | Resource management (CPU, memory, I/O, etc.)                                | Process isolation (mounts, network, PID, IPC, UTS, user)           |
| **Functionality**   | Limits how much resources processes can use                                 | Limits what processes can see and interact with                    |
| **Use Cases**       | Resource allocation, prioritization, accounting, control                    | Containers, security, development environments                     |
| **Key Commands**    | `cgcreate`, `cgset`, `cgexec`                                               | `unshare`, `ip netns`, `setns`                                     |
| **Hierarchy**       | Hierarchical, child cgroups inherit attributes from parent cgroups          | Hierarchical, processes in a namespace can create child namespaces |
| **Resource Types**  | CPU, memory, I/O, network bandwidth, devices, etc.                          | Mount points, network interfaces, PIDs, IPC resources, UTS, users  |
| **Example Tools**   | Docker, Kubernetes, systemd                                                 | Docker, LXC, systemd                                               |
