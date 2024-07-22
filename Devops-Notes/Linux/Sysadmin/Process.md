
Processes in a system can be broadly categorized into two types:
* **Shell Job**: A shell job is a process that is started from a user's command line interface, or shell. It is often interactive, requiring input from the user, and provides output directly to the user's console.

* **Daemon**: In contrast, a daemon is a background process, usually initiated at system startup and runs with elevated privileges. It does not interact directly with the user interface but operates silently.
## Process Management Commands

I. Basic Process Listing

```bash
ps -ef
```

This outputs a list of all currently running processes, showing the process ID (PID), terminal associated with the process (TTY), CPU time (TIME), and the executable name (CMD).
```
ps -e --format uid,pid,ppid,%cpu,cmd
```

```
ps fax
```

This displays the process hierarchy in a tree structure, showing parent-child relationships.

Sample Output:

```
PID TTY      STAT   TIME COMMAND
  2 ?        S      0:00 [kthreadd]
/-+- 3951 ?        S      0:07  \_ [kworker/u8:2]
...
```

```
ps -o
```
## Process life cycle

The life cycle of a process in an operating system is a critical concept. The provided diagram illustrates the various stages a process goes through:

```
                        +---------+
                        |         |
                        | Created |
                        |         |
                        +----+----+
                             |
                             | Schedule
                             v
                        +----+----+
                        |         |
                        | Running |
               -------- |         | ----------
             /          +----+----+            \
           /  Error           |        Complete  \ 
          v                   |                   v
  +-------+-----+     +-------+-------+     +---------+
  |             |     |               |     |         |
  | Terminated  |<----| Interrupted   |<----|  Exit   |
  |             |     |               |     |         |
  +-------------+     +---------------+     +---------+
```

- `Created`: The process enters the system. It's allocated with necessary resources but is not yet running.
- `Running`: The process is actively executing on the CPU.
- `Interrupted`: The process is temporarily stopped, either to let other processes run or because it is waiting for an input or an event.
- `Exit`: The process has completed execution and is ready to be removed from the system.
- `Terminated`: An error or an explicit kill command leads to the process being forcefully stopped.

## Process Spawning

Process spawning is a fundamental aspect of any operating system. It's the action of creating a new process from an existing one. Whether it's running a command from a terminal or a process creating another, spawning processes is a routine operation in system workflows.

* The first process that initiates when a system boots up is assigned Process ID (PID) 1. 

* This initial process is known as `systemd` or `init`, based on the Linux distribution in use. 

* Being the first process, it acts as the parent to all subsequently spawned processes.

Spawning a process can be as straightforward as executing a command or running a program from the command line. For instance:

```bash
echo "Hello, world!"
```


### Terminating Processes by PID

Each process, upon its creation, is assigned a unique Process ID (PID). To stop a process using its PID, the `kill` command is used. For instance:

```bash
kill 12345
```
In this example, a termination signal is sent to the process with PID 12345, instructing it to stop execution.

### Terminating Processes by Name

If you don't know a process's PID, but you do know its name, the `pkill` command is handy. 

```bash
pkill process_name
```

### Specifying Termination Signals

The `kill` and `pkill` commands provide the option to specify the type of signal sent to a process. For example, to send a SIGINT signal (equivalent to Ctrl+C), you can use:

```bash
kill -SIGINT 12345
```


| Signal | Value | Description |
| --- | --- | --- |
| `SIGHUP` | (1) | Hangup detected on controlling terminal or death of controlling process |
| `SIGINT` | (2) | Interrupt from keyboard; typically, caused by `Ctrl+C` |
| `SIGKILL` | (9) | Forces immediate process termination; it cannot be ignored, blocked, or caught |
| `SIGSTOP` | (19) | Pauses the process; cannot be ignored |
| `SIGCONT` | (18) | Resumes paused process |


### Special PID Values in `kill`

When using the `kill` command, special PID values can be used to target multiple processes:

- **`-1`**: Sends the signal to all processes the user has permission to signal, except the process itself and process ID 1 (the init process).
- **`0`**: Sends the signal to all processes in the same process group as the calling process.
- **Negative values less than -1**: Sends the signal to all processes in the process group with the absolute value of the given number. For example, `kill -2 -SIGTERM` sends the SIGTERM signal to all processes in the process group with PGID 2.

These special values allow for more flexible management of processes and process groups, especially in scenarios where you need to signal multiple related processes at once. Here are examples of using these special values:

```bash
# Sending SIGTERM to all processes the user can signal
kill -1 -SIGTERM

# Sending SIGTERM to all processes in the same process group as the current process
kill 0 -SIGTERM

# Sending SIGTERM to all processes in the process group with PGID 2
kill -2 -SIGTERM
```

Using these special values carefully can help manage and control process groups effectively.

## Methods for Searching Processes

In a Linux environment, various methods are available to search for processes, depending on the granularity of information you require or your personal preference. The search can be done using commands such as `ps`, `grep`, `pgrep`, and `htop`.

### Searching Processes with `ps` and `grep`

The `ps` command displays a list of currently running processes. To search for processes by name, you can combine `ps` with the `grep` command. The following command:

```bash
ps -ef | grep process_name
```

searches and displays all processes containing the specified name (process_name in this example). Here, ps -ef lists all processes, and grep process_name filters the list to show only the processes with the specified name.

### Searching Processes with pgrep


```bash
pgrep chromium
```



## Foreground and Background Jobs

The tasks running on your system can be in one of two states, either running in the 'foreground' or in the 'background'. These two states provide flexibility for multi-tasking and efficient system utilization.

- **Foreground Process**: A process is said to be running in the foreground if it is actively executing and interacting with the terminal's input and output. These are generally the tasks that you've initiated and are currently interacting with in your terminal.

- **Background Process**: On the contrary, a background process operates without directly interacting with the terminal's input and output. This ability allows you to run multiple processes simultaneously, without having to wait for each one to complete before starting another.

```
+------------------------+
|                        |
| Start Job in Foreground|
|                        |
+-----------+------------+
            |
            | Ctrl+Z or bg
            v
+-----------+------------+
|                        |
|   Job Running in       |
|   Background           |
|                        |
+-----------+------------+
            |
            | fg or job completes
            v
+-----------+------------+
|                        |
|   Job Completes        |
|   or Returns to        |
|   Foreground           |
|                        |
+------------------------+
```

### Controlling Job Execution

You can direct a program to run in the background right from its initiation by appending an ampersand `&` operator after the command. Consider the following example:

```bash
sleep 1000 &
```

Here, the sleep command will operate in the background, waiting for 1000 seconds before terminating. The output typically resembles this:

```bash
[1] 3241
```

The number enclosed in square brackets (like `[1]`) represents the job number, while the subsequent number (like 3241) is the process ID (PID).

### Job and Process Management Commands

To view all active jobs in the system, use the `jobs` command.

If you wish to bring a background job to the foreground, utilize the fg command followed by the job number. For instance, to bring job number 3 to the foreground, you would use:

```bash
fg 3
```

To convert a foreground process to a background process, you can use Ctrl+Z. This operation pauses the process and allows you to resume it in the background using the bg command followed by the job number. For instance:

```bash
bg 1
```

This command will resume job number 1 in the background. Understanding and managing foreground and background jobs helps to increase productivity and efficiency when working in a shell environment.
