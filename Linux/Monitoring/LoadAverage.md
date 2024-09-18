Load average is a measure of the amount of computational work that a system performs.
- Load average is typically displayed as three numbers representing the average load over the last `1, 5, and 15 minutes`.

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

### Commands to Check Load Average

1. **uptime**: 

2. **top**: 
3. **cat /proc/loadavg**: Directly reads the load average from the `/proc` filesystem.
   ```shell
   $ cat /proc/loadavg
   0.10 0.20 0.30 1/102 12345
   ```

### Practical Example


```bash
#!/bin/bash

# Get the load average for the last 1 minute
#!/bin/bash

load_average=$(awk '{print $1}' /proc/loadavg)

# Define the threshold
threshold=1.0
# Compare the load average to the threshold
if (( $(echo "$load_average > $threshold" | bc -l) )); then
  echo "Load average is high"
else
  echo "Load average is normal"
fi


```

