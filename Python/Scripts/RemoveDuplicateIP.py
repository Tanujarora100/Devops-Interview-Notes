import os
RESULT_LOCATION = "/Users/tanujarora/Desktop/Projects/Devops/Python/Final_Result.txt"
def remove_duplicate_ip():
    FILE_LOCATION = "/Users/tanujarora/Desktop/Projects/Devops/Python/IP.txt"
   
    with open(FILE_LOCATION, "r") as file:
        unique_ips=set()
        for line in file:
            cleaned_ip=line.strip()
            unique_ips.add(cleaned_ip)
    with open(RESULT_LOCATION,'w') as result_file:
        for ip in unique_ips:
            result_file.write(f"{ip}\n")

def read_file():
    with open(RESULT_LOCATION,'r') as result:
        for line in result:
            print(line.strip(),end='\n')
remove_duplicate_ip()
read_file()