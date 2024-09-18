#!/bin/bash
read -p "Enter the first number" num1
read -p "Enter the second number" num2

# Check if the numbers are integers
if ! [[ $num1 =~ ^-?[0-9]+$ ]] || ! [[ $num2 =~ ^-?[0-9]+$ ]]; then
    echo "Error: Both numbers must be integers."
    exit 1
fi

final_ans= $(($num2 - $num1))
echo "$final_ans"