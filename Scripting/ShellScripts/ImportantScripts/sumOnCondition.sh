awk '$2 > 80 {sum += $2} END {print "Total Sum of Grades > 80:", sum}' grades.txt
