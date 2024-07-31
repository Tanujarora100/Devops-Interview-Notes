
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
Kernel modules in Linux are pieces of code that can be dynamically loaded into and unloaded from the kernel at runtime, allowing for the extension of kernel functionality without the need for a system reboot. This modular approach enhances flexibility and efficiency in managing system resources and device drivers.

## Kernel Modules

- **Dynamic Loading**: Kernel modules can be loaded and unloaded as needed.
- **File Format**: `.ko`

## Common Commands for Managing Kernel Modules
1. **Loading a Module**: 
   - `modprobe <module_name>`
2. **Unloading a Module**:
   - `rmmod <module_name>`

3. **Listing Loaded Modules**:
   - `lsmod`

4. **Viewing Module Information**:
   - `modinfo <module_name>`

5. **Checking Kernel Messages**:
   - `dmesg`: This command displays kernel-related messages.



## Advantages of Using Kernel Modules

- **Modularity**: Kernel modules allow for a modular kernel design, which can be easier to maintain and debug.
  
- **Memory Efficiency**: Modules are loaded only when needed, which can save memory compared to having all drivers compiled into the kernel.

- **Ease of Updates**: Updating a module does not require a full kernel rebuild, making it simpler to manage device drivers and other kernel extensions.
