## Disk Usage Management



## Understanding the df command

| Filesystem | Size | Used | Available | Use% | Mounted on |
| --- | --- | --- | --- | --- | --- |
| /dev/sda1 | 2.00T | 1.00T | 1.00T | 50% | / |
| /dev/sda2 | 2.00T | 1.00T | 1.00T | 50% | /boot |


## Diving into the du command

The `du` (disk usage) command is used to estimate the space used by given files or directories. The `-h` option can be used for human-readable output, while the `-s` option can be used to provide a summarized result for directories.

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

## Cleaning Up Disk Space
1. **Remove Unnecessary Packages and Dependencies**:  you can use `apt-get autoremove` to remove unnecessary packages.

2. **Clear Package Manager Cache**: Clear cache using `yum clean`

3. **Find and Remove Large Files**: You can use the `find` command to locate file.

4. **Use a Disk Cleanup Utility**: Tools like `bleachbit` 



### Bash Script Example for Disk Usage Monitoring

```bash
#!/bin/bash


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