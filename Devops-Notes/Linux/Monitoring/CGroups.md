Control groups, commonly known as **cgroups**, are a feature of the Linux kernel that allows for the management of resource allocation.
- Feature of linux kernel
- Management of resource allocation across processes.
- Resource Limits like CPU and memory for a process.
- **Priority** of resource allocation across processes
- Each cgroup has multiple processes but these have multiple controllers which check the CPU and Memory Limits.

### Subsystems
Cgroups utilize various subsystems to manage resources, including:
- **cpu**:
- **memory**: 
- **blkio**: Manages input/output access to block devices.
- **devices**: Regulates access to devices by tasks.
- **freezer**: Suspends or resumes tasks in a cgroup.

## Scenario for Using cgroups

### Scenario: Isolating Resources for a Web Server and a Database Server

### Steps to Implement cgroups

1. **Create cgroups for the Web Server and Database Server**:
   ```bash
   sudo cgcreate -g cpu,memory:/webserver
   sudo cgcreate -g cpu,memory:/dbserver
   ```

2. **Set Resource Limits**:
   - **Web Server**:
     ```bash
     sudo cgset -r cpu.shares=512 /webserver
     sudo cgset -r memory.limit_in_bytes=1G /webserver
     ```
   - **Database Server**:
     ```bash
     sudo cgset -r cpu.shares=1024 /dbserver
     sudo cgset -r memory.limit_in_bytes=2G /dbserver
     ```

3. **Assign Processes to cgroups**:
   - Start the web server within the `webserver` cgroup:
     ```bash
     sudo cgexec -g cpu,memory:/webserver /path/to/webserver
     ```
   - Start the database server within the `dbserver` cgroup:
     ```bash
     sudo cgexec -g cpu,memory:/dbserver /path/to/dbserver
     ```
