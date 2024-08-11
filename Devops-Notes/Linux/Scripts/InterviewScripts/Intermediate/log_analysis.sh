#!/bin/bash 
LOG_LOCATION="/var/log/logfile.log"
if [ ! -f "$LOG_LOCATION" ]; then
    echo " No Log file specified"
    exit 1
fi 
total_lines=$(wc -l < "$LOG_LOCATION")
echo "Total lines in the log file: $total_lines"
error_lines =$(grep -c "Error" "$LOG_LOCATION")
echo "Number of error lines: $error_lines"
unique_ip=$(awk '{print $1}' "$LOG_FILE" | sort | uniq | wc -l)
#TOP 5 Most Frequent 
echo "TOP 5 Most Frequent IP" 
awk '{print $1}' "$LOG_LOCATION" | sort | uniq -c | sort -nr | head -5

# ### Example

# Assume `LOGFILE` contains the following lines:

# ```
# 192.168.1.1 - - [01/Jan/2023:10:00:00 +0000] "GET /index.html HTTP/1.1" 200 1234
# 192.168.1.2 - - [01/Jan/2023:10:01:00 +0000] "GET /about.html HTTP/1.1" 200 2345
# 192.168.1.1 - - [01/Jan/2023:10:02:00 +0000] "GET /contact.html HTTP/1.1" 200 3456
# 192.168.1.3 - - [01/Jan/2023:10:03:00 +0000] "GET /index.html HTTP/1.1" 200 4567
# 192.168.1.2 - - [01/Jan/2023:10:04:00 +0000] "GET /index.html HTTP/1.1" 200 5678
# 192.168.1.1 - - [01/Jan/2023:10:05:00 +0000] "GET /about.html HTTP/1.1" 200 6789
# ```

# Running the command will proceed as follows:

# 1. **`awk '{print $1}' "$LOGFILE"`**:
#     ```
#     192.168.1.1
#     192.168.1.2
#     192.168.1.1
#     192.168.1.3
#     192.168.1.2
#     192.168.1.1
#     ```

# 2. **`| sort`**:
#     ```
#     192.168.1.1
#     192.168.1.1
#     192.168.1.1
#     192.168.1.2
#     192.168.1.2
#     192.168.1.3
#     ```

# 3. **`| uniq -c`**:
#     ```
#           3 192.168.1.1
#           2 192.168.1.2
#           1 192.168.1.3
#     ```

# 4. **`| sort -nr`**:
#     ```
#           3 192.168.1.1
#           2 192.168.1.2
#           1 192.168.1.3
#     ```

# 5. **`| head -5`**:
#     ```
#           3 192.168.1.1
#           2 192.168.1.2
#           1 192.168.1.3
#     ```

# In this example, `192.168.1.1` is the most frequent IP address, appearing 3 times, followed by `192.168.1.2` with 2 appearances, and `192.168.1.3` with 1 appearance. The script correctly identifies and lists the top 5 most frequent occurrences.