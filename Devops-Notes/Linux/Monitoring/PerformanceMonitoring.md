
## Swap space

Swap space is an area on your hard drive used as virtual memory when your system runs out of physical RAM. 
- It allows your system to continue running even when it has exhausted all available RAM, but it can negatively impact performance, as accessing data from the hard drive is slower than accessing it from RAM.

```
free -h
```

## Monitor RAM usage
`free -h`

I. Resident Set Size (RSS)
- RSS indicates the current memory usage of a process.
- It excludes swap memory but includes all stack and heap memory.

II. Virtual Set Size (VSZ)
- VSZ represents the total memory allocated to a **process at its initiation**.
- It encompasses memory that might be swapped out, unused, or shared from libraries.

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

```bash
ps -e -o pid,vsz,comm= | sort -n -k 2 -r | head 10
```

### Finding RAM Usage of a Specific Process

```bash
ps -o %mem,rss,vsize,cmd -C nginx
```
