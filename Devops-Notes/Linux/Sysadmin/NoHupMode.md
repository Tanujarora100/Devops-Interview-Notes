
## What is Nohup?
- **Nohup** stands for "no hang up." It prevents the processes from receiving the SIGHUP (Signal Hang Up) signal, which is sent when a terminal session ends.

```bash
nohup command [arguments] &
```
## Advantages of Using Nohup

1. **Persistence**: Keeps processes running even after the user logs out.
2. **Output Management**: Allows for easy redirection of output.
3. **Background Execution**: Enables running long tasks without occupying the terminal.

