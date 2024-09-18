## LOGGING IN TERRAFORM

### 1. **Enable Logging with `TF_LOG`**

Terraform provides different logging levels, which control the verbosity of the log output. The levels are as follows (in increasing order of verbosity):

- `TRACE`: Shows detailed internal information, including full API requests and responses. This is the most verbose level.
- `DEBUG`: Shows more detailed debugging information, useful for diagnosing issues with Terraform's execution.
- `INFO`: Shows general information about Terraform's execution. This is useful for a higher-level overview without too much detail.
- `WARN`: Shows warnings that don’t stop execution but might require attention.
- `ERROR`: Shows only errors that caused Terraform to fail.

You can set the log level by exporting the `TF_LOG` environment variable before running Terraform commands.

#### Example of setting the log level to `DEBUG`:

- **Linux/macOS**:
  ```bash
  export TF_LOG=DEBUG
  ```

### 2. **Redirect Logs to a File**

If the log output is too verbose or you want to save it for later, you can redirect the logs to a file by setting another environment variable called `TF_LOG_PATH`.

#### Example of redirecting logs to a file:

- **Linux/macOS**:
  ```bash
  export TF_LOG=DEBUG
  export TF_LOG_PATH="terraform.log"
  ```
