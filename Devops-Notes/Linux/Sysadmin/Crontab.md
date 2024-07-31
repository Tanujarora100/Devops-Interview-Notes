### Comparison: Cron vs Anacron
#### 1. **Functionality**

- **Cron**:
  - used for systems which are continously running.
  - Cron jobs are defined in crontab files, which can be user-specific or system-wide.

- **Anacron**:
  - Used when we need to run the job even if the system is not running.
  - It is useful for laptops or desktop systems that are not always on.
  - Anacron jobs are defined in a configuration file (usually `/etc/anacrontab`), and it can run jobs **daily, weekly, or monthly**.
  - It does not have so much customization of scheduled as the normal cron job.

#### 2. **Execution Timing**

- **Cron**:
  - Executes jobs at precise times as specified in the crontab.
  - If a job is missed (e.g., if the system is down), it will not run until the next scheduled time.

- **Anacron**:
  - Checks if a job was supposed to run while the system was off and executes it when the system starts up.
  - It ensures that periodic jobs are run even if the system is not continuously running.

#### 3. **Configuration Files**

- **Cron**:
  -  accessible via the `crontab -e` command.
  - System-wide jobs can be found in `/etc/crontab` or in files within `/etc/cron.d/`.

- **Anacron**:
  - Configuration is typically found in `/etc/anacrontab`

#### When to use Anacron.
1. **Infrequently Used Systems**: Machine that is not running every time.
2. **Guaranteed Execution of Periodic Tasks**: Anacron is designed to run tasks that may have been missed due to the system being down.
5. **Backup and Maintenance Tasks**: For tasks like system updates, backups, and log rotations that are critical but can be run at a later time if missed.
