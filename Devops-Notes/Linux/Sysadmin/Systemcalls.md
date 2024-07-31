
## Types of System Calls
1. **Process Management System Calls**:
   - **`fork()`**: Creates a new process by duplicating the calling process. The new process is called the child process.
   - **`exec()`**: Replaces the current process image with a new process image. This is used to run a different program.
   - **`wait()`**: Makes the parent process wait until one of its child processes terminates.
   - **`exit()`**: Terminates the calling process and returns an exit status to the parent process.

2. **File Management System Calls**:
   - **`open()`**: Opens a file and returns a file descriptor.
   - **`read()`**: Reads data from a file into a buffer.
   - **`write()`**: Writes data from a buffer to a file.
   - **`close()`**: Closes an open file descriptor.

3. **Device Management System Calls**:
   - **`ioctl()`**: Performs device-specific input/output operations that are not covered by standard system calls.

4. **Network Management System Calls**:
   - System calls related to networking, such as `socket()`, `bind()`, and `connect()`, allow for communication over networks.

5. **System Information System Calls**:
   - **`getpid()`**: Returns the process ID of the calling process.
   - **`alarm()`**: Sets a timer to send a signal after a specified number of seconds.
   - **`sleep()`**: Suspends the execution of the calling process for a specified duration.

## Common Commands Related to System Calls
  ``` bash
  strace <command>
  ```
  ``` bash
  lsof
  ```
  The main differences between the `fork()` and `exec()` system calls in Linux are:

1. **Process Creation**:
   - `fork()` creates a new process by duplicating the calling process. The new process is called the child process.
   - `exec()` replaces the current process image with a new process image. It loads the program into the current process space and runs it from the entry point.

2. **Parent-Child Relationship**:
   - After `fork()`, both the parent and child processes continue to execute simultaneously.
   - After `exec()`, the calling process is replaced by the new process, so there is no longer a parent-child relationship.

3. **Return Values**:
   - `fork()` returns the process ID of the child process to the parent, and 0 to the child.
   - `exec()` only returns if an error occurs, in which case it returns -1.

4. **Memory and State**:
   - The child process created by `fork()` is an exact duplicate of the parent process, including memory and state.
   - `exec()` replaces the current process image with a new process image, so the memory and state of the calling process are discarded.

5. **Usage**:
   - `fork()` is often used to create child processes that will perform different tasks.
   - `exec()` is commonly used after `fork()` to replace the child process with a different program.

In summary, `fork()` creates a new process while preserving the original process, while `exec()` replaces the current process with a new one. They are often used together to create and execute new processes in Linux.
