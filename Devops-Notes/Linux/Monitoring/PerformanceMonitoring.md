## Performance Monitoring

### Understanding Usage Statistics

Usage statistics provide insights into how your system resources are being utilized. These statistics include CPU usage, RAM usage, and disk usage. An increase in these statistics may be due to various factors, such as running resource-intensive applications, insufficient system resources, or a misconfiguration in your system settings.
### Top: Real-Time System Monitoring

```bash
top
```


## Swap space

Swap space is an area on your hard drive used as virtual memory when your system runs out of physical RAM. 
- It allows your system to continue running even when it has exhausted all available RAM, but it can negatively impact performance, as accessing data from the hard drive is slower than accessing it from RAM.

To view the amount of swap space available on your system, use the `free` command:

```
free -h
```

Here's an example of what the output might look like:

```
              total        used        free      shared  buff/cache   available
Mem:            8G         3.2G        2.1G       101M      2.7G        4.4G
Swap:           2G         1.2G        800M
```


## Monitor RAM usage
`free -h`

I. Resident Set Size (RSS)

- RSS indicates the current memory usage of a process.
- It excludes swap memory but includes all stack and heap memory.
- Memory from shared libraries is counted, but only if the pages are physically present in memory.
- Some memory can be shared among applications, so the sum of RSS values can exceed the actual RAM.

II. Virtual Set Size (VSZ)

- VSZ represents the total memory allocated to a process at its initiation.
- It encompasses memory that might be swapped out, unused, or shared from libraries.
- This is a broader measure of a process's memory footprint.

### Example: Calculating RSS and VSZ

Consider a process with these details:

- Current usage: 450K (binary code), 800K (shared libraries), 120K (stack and heap).
- Initial allocation: 600K (binary code), 2200K (shared libraries), 150K (stack and heap).

Calculations:

I. **RSS:** Total physical memory usage.

- RSS = Binary Code + Shared Libraries + Stack/Heap
- RSS = 450K + 800K + 120K = 1370K

II. **VSZ:** Total memory allocation at start.

- VSZ = Initial Binary Code + Initial Shared Libraries + Initial Stack/Heap
- VSZ = 600K + 2200K + 150K = 2950K

### Identifying Top Memory-Consuming Processes

To list the 10 processes consuming the most RAM, you can use the command:

```bash
ps -e -o pid,vsz,comm= | sort -n -k 2 -r | head 10
```

### Finding RAM Usage of a Specific Process

In addition to monitoring overall RAM usage, it's often necessary to track the memory usage of a specific process. 

For example to check the memory usage of a process named nginx:

```bash
ps -o %mem,rss,vsize,cmd -C nginx
```

