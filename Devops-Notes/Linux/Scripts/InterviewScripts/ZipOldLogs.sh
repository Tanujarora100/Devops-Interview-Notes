log_dir="/var/log/myapp"
for log_file in "$log_dir"/*.log; do 
    if [ -n "$log_file" ]; then
        echo "Processing $log_file..."
        mv "$log_file" "$log_file.old"
        gzip "$log_file.old"
        echo "Moved and gzipped $log_file to $log_file.old.gz"
    fi
done 