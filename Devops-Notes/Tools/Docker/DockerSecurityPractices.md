
### **Dockershim**

Dockershim was a component in Kubernetes that allowed the use of Docker Engine as a container runtime. 
- It was introduced because Docker Engine was not compatible with the(CRI) when CRI was first released. 
- Dockershim acted as a bridge between Docker Engine and CRI, leading to its deprecation and removal in Kubernetes v1.24. 
- Users are encouraged to migrate to other CRI-compatible runtimes like containerd or CRI-O.

### **Scratch Images**

The `scratch` image is the most minimal base image in Docker, containing zero bytes. 
- It serves as the starting point for building other images. When you create a Docker image from `scratch`, you are essentially starting with an empty filesystem. 
- This is useful for creating lightweight images.

### **Alpine Images**
- Docker Alpine is a Dockerized version of Alpine Linux
- The Alpine image is extremely lightweight, typically under 3 MB, and uses less than 100 MB of RAM. It includes BusyBox for basic Linux commands and uses `musl libc` instead of the heavier `glibc`.

### **Docker Best Practices**

To build efficient and secure Docker images, follow these best practices:

- **Multi-Stage Builds:** 
- **Layer Caching:** 
- **Minimize Layers:** 
- **Use .dockerignore:** Exclude unnecessary files from the build context using a `.dockerignore` file.
- **Run as Non-Root:** 
- **Keep Images Small:** Use minimal base images like Alpine or `scratch`.

### **Docker Command Case Sensitivity**
Docker commands and file systems in Docker containers are case-sensitive, as Docker typically uses Linux-based filesystems like `overlayfs`. 
- This means that file names and commands must match the exact case. For example, `Dockerfile` and `dockerfile` would be considered different files. 
- If you need case insensitivity, you would have to use a filesystem that supports it, but this is generally not recommended due to potential compatibility issues. 
- Instead, it's better to standardize on a consistent case convention in your code and scripts.


## Security Concerns
- **Unauthorized Access**: Anyone with access can delete containers and volumes.
- **Malicious Usage**: Containers can be used for unauthorized activities like Bitcoin mining.
- **Privilege Escalation**: Attackers can gain root access through privilege escalation.
- **Socket Security**: The Docker daemon service runs on a Docker Unix socket, which is safer but still needs protection.

## First Level of Security: Securing the Docker Host

### Best Practices
- **Disable Root Users**: Prevent direct root access to the host.
- **SSH Authentication**: Use SSH keys for secure access.
- **Daemon Configuration**: Whitelist the IP and Ports in the `daemon.json`
- **TLS Certificates**: Secure communication using TLS certificates.
  - Set the environment variable `DOCKER_TLS=true`
  - Use port `2376` for encrypted traffic.
- Scan the images using Trivy.
- Docker Scan trust

### Example Configuration
```json
{
  "tls": true,
  "tlscert": "/path/to/server-cert.pem",
  "tlskey": "/path/to/server-key.pem",
  "tlsverify": true,
  "tlscacert": "/path/to/ca.pem",
  "hosts": ["tcp://0.0.0.0:2376"]
}
```

### Protect the Docker Daemon Socket
- **Default Unix Socket**: Docker runs through a non-networked Unix socket by default.
- **SSH Protection**: Use SSH to protect the Docker daemon socket.
  ```sh
  DOCKER_HOST=ssh://USER@HOST
  ```

### Regular Updates

### Use Docker Secrets
### User Namespace Remapping
- **Prevent Privilege Escalation**: Enable user namespace remapping to isolate container user accounts.
  ```sh
  dockerd --userns-remap=default
  ```