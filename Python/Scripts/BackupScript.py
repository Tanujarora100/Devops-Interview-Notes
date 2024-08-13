import os 
import datetime 
def backup_script():
    directory_path = "/Users/tanujarora/Desktop/Projects/Devops/Python"
    backup_path="/Users/tanujarora/Desktop/Projects/Devops/Backup"
    if not os.path.exists(backup_path):
        os.makedirs(backup_path)
    current_datetime= datetime.datetime.now().strftime("%Y-%m-%d")
    backup_filename=f"backup_{current_datetime}.tar.gz"
    backup_completepath=os.path.join(backup_path, backup_filename)
    # Create a tar archive of the directory
    command=f"tar -czf {backup_completepath} {directory_path}"
    os.system(command)
    print(f"Backup completed: {backup_completepath}")


backup_script()

