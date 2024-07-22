
To view all currently defined environment variables, use the `printenv` command:

```bash
printenv
```

### HISTSIZE
Determines the maximum number of commands stored in the shell's command history. This feature is useful for recalling and executing previous commands. View its value with:

```bash
echo $HISTSIZE
```

### HOME

Specifies the path to the current user's home directory, a central location for user-specific files and configurations. Check its value using:

```bash
echo $HOME
```

### PWD

PWD (Present Working Directory): Contains the path of the current directory that the shell is operating in. Display your current directory with:

```bash
echo $PWD
```

### HOSTNAME

Stores the system's network name, used for identification over a network. To see the current hostname:

```bash
echo $HOSTNAME
```

### PATH

A colon-separated list of directories where the shell looks for executable files. When a command is issued, the shell searches these directories in order to find and execute the command. View the current PATH with:

```bash
echo $PATH
```

## Shell Variables

Shell variables are local to the shell instance and are used to store temporary data and control shell functions. Unlike environment variables, shell variables are not inherited by child processes and are typically used to manage internal shell settings or hold temporary values for scripts and commands.

Examples include:

- **PS1**: Defines the shell prompt appearance.
- **IFS (Internal Field Separator)**: Determines how the shell recognizes word boundaries.

To create or modify a shell variable, simply assign a value to a name:

```bash
myvar="Hello, World!"
```

To view the value stored in a shell variable, use the echo command:

```bash
echo $myvar
```

