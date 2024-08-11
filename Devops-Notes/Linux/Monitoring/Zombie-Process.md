A zombie process, also known as a defunct process, is a process that has completed execution but still has an entry in the process table. This entry remains because the process's parent has not yet read its exit status.

### How a Zombie Process is Created

1. **Process Termination:**
   - When a child process finishes execution, it exits and sends a `SIGCHLD` signal to its parent process.
   - The child process enters a "terminated" state, waiting for the parent process to read its exit status using the `wait()` system call or one of its variants.

2. **Parent Process Responsibilities:**
   - The parent process is responsible for calling `wait()`, `waitpid()`, or a similar function to read the exit status of the child process.
   - This reading of the exit status is known as `"reaping" the child `process. 
   - When the parent process reaps the child, the operating system removes the child's entry from the process table.

3. **Zombie State:**
   - If the parent process does not call `wait()` to read the child's exit status, the child remains in the process table as a zombie.
   - This means the process has released its resources but retains an entry in the process table to hold its exit status and PID for the parent to read.

### Why Zombie Processes Occur

- **Parent Process Neglect:** The parent process may neglect to call `wait()`, either due to a programming error, oversight, or because it has not yet executed the appropriate code.
- **Orphaned Child Processes:** When a parent process terminates, its children become orphans. 
    - These orphaned processes are adopted by the `init` process (or `systemd` on modern Linux systems), which automatically reaps them.
    - Hence, orphaned processes typically do not remain zombies for long.

### Identifying Zombie Processes

You can identify zombie processes using commands like `ps` or `top`:

- **Using `ps`:**
  ```sh
  ps aux | grep 'Z'
  ```
  Look for processes with a `Z` status, indicating they are zombies.

- **Using `top`:**
  ```sh
  top
  ```
  In `top`, zombie processes are listed with a `Z` state.

### Handling Zombie Processes

1. **Parent Process Modification:**
   - Ensure the parent process correctly handles the `SIGCHLD` signal and calls `wait()` to reap child processes.
   - Modify the parent process to include a signal handler for `SIGCHLD` that calls `wait()`.

2. **Manual Reaping:**
   - If you have control over the parent process, you can manually send a `SIGCHLD` signal to prompt it to reap the zombie processes.

3. **Terminating the Parent Process:**
   - If modifying the parent process is not possible, terminating the parent process can sometimes resolve zombie processes, as the `init` process will adopt and reap them.
   ```sh
   kill -SIGTERM <parent_process_pid>
   ```


### CHECK ZOMBIE PROCESS
```bash
ps aux | grep 'Z'
```
```bash
ps -eo pid,ppid,stat,cmd | grep 'Z'
```