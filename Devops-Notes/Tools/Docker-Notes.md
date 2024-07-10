
## Difference between ADD and COPY

### COPY
- **Function**: Copies files from the host to the container. It is a straightforward file copy operation.
- **Example**: `COPY . /app`

### ADD
- **Function**: Similar to COPY but has some additional features. It can also fetch remote URLs and extract tarballs.
- **Example**: `ADD http://example.com/file.tar.gz /tmp/`

## Difference between ENTRYPOINT and CMD

### CMD
- **Function**: Specifies the default command and parameters for the container. It can be overridden at runtime.
- **Example**: `CMD ["python3", "app.py"]`

### ENTRYPOINT
- **Function**: Configures a container that will run as an executable. It provides the default application to run.
- **Example**: `ENTRYPOINT ["python3", "app.py"]`

### Combined Usage
- When using both ENTRYPOINT and CMD, the CMD values are passed as arguments to the ENTRYPOINT command. 
- ENTRYPOINT is often used when you want to define a container as an executable and CMD to provide default arguments.

## Docker Networks

### List Docker Networks
To see a list of all available Docker networks, use the `docker network ls` command.
```sh
docker network ls
```

### Create a Custom Bridge Network
You can create a custom bridge network to isolate containers from the host network. This is useful when you want containers to communicate with each other privately.
```sh
docker network create my_custom_network
```

### Create a Container on a Specific Network
When running a container, you can specify the network it should connect to using the `--network` flag.
```sh
docker run --name container1 --network my_custom_network -d nginx
```

### Inspect Network Details
To view details about a specific network, use the `docker network inspect` command.
```sh
docker network inspect my_custom_network
```

### Create a Container with a Specific IP Address
You can specify a static IP address for a container within a custom bridge network using the `--ip` flag.
```sh
docker run --name container2 --network my_custom_network --ip 172.18.0.10 -d nginx
```

### Connect an Existing Container to a Network
You can also connect an existing container to a network using the `docker network connect` command.
```sh
docker network connect my_custom_network container1
```

### Disconnect a Container from a Network
To disconnect a container from a network, use the `docker network disconnect` command.
```sh
docker network disconnect my_custom_network container1
```

### Remove a Custom Network
To remove a custom network, use the `docker network rm` command.
```sh
docker network rm my_custom_network
```

## Docker Network Types

### Bridge Network (bridge)
- **Description**: The default network mode for Docker containers when no network is specified. It creates an internal private network on the host, and containers can communicate with each other using container names.
- **Use Cases**: Suitable for most containerized applications where containers need to communicate on the same host.

### Host Network (host)
- **Description**: Containers share the host network stack, making them directly accessible from the host and other containers without any network address translation (NAT).
- **Use Cases**: High-performance scenarios where containers need to bind to specific host ports, but it lacks network isolation.

### Overlay Network (overlay)
- **Description**: Used in Docker Swarm mode to facilitate communication between containers running on different nodes in a swarm cluster. 
- **It uses VXLAN encapsulation for inter-node communication.**
- **Use Cases**: Multi-host, multi-container applications orchestrated with Docker Swarm.

### Macvlan Network (macvlan)
- **Description**: Allows containers to have their own MAC addresses and appear as separate devices on the host network. Each container has a unique network identity.
- **Use Cases**: When containers need to be directly on an external network, e.g., connecting containers to physical networks or VLANs.

### None Network (none)
- **Description**: Containers on this network have no network connectivity. It's often used for isolated testing or when the container only needs loopback connectivity.
- **Use Cases**: Limited use cases, primarily for debugging or security purposes.

### Custom Bridge Network (user-defined bridge)
- **Use Cases**: Isolating containers, customizing DNS settings, or when you need multiple bridge networks on the same host.

### Overlay2 Network (overlay2)
- **Description**: Introduced in Docker 20.10, the Overlay2 network driver is optimized for container-to-container communication within the same network namespace.

### Cilium Network (cilium)
- **Description**: Cilium is an open-source networking and security project that offers advanced networking features, including API-aware network security and load balancing.
- **Use Cases**: Advanced networking and security requirements, often in Kubernetes environments.

### Gossip Network (gossip)
- **Description**: Used in Docker Swarm mode to enable gossip-based cluster management for container orchestration and service discovery.

