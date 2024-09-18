In Linux, there are three primary types of streams:

### 1. Standard Input (STDIN)
- **Description**: This stream is used for input data to programs. By default, it reads input from the keyboard.
- **File Descriptor**: 0
- **Usage**: You can redirect input from files or other commands using the `<` operator. For example, `command < inputfile.txt` reads from `inputfile.txt` instead of the keyboard.

### 2. Standard Output (STDOUT)
- **Description**: This stream is used for output data from programs.
- **File Descriptor**: 1
- **Usage**: You can redirect output to files or other commands using the `>` operator. For example, `command > outputfile.txt` writes the output to `outputfile.txt`, overwriting it if it exists. To append to a file, you can use `>>`.

### 3. Standard Error (STDERR)
- **Description**: This stream is used for error messages and diagnostics from programs. Like STDOUT, it also sends output to the terminal by default.
- **File Descriptor**: 2
- **Usage**: You can redirect error messages to a file using `2>` or combine both STDOUT and STDERR using `&>` or by redirecting them separately.

### Summary of File Descriptors
| Stream        | Description                   | File Descriptor |
|---------------|-------------------------------|------------------|
| Standard Input (STDIN)  | Input to programs (default: keyboard) | 0                |
| Standard Output (STDOUT) | Output from programs (default: terminal) | 1                |
| Standard Error (STDERR)  | Error messages from programs (default: terminal) | 2                |

