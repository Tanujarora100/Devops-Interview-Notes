
3. **What are the most commonly used shells in Linux?**
     - Bourne Shell (sh)
     - Bourne-Again Shell (bash)
     - C Shell (csh)
     - Korn Shell (ksh)
     - Z Shell (zsh)

4. **What is the purpose of the shebang (`#!`) line in a shell script?**
   - The shebang line specifies the interpreter that should be used to execute the script. For example, `#!/bin/bash` indicates that the script should be run with the Bash shell.

5. **Explain the difference between single quotes (`'`) and double quotes (`"`).**
   - Single quotes preserve the literal value of each character within them, while double quotes allow for variable expansion and command substitution.
6. **What is the use of the `case` statement in shell scripting?**
   - The `case` statement is used for multi-way branching, allowing the execution of different commands based on the value of a variable.

7. **What are positional parameters in shell scripting?**
   - Positional parameters are variables that hold the values passed to a script or function as command-line arguments, denoted by `$1`, `$2`, etc.

8. **How do you read input from a user in a shell script?**
   - You can use the `read` command to take input from the user. For example: `read -p "Enter your name: " name`.

11. **What is the difference between `$*` and `$@`?**
    - `$*` treats all positional parameters as a single word, while `$@` treats each positional parameter as a separate word. This distinction is significant when passing parameters to other commands or scripts.

    1. **`$*`**:
        - When you use `$*`, all positional parameters are treated as a single word, separated by the first character of the `IFS` (Internal Field Separator) variable.
        - By default, `IFS` is set to a space, tab, and newline character.
        - For example, if you have `$1="hello"`, `$2="world"`, and `$3="shell"`, then `"$*"` will be interpreted as `"hello world shell"`.

    2. **`$@`**:
        - `$@` treats each positional parameter as a separate word or argument.
        - Using the same example as above, `"$@"` will be interpreted as `"hello" "world" "shell"`.
        - When passing `$@` to another command or script, each positional parameter will be treated as a separate argument.


        ```bash
        #!/bin/bash

        args=("$@")
        echo "Calling another script with arguments:"
        echo "Using \$*: ./other_script.sh $*"
        echo "Using \$@: ./other_script.sh "$@""
        ```


        ```bash
        ./script.sh "hello world" "shell scripting"
        ```

        Using `$*` will pass the arguments as a single string:

        ```
        Calling another script with arguments:
        Using $*: ./other_script.sh hello world shell scripting
        ```

        While using `$@` will pass each argument as a separate word:

        ```
        Calling another script with arguments:
        Using $@: ./other_script.sh "hello world" "shell scripting"
        ```

12. **Explain how to debug a shell script.**
    - You can debug a shell script by using the `set -x` command to enable debugging output

