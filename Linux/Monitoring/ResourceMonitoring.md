
### 1. **`sar` (System Activity Reporter)**

**Overview:**

- `sar` is part of the **sysstat** package.

- **CPU Usage:**
  ```bash
  sar -u [interval] [count]
  ```
  - Shows CPU usage statistics. Without arguments, it displays data from the stored log files.
  
- **Memory Usage:**
  ```bash
  sar -r [interval] [count]
  ```
  - Displays memory and swap space utilization.

**Example Usage:**

- Monitor CPU usage every 5 seconds, 10 times:
  ```bash
  sar -u 5 10
  ```
  
- View CPU usage from a specific log file (e.g., for the 10th day):
  ```bash
  sar -u -f /var/log/sa/sa10
  ```


---

### 2. **`vmstat` (Virtual Memory Statistics)**

**Overview:**

- Reports information about processes, memory, paging, block I/O, traps, and CPU activity.
- Useful for identifying memory bottlenecks and performance issues.

**Key Features:**

- Provides real-time system statistics.
- Displays summary information in a concise format.
- Helps in detecting issues like memory swapping and excessive context switching.

**Common Commands:**

- **Basic Usage:**
  ```bash
  vmstat [interval] [count]
  ```
  - Without arguments, it displays a one-time report since the last reboot.

**Output Fields Explanation:**

- **Procs:**
  - `r`: Number of runnable processes (running or waiting for CPU).
  - `b`: Number of processes in uninterruptible sleep.

- **Memory:**
  - `swpd`: Amount of virtual memory used.
  - `free`: Amount of idle memory.
  - `buff`: Memory used as buffers.
  - `cache`: Memory used as cache.

- **Swap:**
  - `si`: Amount of memory swapped in from disk.
  - `so`: Amount of memory swapped to disk.

- **IO:**
  - `bi`: Blocks received from a block device (read).
  - `bo`: Blocks sent to a block device (write).

- **System:**
  - `in`: Number of interrupts per second, including clock.
  - `cs`: Number of context switches per second.

- **CPU:**
  - `us`: Time spent running non-kernel code (user time).
  - `sy`: Time spent running kernel code (system time).
  - `id`: Time spent idle.
  - `wa`: Time spent waiting for I/O.

**Example Usage:**

- Monitor system statistics every 2 seconds, indefinitely:
  ```bash
  vmstat 2
  ```
  
- Capture 5 reports at 1-second intervals:
  ```bash
  vmstat 1 5
  ```

**Advantages:**

- Quick overview of system performance.
- Helps in identifying if the system is CPU, memory, or I/O bound.

---

### 3. **`iostat` (Input/Output Statistics)**

**Overview:**

- Also part of the **sysstat** package.
- Monitors system input/output device loading.
- Useful for diagnosing performance issues related to disk I/O.

**Key Features:**

- Reports CPU statistics and I/O statistics for devices and partitions.
- Helps in identifying bottlenecks in disk subsystems.
- Provides information about the throughput of devices.

**Common Commands:**

- **Basic Usage:**
  ```bash
  iostat [options] [interval] [count]
  ```
  
- **Display Device Utilization Report:**
  ```bash
  iostat -d [interval] [count]
  ```
  
- **Display Extended Device Statistics:**
  ```bash
  iostat -x [interval] [count]
  ```
  
- **Combined CPU and Device Statistics:**
  ```bash
  iostat -c -d [interval] [count]
  ```

**Output Fields Explanation (for `-x` option):**

- **Device:** Name of the device (e.g., sda).
- **tps:** Transfers per second.
- **kB_read/s:** Kilobytes read per second.
- **kB_wrtn/s:** Kilobytes written per second.
- **await:** Average time (in milliseconds) for I/O requests issued to the device to be served.
- **%util:** Percentage of CPU time during which I/O requests were issued to the device (i.e., how busy the device was).

**Example Usage:**

- Monitor I/O statistics every 5 seconds:
  ```bash
  iostat -x 5
  ```
  
- Get a one-time report:
  ```bash
  iostat
  ```

**Advantages:**

- Helps in identifying disk bottlenecks.
- Provides detailed I/O statistics.

---

### 4. **`dstat`**

**Overview:**

- Combines the functionality of vmstat, iostat, netstat, and ifstat.
- Provides real-time system resource statistics.
- Flexible and customizable output.

**Key Features:**

- Displays system resources instantly.
- Supports plugins for extended functionality.
- Colorful output for easier reading.

**Common Commands:**

- **Basic Usage:**
  ```bash
  dstat [options] [delay [count]]
  ```
  
- **Monitor CPU, Disk, and Network:**
  ```bash
  dstat -cdng
  ```
  
- **Show all available statistics:**
  ```bash
  dstat -a
  ```

**Common Options:**

