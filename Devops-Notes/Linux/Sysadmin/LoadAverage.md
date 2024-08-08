Load average is a measure of the amount of computational work that a system performs.Load average is typically displayed as three numbers representing the average load over the last 1, 5, and 15 minutes.

### Example of Load Average Output

```shell
$ uptime
 10:20:30 up 10 days,  4:38,  2 users,  load average: 0.10, 0.20, 0.30
```

In this example:
- The load average over the last minute is `0.10`.
- The load average over the last 5 minutes is `0.20`.
- The load average over the last 15 minutes is `0.30`.

### Interpreting Load Average

- **Load Values**: Load values represent the number of processes waiting to be run or currently running. 
- If a system has 4 CPUs, a load average of `4.0` means that on average, each CPU is fully utilized.
- **Comparing Load to CPU Count**: To interpret these values accurately, compare them to the number of CPUs in the system. For example, on a system with 4 CPUs, a load average of `4.0` means the system is at full capacity. 
- A load average higher than `4.0` indicates more work than the system can handle comfortably, leading to delays.

### Commands to Check Load Average

1. **uptime**: Displays the current time, system uptime, number of users, and load average.
   ```shell
   $ uptime
   10:20:30 up 10 days,  4:38,  2 users,  load average: 0.10, 0.20, 0.30
   ```

2. **top**: Provides a dynamic, real-time view of the system's processes, including load average at the top.
   ```shell
   $ top
   top - 10:20:30 up 10 days,  4:38,  2 users,  load average: 0.10, 0.20, 0.30
   Tasks: 102 total,   1 running, 101 sleeping,   0 stopped,   0 zombie
   %Cpu(s):  0.3 us,  0.1 sy,  0.0 ni, 99.5 id,  0.1 wa,  0.0 hi,  0.0 si,  0.0 st
   ```

3. **cat /proc/loadavg**: Directly reads the load average from the `/proc` filesystem.
   ```shell
   $ cat /proc/loadavg
   0.10 0.20 0.30 1/102 12345
   ```

### Practical Example

Here's how you might script a check for high load average in a bash script:

```bash
#!/bin/bash

# Get the load average for the last 1 minute
#!/bin/bash

# Get the load average for the last 1 minute
LOAD_1=$(awk '{print $1}' /proc/loadavg)

# Define a threshold for high load
THRESHOLD=4.0

# Compare the load average with the threshold as it is a floating point number
if (( $(echo "$LOAD_1 > $THRESHOLD" | bc -l) )); then 
    echo "Load average is higher than threshold"
else 
    echo "Load average is normal"
fi

```

