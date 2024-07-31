#!/bin/bash

# Function to reverse a string
reverse_string() {
    local input="$1"
    echo "$input" | rev
}

# Read input from the user
echo "Enter a string to reverse:"
read input_string

# Reverse the string
reversed_string=$(reverse_string "$input_string")

# Output the reversed string
echo "Reversed string: $reversed_string"
#END OF THE SCRIPT