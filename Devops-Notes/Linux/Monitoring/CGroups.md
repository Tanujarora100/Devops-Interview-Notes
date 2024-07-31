Control groups, commonly known as **cgroups**, are a feature of the Linux kernel that allows for the management of resource allocation among a collection of processes.


### Key Features
- **Resource Limits**: Administrators can set limits on how much of a resource (e.g., memory, CPU) a process can use.
  
- **Prioritization**: Cgroups allow for prioritizing resource allocation among different processes
- **Control**: System administrators can manage the state of processes within a cgroup.

## Structure and Hierarchy

Cgroups are organized hierarchically, similar to the process tree in Linux. However, unlike the single tree structure of processes, multiple independent hierarchies of cgroups can exist simultaneously. 
- Each cgroup can be associated with various subsystems (also known as controllers) that manage specific resources, such as CPU, memory, and I/O.

### Subsystems
Cgroups utilize various subsystems to manage resources, including:

- **cpu**: Controls CPU access for tasks.
- **memory**: Sets limits on memory usage and generates reports on memory consumption.
- **blkio**: Manages input/output access to block devices.
- **devices**: Regulates access to devices by tasks.
- **freezer**: Suspends or resumes tasks in a cgroup[2][3][4].

## Practical Applications
Cgroups are crucial for container technologies like Docker and Kubernetes, where multiple processes run within isolated environments. They help enforce resource limits and ensure that containers do not consume more than their fair share of system resources, thus maintaining overall system stability and performance.