- `-c`: CPU stats.
- `-d`: Disk stats.
- `-n`: Network stats.
- `-g`: Page stats.
- `-m`: Memory stats.
- `-s`: Swap stats.
- `--top-cpu`: Show processes using the most CPU.
- `--top-io`: Show processes with highest I/O.

**Example Usage:**

- Monitor CPU, memory, and I/O every 2 seconds:
  ```bash
  dstat -cim 2
  ```
  
- Monitor everything:
  ```bash
  dstat -taf 2
  ```

**Advantages:**

- Combines multiple tools into one.
- Customizable and user-friendly.
- Good for real-time monitoring during troubleshooting.

---

### 5. **`pidstat`**

**Overview:**

- Part of the **sysstat** package.
- Reports statistics for Linux tasks (processes) managed by the kernel.
- Useful for monitoring specific processes over time.

**Key Features:**

- Monitors CPU usage, memory usage, I/O, and more per process.
- Can track threads (`-t` option).
- Can report on child processes (`-T CHILD`).

**Common Commands:**

- **CPU Usage per Process:**
  ```bash
  pidstat -u [interval] [count]
  ```
  
- **Memory Usage per Process:**
  ```bash
  pidstat -r [interval] [count]
  ```
  
- **I/O Statistics per Process:**
  ```bash
  pidstat -d [interval] [count]
  ```
  
- **Thread Statistics:**
  ```bash
  pidstat -t [interval] [count]
  ```
  
- **Process with Command Name:**
  ```bash
  pidstat -C [command] [options] [interval] [count]
  ```

**Output Fields Explanation:**

- **PID:** Process ID.
- **%CPU:** Percentage of CPU used by the process.
- **MINflt/s:** Minor faults per second.
- **Majflt/s:** Major faults per second.
- **VSZ:** Virtual Memory Size.
- **RSS:** Resident Set Size.
- **kB_rd/s:** Kilobytes read per second.
- **kB_wr/s:** Kilobytes written per second.
- **Command:** Name of the command/process.

**Example Usage:**

- Monitor CPU usage of all processes every 2 seconds:
  ```bash
  pidstat 2
  ```
  
- Monitor I/O of a specific process (e.g., `mysqld`):
  ```bash
  pidstat -d -C mysqld 2
  ```

**Advantages:**

- Detailed per-process statistics.
- Helps in pinpointing resource-hogging processes.
- Useful for performance tuning and debugging.

---

### 6. **`perf` (Performance Analysis Tools)**

**Overview:**

- `perf` is a powerful performance analysis tool for Linux.
- Provides a wide range of system profiling capabilities.
- Can analyze CPU performance counters, tracepoints, and more.

**Key Features:**

- **Performance Counters:** Access to hardware counters for CPU cycles, cache misses, etc.
- **Profiling:** Can profile applications to find bottlenecks.
- **Tracing:** Supports tracing of kernel functions and events.
- **Customizable Events:** Can monitor custom performance events.

**Common Commands:**

- **Record Performance Data:**
  ```bash
  perf record [options] [command]
  ```
  - Runs the specified command and records performance data.
  
- **Report Performance Data:**
  ```bash
  perf report
  ```
  - Generates a report from the data collected by `perf record`.

- **Top-like Live Monitoring:**
  ```bash
  perf top
  ```
  - Displays live performance data similar to `top`.

- **Statistical Summary:**
  ```bash
  perf stat [options] [command]
  ```
  - Runs the command and provides a summary of performance statistics.

**Example Usage:**

- Profile a program (e.g., `myapp`) and generate a report:
  ```bash
  perf record ./myapp
  perf report
  ```
  
- Monitor system-wide CPU usage live:
  ```bash
  perf top
  ```
  
- Get performance statistics for a command:
  ```bash
  perf stat ls -lR /
  ```

**Advantages:**

- Deep insight into system and application performance.
- Useful for identifying low-level performance issues.
- Can be used for both kernel and user-space profiling.

**Note:**

- `perf` requires appropriate permissions; it might need to be run as root or with capabilities set.
- Kernel debug symbols might be required for detailed kernel profiling.

---

### Summary for SRE Role

As an SRE, mastering these tools is essential for monitoring system performance, troubleshooting issues, and ensuring optimal system operation.

- **`sar`**: Best for collecting and analyzing historical system performance data.
- **`vmstat`**: Quick overview of system memory, processes, and CPU usage; helps in identifying immediate bottlenecks.
- **`iostat`**: Focuses on disk I/O performance; essential for diagnosing storage subsystem issues.
- **`dstat`**: Versatile tool combining multiple statistics; excellent for real-time monitoring.
- **`pidstat`**: Provides per-process statistics; crucial for identifying resource-intensive processes.
- **`perf`**: Advanced profiling tool; invaluable for in-depth performance analysis and optimization.

