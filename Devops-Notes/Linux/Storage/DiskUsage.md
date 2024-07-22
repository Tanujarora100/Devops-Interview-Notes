## Disk Usage Management



## Understanding the df command

| Filesystem | Size | Used | Available | Use% | Mounted on |
| --- | --- | --- | --- | --- | --- |
| /dev/sda1 | 2.00T | 1.00T | 1.00T | 50% | / |
| /dev/sda2 | 2.00T | 1.00T | 1.00T | 50% | /boot |


## Diving into the du command

The `du` (disk usage) command is used to estimate the space used by given files or directories. The `-h` option can be used for human-readable output, while the `-s` option can be used to provide a summarized result for directories. For instance, executing `du -sh .` will display the total size of the current directory in a human-readable format.


```bash
du -x / | sort -nr | head -10
```

Here's an example of what the output might look like:

```
10485760    /usr
5120000     /var
2097152     /lib
1024000     /opt
524288      /boot
256000      /home
128000      /bin
64000       /sbin
32000       /etc
16000       /tmp
```

In this command, `du -x /` estimates the size of each directory in the root filesystem. `sort -nr` sorts these estimates in numerical order and reverses the output to display the largest sizes first. Finally, `head -10` truncates the output to only the top 10 lines, thereby showing the 10 largest directories.

## The ncdu Command

For a more visual representation of disk usage, you might consider using `ncdu` (NCurses Disk Usage).


```
--- / -----------------------------------------------------------------------
    4.6 GiB [##########] /usr
    2.1 GiB [####      ] /var
  600.0 MiB [#         ] /lib
  500.0 MiB [#         ] /opt
  400.0 MiB [          ] /boot
  300.0 MiB [          ] /sbin
  200.0 MiB [          ] /bin
  100.0 MiB [          ] /etc
   50.0 MiB [          ] /tmp
   20.0 MiB [          ] /home
   10.0 MiB [          ] /root
    5.0 MiB [          ] /run
    1.0 MiB [          ] /srv
    0.5 MiB [          ] /dev
    0.1 MiB [          ] /mnt
    0.0 MiB [          ] /proc
    0.0 MiB [          ] /sys
 Total disk usage: 8.8 GiB  Apparent size: 8.8 GiB  Items: 123456
```

## Cleaning Up Disk Space
1. **Remove Unnecessary Packages and Dependencies**: Over time, your system may accumulate packages that are no longer needed. These can be safely removed to free up space. On a Debian-based system like Ubuntu, you can use `apt-get autoremove` to remove unnecessary packages.

2. **Clear Package Manager Cache**: Clear cache using `yum clean`

3. **Find and Remove Large Files**: You can use the `find` command to locate files over a certain size and then decide if they need to be kept. For example, `find / -type f -size +100M -delete` will find files larger than 100 MB.

4. **Use a Disk Cleanup Utility**: Tools like `bleachbit` can be used to clean up.



### Bash Script Example for Disk Usage Monitoring

```bash
#!/bin/bash

# Script to monitor disk usage and report

# Set the path for the log file
DATE= $(date)
LOG_FILE="/var/log/disk_usage_report_$DATE.log"

# Get disk usage with df
echo "Disk Usage Report - $(date)" >> "$LOG_FILE"
echo "---------------------------------" >> "$LOG_FILE"
df -h >> "$LOG_FILE"

# Get top 10 directories consuming space
echo "" >> "$LOG_FILE"
echo "Top 10 Directories by Size:" >> "$LOG_FILE"
du -x / | sort -nr | head -10 >> "$LOG_FILE"

# # Send the log via email
# MAIL_RECIPIENT="recipient@example.com"
# MAIL_SUBJECT="Disk Usage Report"
# mail -s "$MAIL_SUBJECT" "$MAIL_RECIPIENT" < "$LOG_FILE"

# End of script
```