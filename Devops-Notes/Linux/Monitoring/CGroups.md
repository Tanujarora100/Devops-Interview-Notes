Control groups, commonly known as **cgroups**, are a feature of the Linux kernel that allows for the management of resource allocation among a collection of processes.
- Feature of linux kernel
- Management of resource allocation across processes.
- Resource Limits like CPU and memory for a process.
- Priority of resource allocation across processes
- Each cgroup has multiple processes but these have multiple controllers which check the CPU and Memory Limits.




### Subsystems
Cgroups utilize various subsystems to manage resources, including:

- **cpu**: Controls CPU access for tasks.
- **memory**: Sets limits on memory usage and generates reports on memory consumption.
- **blkio**: Manages input/output access to block devices.
- **devices**: Regulates access to devices by tasks.
- **freezer**: Suspends or resumes tasks in a cgroup.
