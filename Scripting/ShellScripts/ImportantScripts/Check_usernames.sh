#!/bin/bash
INPUT_FILE="/path/to/usernames.txt"
OUTPUT_FILE="/path/to/nonexistent_users.txt"

> "$OUTPUT_FILE"

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file '$INPUT_FILE' does not exist." | mail -s "UNIDENTIFIED USERNAMES" tanujarora2703@gmail.com
    exit 1
fi

while IFS= read -r LINE; do
    USERNAME=$(echo "$LINE" | awk '{print $1}')
    if ! id "$USERNAME" >/dev/null 2>&1; then
        echo "$USERNAME" >> "$OUTPUT_FILE"
    fi
done < "$INPUT_FILE"
if [[ -s "$OUTPUT_FILE" ]]; then
    echo "The following users do not exist:"
    mail -s "UNIDENTIFIED USERNAMES" tanujarora2703@gmail.com < "$OUTPUT_FILE"
else
    echo "All users exist in the system." | mail -s "UNIDENTIFIED USERNAMES" tanujarora2703@gmail.com
fi
