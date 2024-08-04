import os 
service_status= f'systemctl nginx status'

# Check if Nginx service is running
command_result=os.system(service_status)
if command_result==0:
    print("Nginx service is running.")
else :
    service_restart_command=f'systemctl restart nginx'
    restart_status=os.system(service_restart_command)
    if restart_status!=0:
        print("Failed to restart Nginx service.")
    else:
        print("Nginx service restarted successfully.")

