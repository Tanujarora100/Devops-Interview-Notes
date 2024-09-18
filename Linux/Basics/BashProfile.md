
## `.bashrc`

#### Purpose:
- The `.bashrc` file is executed for interactive non-login shells. 
- whenever you are logging in using a no login shell account it is executed but not when you are using user accounts to sshh to the server.

#### Common Uses:
- Setting up environment variables.
- Defining shell aliases.
- Customizing the shell prompt.
- Setting up command history options.
- Configuring command completion behavior.


## `.bash_profile`

#### Purpose:
- The `.bash_profile` file is executed for login shells. 
- This typically means it is run when you log in to the system (e.g., via SSH or console login). 
- It is used to set up the environment for the user session.

#### Common Uses:
- Setting environment variables (like `PATH`, `HOME`, etc.).
- Running scripts or commands that need to be executed only once at the start of the session.
- Sourcing `.bashrc` to ensure the settings in `.bashrc` are applied to login shells as well.

### Ensuring Consistency

To ensure that the configurations in `.bashrc` are also applied to login shells, it is common practice to source `.bashrc` from within `.bash_profile`. 

### `.bash_profile` vs `.profile`

- **`.bash_profile`** is specific to the Bash shell.
- **`.profile`** is a more general configuration file that is read by many different shells.