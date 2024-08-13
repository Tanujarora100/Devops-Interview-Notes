read -p "Enter the firstNumber" num1
read -p "Enter the secondNumber" num2
if [ $num2 -eq 0 ]; then 
    echo " Cannot be divided by zero"
    exit 1
else
    result=$((num1 % num2))
    echo "The result is $result"
fi