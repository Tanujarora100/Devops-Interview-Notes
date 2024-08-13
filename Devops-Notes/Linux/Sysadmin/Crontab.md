### Comparison: Cron vs Anacron
#### 1. **Functionality**

- **Cron**:
  - used for systems which are continously running.
  - Cron jobs are defined in crontab files, which can be user-specific or system-wide.

- **Anacron**:
  - Used when we need to run the job even if the system is not running.
  - Maintains a timestamp file to compare the current time with the execution time.
  - Anacron jobs are defined in a configuration file (usually `/etc/anacrontab`), and it can run jobs **daily, weekly, or monthly**.
  - It does not have so much customization of scheduled as the normal cron job.

#### 2. **Execution Timing**

- **Cron**:
  - If a job is missed (e.g., if the system is down), it will not run until the next scheduled time.

- **Anacron**:
  - Checks if a job was supposed to run while the system was off and executes it when the system starts up.

#### 3. **Configuration Files**

- **Cron**:
  -  accessible via the `crontab -e` command.
  - System-wide jobs can be found in `/etc/crontab` or in files within `/etc/cron.d/`.

- **Anacron**:
  - Configuration is typically found in `/etc/anacrontab`

### FAQ
1. **Infrequently Used Systems**: 
2. **Guaranteed Execution of Periodic Tasks**:
5. **Backup and Maintenance Tasks**:
2. **How does Anacron manage scheduling?**
    - Anacron maintains a timestamp file (**`/var/spool/anacron`**). .

7. **Explain the format of a crontab entry.**
        ```bash
        minute hour day month day_of_week command
        ```