## Docker Compose

Docker Compose is a tool for defining and running multi-container Docker applications. It allows you to define your application's services, networks, and volumes in a single `docker-compose.yml` file, making it easier to manage complex Docker setups.

### Example `docker-compose.yml`
```yaml
version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
  backend:
    image: node:14
    working_dir: /app
    volumes:
      - ./backend:/app
    command: npm start
```

### Docker Compose Commands

- **Start Services**: 
  ```sh
  docker-compose up -d
  ```

- **Stop Services**: 
  ```sh
  docker-compose down
  ```

- **View Logs**: 
  ```sh
  docker-compose logs
  ```

- **Build Services**: Build or rebuild services (useful when you make changes to your Dockerfile or source code).
  ```sh
  docker-compose build
  ```

- **Scale Services**: You can scale services by specifying the desired number of replicas.
  ```sh
  docker-compose up -d --scale backend=2
  ```

- **Execute Commands in a Running Container**: 
  ```sh
  docker-compose exec backend sh
  ```

# How to Secure the Docker Daemon

## Security Concerns
- **Unauthorized Access**: Anyone with access can delete containers and volumes.
- **Malicious Usage**: Containers can be used for unauthorized activities like Bitcoin mining.
- **Privilege Escalation**: Attackers can gain root access through privilege escalation.
- **Socket Security**: The Docker daemon service runs on a Docker Unix socket, which is safer but still needs protection.

## First Level of Security: Securing the Docker Host

### Best Practices
- **Disable Root Users**: Prevent direct root access to the host.
- **SSH Authentication**: Use SSH keys for secure access.
- **Daemon Configuration**: Add IP addresses to the `daemon.json` file to restrict access and use a secured port.
- **TLS Certificates**: Secure communication using TLS certificates.
  - Set the environment variable `DOCKER_TLS=true`.
  - Use `tlsverify`, `tlscert`, and `tlskey` for encryption (note: these do not guarantee authentication).
  - Use port 2376 for encrypted traffic.

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

## Second Level of Security: Adding Authentication

### Enabling Authentication
- **TLS Verify Flag**: Enable authentication by setting the `tlsverify` flag.
- **CA Certificate**: Use a CA certificate for authentication.
![alt text](image.png)
### Example Commands
```sh
# Start Docker daemon with TLS and authentication
dockerd --tlsverify --tlscacert=ca.pem --tlscert=server-cert.pem --tlskey=server-key.pem -H=0.0.0.0:2376

# Connect to Docker daemon securely
docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem -H=$HOST:2376 version
```

## Additional Security Measures

### Protect the Docker Daemon Socket
- **Default Unix Socket**: Docker runs through a non-networked Unix socket by default.
- **SSH Protection**: Use SSH to protect the Docker daemon socket.
  ```sh
  DOCKER_HOST=ssh://USER@HOST
  ```

### Rootless Mode
- **Run Docker as Non-Root**: Use rootless mode to run Docker daemon and containers as an unprivileged user.

### Regular Updates
- **Keep Software Updated**: Regularly update the host OS, Docker Engine, and kernel to protect against known vulnerabilities.

### Limit Inter-Container Communication
- **Disable ICC**: Launch Docker daemon with ICC disabled to restrict container communication.
  ```sh
  dockerd --icc=false
  ```

### Use Docker Secrets
- **Manage Sensitive Data**: Use Docker Secrets to securely manage sensitive data like passwords and tokens.
  ```yaml
  version: "3.8"
  secrets:
    my_secret:
      file: ./super-secret-data.txt
  services:
    web:
      image: nginx:latest
      secrets:
        - my_secret
  ```

### User Namespace Remapping
- **Prevent Privilege Escalation**: Enable user namespace remapping to isolate container user accounts.
  ```sh
  dockerd --userns-remap=default
  ```
### Multi-Stage Docker File
```docker
# Stage 1: Build the React application
FROM node:22.4.0-alpine3.19 as staging
WORKDIR /app
COPY package*.json /app/
RUN npm install 
COPY . .
RUN npm run build


FROM nginx:stable-bookworm as nginx 
LABEL maintainer_email="tanujarora2703@gmail.com"

COPY --from=staging /app/build /usr/share/nginx/html
RUN chown -R nginx:nginx /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
