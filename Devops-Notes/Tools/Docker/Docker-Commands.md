
## Difference between ADD and COPY

### COPY
- It is a straightforward file copy operation.
- **Example**: `COPY . /app`

### ADD
- It can also fetch remote URLs and extract tarballs.
- **Example**: `ADD http://example.com/file.tar.gz /tmp/`

## Difference between ENTRYPOINT and CMD

### CMD
- **Function**: Specifies the default command and parameters for the container. 
- It can be overridden at runtime.
- **Example**: `CMD ["python3", "app.py"]`

### ENTRYPOINT
- **Function**: Configures a container that will run as an executable. It provides the default application to run.
- **Example**: `ENTRYPOINT ["python3", "app.py"]`

### Combined Usage
- When using both ENTRYPOINT and CMD, the CMD values are passed as arguments to the ENTRYPOINT command. 
- ENTRYPOINT is often used when you want to define a container as an executable and CMD to provide default arguments.