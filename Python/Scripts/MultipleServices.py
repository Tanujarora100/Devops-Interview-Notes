import os 
def check_service_status():
    services=["nginx","docker","ssh","jenkins"]
    for service in services:
        service_status= f"systemctl status {service}"
        # Check if service is running
        current_status=os.system(service_status)
        if current_status==0:
            print(f"{service} service is running.")
        else:
            service_restart_command= f"sudo systemctl restart {service}"
            restart_status= os.system(service_restart_command)
            if  restart_status==0:
                print(f"{service} service restarted successfully.")
            else:
                print(f"Failed to restart {service} service.")
        print("---------------------------------------------")

check_service_status()
