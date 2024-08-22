## `.bashrc` and `.bash_profile`

Both `.bashrc` and `.bash_profile` are configuration files for the Bash shell.

### `.bashrc`

#### Purpose:
- The `.bashrc` file is executed for interactive non-login shells. 
- whenever you are logging in using a no login shell account it is executed but not when you are using user accounts to sshh to the server.

#### Common Uses:
- Setting up environment variables.
- Defining shell aliases.
- Customizing the shell prompt.
- Setting up command history options.
- Configuring command completion behavior.


### `.bash_profile`

#### Purpose:
- The `.bash_profile` file is executed for login shells. 
- This typically means it is run when you log in to the system (e.g., via SSH or console login). 
- It is used to set up the environment for the user session.

#### Common Uses:
- Setting environment variables (like `PATH`, `HOME`, etc.).
- Running scripts or commands that need to be executed only once at the start of the session.
- Sourcing `.bashrc` to ensure the settings in `.bashrc` are applied to login shells as well.

#### Example:
```bash
# ~/.bash_profile: executed by bash(1) for login shells.

# Source the user's bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Set user specific environment variables
export PATH=$PATH:$HOME/bin

# Run any custom startup scripts
if [ -f ~/startup.sh ]; then
    . ~/startup.sh
fi
```

### Difference Between `.bashrc` and `.bash_profile`

- **Execution Context:**
  - `.bashrc` is executed for interactive non-login shells (e.g., when opening a new terminal window).
  - `.bash_profile` is executed for login shells.

- **Typical Use Case:**
  - Use `.bashrc` for commands and configurations that should be applied to every interactive shell session.
  - Use `.bash_profile` for commands and configurations that should be applied only once at the start of a session.

### Ensuring Consistency

To ensure that the configurations in `.bashrc` are also applied to login shells, it is common practice to source `.bashrc` from within `.bash_profile`. 

### `.bash_profile` vs `.profile`

- **`.bash_profile`** is specific to the Bash shell.
- **`.profile`** is a more general configuration file that is read by many different shells (including Bash, KornShell, and Bourne shell).