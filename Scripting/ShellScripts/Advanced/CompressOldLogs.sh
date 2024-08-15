#!/bin/bash
log_directory="/path/to/your/logs"
archive_directory="/path/to/your/archives"
log_file="/path/to/your/compression.log"

mkdir -p "$archive_directory"
if [[ ! -d "$log_directory" ]]; then
  echo "$(date): Error: Log directory $log_directory does not exist." >> "$log_file"
  exit 1
fi
archive_name="$archive_directory/logs-$(date +%F).tar.gz"
log_files=$(find "$log_directory" -type f -name "*.log")

if [[ -z "$log_files" ]]; then
  echo "$(date): No .log files found in $log_directory." >> "$log_file"
else
  tar -czf "$archive_name" $log_files 2>> "$log_file"

  if [[ $? -eq 0 ]]; then
    echo "$(date): Compressed the following files into $archive_name:" >> "$log_file"
    echo "$log_files" >> "$log_file"
  else
    echo "$(date): Error: Failed to compress log files." >> "$log_file"
  fi
fi
