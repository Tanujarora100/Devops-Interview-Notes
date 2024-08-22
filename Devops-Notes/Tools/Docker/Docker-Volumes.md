

## BIND MOUNTS
### Sharing Local Files with Docker Containers
### **Volume vs. Bind Mounts**

**Volumes**:
- **Usage**: Ideal for persisting data generated or modified inside the container.
- **Behavior**: Managed by Docker, volumes are stored in a part of the host filesystem which is managed by Docker (`/var/lib/docker/volumes/` on Linux).
- **Advantages**: Volumes are easier to back up, migrate, and manage compared to bind mounts.

**Bind Mounts**:
- **Usage**: Suitable for sharing specific files or directories from the host with the container, such as configuration files or source code.
- **Behavior**: Directly maps a host directory or file to a container directory or file.
- **Advantages**: Provides real-time access to host files, making it ideal for development environments.

#### **Using Bind Mounts**

To share files between the host and a container using bind mounts, you can use the `-v` (or `--volume`) and `--mount`

**Example with `-v` Flag**:
```sh
docker run -v /HOST/PATH:/CONTAINER/PATH -it nginx
```
- **Behavior**: If the host directory does not exist, Docker will create it automatically.
**Example with `--mount` Flag**:
```sh
docker run --mount type=bind,source=/HOST/PATH,target=/CONTAINER/PATH,readonly nginx
```
- **Behavior**: Provides more advanced features and control. 
- If the host directory does not exist, Docker will generate an error.

### **File Permissions**

When using bind mounts, it's crucial to ensure Docker has the necessary permissions to access the host directory. You can specify read-only (`:ro`) or read-write (`:rw`) access:

**Read-Write Access**:
```sh
docker run -v /HOST/PATH:/CONTAINER/PATH:rw nginx
```

**Read-Only Access**:
```sh
docker run -v /HOST/PATH:/CONTAINER/PATH:ro nginx
```

#### **Example: Sharing a Directory**

1. **Create a Directory and File on Host**:
   ```sh
   mkdir public_html
   cd public_html
   echo "<html><body><h1>Hello from Docker!</h1></body></html>" > index.html
   ```

2. **Run Container with Bind Mount**:
   ```sh
   docker run -d --name my_site -p 8080:80 -v $(pwd):/usr/local/apache2/htdocs/ httpd:2.4
   ```