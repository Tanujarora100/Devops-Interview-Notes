import os

def check_if_logs_contain_hostname():
    instances = ["webserver1", "webserver2", "webserver3"]
    LOG_PATH = '/var/log'
    HOST_FILE = "/Users/tanujarora/Desktop/Projects/Devops/Python/hostnames.txt"  # Specify the output file
    for server in instances:
        server_logs = f"{LOG_PATH}/{server}.log"
        if os.path.exists(server_logs):
            os.system(f"cat {server_logs} | grep -i {server}")
            print("---------------------------------------------")
            with open(HOST_FILE, 'a') as host_file: 
                host_file.write(f"{server}\n")
                print(f"Hostname '{server}' saved to {HOST_FILE}")
            print("---------------------------------------------")
        else:
            print(f"{server_logs} does not exist.")
    print("---------------------------------------------")
check_if_logs_contain_hostname()