
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

## Docker Networks

### List Docker Networks
```sh
docker network ls
```

### Create a Custom Bridge Network
```sh
docker network create my_custom_network
```

### Create a Container on a Specific Network
```sh
docker run --name container1 --network my_custom_network -d nginx
```

### Inspect Network Details
```sh
docker network inspect my_custom_network
```

### Create a Container with a Specific IP Address
```sh
docker run --name container2 --network my_custom_network --ip 172.18.0.10 -d nginx
```

### Connect an Existing Container to a Network
```sh
docker network connect my_custom_network container1
```

### Disconnect a Container from a Network
```sh
docker network disconnect my_custom_network container1
```

### Remove a Custom Network
```sh
docker network rm my_custom_network
```

## Docker Network Types

### Bridge Network (bridge)
- **Description**: The default network mode for Docker containers when no network is specified. 
- It creates an internal private network on the host, and containers can communicate with each other using container names.
- **Use Cases**: Suitable for most containerized applications where containers need to communicate on the same host.

### Host Network (host)
- **Description**: Containers share the host network stack, **making them directly accessible from the host** and other containers without any network address translation (NAT).
- **Use Cases**: High-performance scenarios where containers need to bind to specific host ports, but it lacks network isolation.

### Overlay Network (overlay)
- **Description**: Used in Docker Swarm mode to facilitate communication between containers running on different nodes in a swarm cluster. 
- **It uses VXLAN encapsulation for inter-node communication.**
- **Use Cases**: Multi-host, multi-container applications orchestrated with Docker Swarm.

### Macvlan Network (macvlan)
- **Description**: Allows containers to have their own MAC addresses and **appear as separate devices on the host network**. 
- Each container has a unique network identity.
- **Use Cases**: When containers need to be directly on an external network, e.g., connecting containers to physical networks or VLANs.

### None Network (none)
- **Description**: Containers on this network have no network connectivity. 
- It's often used for isolated testing or when the container only needs loopback connectivity.
- **Use Cases**: Limited use cases, primarily for debugging or security purposes.

### Custom Bridge Network (user-defined bridge)
- **Use Cases**: Isolating containers, customizing DNS settings, or when you need multiple bridge networks on the same host.

### Overlay2 Network (overlay2)
- **Description**: Introduced in `Docker 20.10`, the Overlay2 network driver is optimized.

### Cilium Network (cilium)
- **Description**: Cilium is an open-source networking and security project that offers advanced networking features
  - API-aware network 
  - security and load balancing.
- **Use Cases**: Advanced networking and security requirements, often in Kubernetes environments.

### Gossip Network (gossip)
- **Description**: Used in Docker Swarm mode to enable gossip-based cluster management for container orchestration and service discovery.

## Docker Compose

Docker Compose is a tool for defining and running multi-container Docker applications. 
- It allows you to define your application's services, networks, and volumes in a single `docker-compose.yml` file, making it easier to manage complex Docker setups.

### Example `docker-compose.yml`
```yaml
version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    depends_on:
     - mongo_database
  backend:
    image: node:14
    working_dir: /app
    volumes:
      - ./backend:/app
    command: npm start
  mongo_database:
   image: mongo 
   ports:
     - "27017:27017"
   environment:
     MONGO_INIT_USERNAME='USERNAME'
     MONGO_INIT_PASSWORD='PASSWORD'
```

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
USER nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
## How Docker Daemon Communicates with Docker Client

Docker uses a client-server architecture where the Docker client and Docker daemon communicate to manage and execute Docker containers.
   - Client issue commands like `docker build`, `docker pull`.
  -  Docker daemon (`dockerd`) is a background process 
   - These Communicate over the REST API on Socket `/var/run/docker.sock`
   - Need to create a TCP Socket if the docker daemon and docker client are on remote servers.

### **Example Communication Flow**
   - The Docker client translates command into an API request.
   - The Docker client sends the API request to the Docker daemon over (Unix socket or TCP).
   - The Docker daemon receives the API request, processes it

### **Security Considerations**

- **Authentication and Authorization**
  - Docker supports various authentication methods username/password, client certificates, token-based authentication

- **Enabling Remote Access via TCP Socket**
  ```json
  {
    "hosts": ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2375"]
  }
  ```
  To ensure that Docker containers automatically restart when the host is rebooted, you can use Docker's built-in restart policies. Here are the steps to achieve this:

### **1. Enable Docker Service on Boot**

```sh
sudo systemctl enable docker
```
### **2. Set Restart Policies for Containers**

- **no**: Do not automatically restart the container (default).
- **on-failure[:max-retries]**: Restart the container if it exits due to an error. Optionally, limit the number of restart attempts.
- **always**: Always restart the container if it stops.
- **unless-stopped**: Always restart the container unless it is explicitly stopped.
```sh
docker run -d --restart always your_image
```
#### **Using `docker update` Command**
To update the restart policy of an existing container, use the `docker update` command:
```sh
docker update --restart always your_container_id
```
### **3. Using Docker Compose**

If you are using Docker Compose, you can specify the restart policy in the `docker-compose.yml` file:

```yaml
version: '3.8'
services:
  your_service:
    image: your_image
    restart: always
```

#### Charactertics of Docker Image
- Rules for docker container
- runtime, libraries, environment variables
- Immutable
- Layered Structure
- Read only template

#### Image from Existing Image

1. **Create a Dockerfile**:
3. **Build the Docker Image**:
1. **Run a Container from an Existing Image**:
   - Start a container from an existing image:
     ```sh
     docker run -it ubuntu:latest /bin/bash
     ```
2. **Make Changes to the Container**:
3. **Commit the Changes to Create a New Image**:
   - Find the container ID by running `docker ps`:
     ```sh
     docker ps
     ```
   - Commit the changes to create a new image:
     ```sh
     docker commit <container_id> my_custom_image
     ```

### Monitoring 
- Docker events
- Docker logs
- Docker inspect
- Docker network
- Entrypoint

#### How to do Canary Deployment Using Docker?
- Step 1: Create Docker Services
- Create two versions of your application service, one for the stable version and one for the canary version.
```docker
docker service create --name myapp_stable --replicas 3 myapp:stable
docker service create --name myapp_canary --replicas 1 myapp:canary
```
- Step 2: Configure Load Balancing
- Use a reverse proxy like Traefik or NGINX to route a small percentage of traffic to the canary service. 
- Traefik Configuration: Create a traefik.toml file to configure Traefik.
```yaml
[entryPoints]
  [entryPoints.http]
    address = ":80"

[http]
  [http.routers]
    [http.routers.myapp]
      rule = "Host(`myapp.local`)"
      service = "myapp"

  [http.services]
    [http.services.myapp.loadBalancer]
      [[http.services.myapp.loadBalancer.servers]]
        url = "http://myapp_stable:80"
      [[http.services.myapp.loadBalancer.servers]]
        url = "http://myapp_canary:80"
        weight = 1
      [[http.services.myapp.loadBalancer.servers]]
        url = "http://myapp_stable:80"
        weight = 9
```

```docker
docker service create --name traefik --constraint=node.role==manager --publish 80:80 --mount type=bind,source=/path/to/traefik.toml,target=/traefik.toml traefik:latest
```
- Step 4: Monitor and Adjust Traffic
Monitor the canary deployment closely.
## Docker Build Context

The Docker build context is a crucial concept in Docker image creation. It refers to the set of files and directories that are accessible to the Docker engine during the build process. 
-  When you run the `docker build` command.

#### **Types of Build Contexts**

1. **Local Directory**
   - The most common build context is a local directory. When you specify a local directory as the context, Docker includes all files and subdirectories within that directory.
   - Example:
     ```sh
     docker build -t myimage .
     ```
     Here, the `.` specifies the current directory as the build context.

2. **Remote URL**
   - You can also specify a remote URL, such as a Git repository, as the build context. Docker will clone the repository and use its contents as the context.
   - Example:
     ```sh
     docker build -t myimage https://github.com/myrepo/myproject.git
     ```

3. **Tarball**
   - A tarball can be used as a build context by piping its contents to the `docker build` command.
   - Example:
     ```sh
     tar -czf - . | docker build -t myimage -
     ```

#### **Using the Build Context in Dockerfile**

Within the Dockerfile, you can use instructions like `COPY` and `ADD` to include files from the build context into the image.

- **COPY**: Copies files from the build context to the image.
  ```dockerfile
  COPY src/ /app/src/
  ```
- **ADD**: Similar to `COPY`, but also supports URLs and tar file extraction.
  ```dockerfile
  ADD https://example.com/file.tar.gz /app/
  ```

#### **Optimizing the Build Context**

- **.dockerignore**: Functions similarly to `.gitignore`, specifying patterns for files and directories to exclude.
  ```plaintext
  node_modules
  *.log
  ```

#### **Empty Build Context**

In some cases, you may not need to include any files from the local filesystem. You can use an empty build context by passing a Dockerfile directly via standard input.

- Example:
  ```sh
  docker build - < Dockerfile
  ```

#### **Multiple Build Contexts**

With Dockerfile `1.4 and Buildx v0.8+, Docker now supports multiple build contexts`. This allows you to use files from different local directories as part of your build process.

- Example:
  ```sh
  docker buildx build --build-context app1=app1/src --build-context app2=app2/src .
  ```
### Optimizing Bind Mounts for Large Projects

#### **1. Use `.dockerignore` to Exclude Unnecessary Files**

#### **2. Use Read-Only Bind Mounts When Possible**

- **Purpose**: Improve security and performance by restricting write access to the bind mount.
- **Implementation**:
  - Add `readonly` option to the bind mount.
  - Example:
    ```sh
    docker run -d \
      --name devtest \
      --mount type=bind,source="$(pwd)"/target,target=/app,readonly \
      nginx:latest
    ```

#### **5. Optimize File Access Patterns**
- **Implementation**:
  - Organize project files to minimize the number of files in the bind mount.
  - Use caching strategies to reduce the frequency of file access.

#### **6. Use Docker Volumes for Persistent Data**

- **Purpose**: Use Docker volumes for data that needs to persist beyond the lifecycle of a container. Volumes are managed by Docker and provide better performance and flexibility.
- **Implementation**:
  - Create and use Docker volumes for data persistence.
  - Example:
    ```sh
    docker volume create my_data
    docker run -d \
      --name devtest \
      --mount source=my_data,target=/app/data \
      nginx:latest
    ```

#### **8. Use Multi-Stage Builds**

- **Implementation**:
  - Example:
    ```dockerfile
    FROM golang:1.16 AS builder
    WORKDIR /app
    COPY . .
    RUN go build -o main .

    FROM alpine:latest
    WORKDIR /root/
    COPY --from=builder /app/main .
    CMD ["./main"]
    ```
---

## Docker Build Secrets

A build secret is sensitive information, such as a password or API token, used in your application's build process. 
- Unlike` build arguments or environment variables, which persist in the final image`, build secrets are securely exposed to the build process without being included in the final image.

#### **Secret Mounts**

Secret mounts allow you to expose secrets to build containers as files. 
- This is done using the `--mount` flag in `RUN` instructions within the Dockerfile.

- **Example Usage**:
  ```dockerfile
  RUN --mount=type=secret,id=mytoken \
      TOKEN=$(cat /run/secrets/mytoken) ...
  ```

- **Passing Secrets to Build**:
  ```sh
  docker build --secret id=mytoken,src=$HOME/.aws/credentials .
  ```

#### **Sources of Secrets**

Secrets can be sourced from either files or environment variables. The type can be detected automatically or specified explicitly.

- **From Environment Variable**:
  ```sh
  docker build --secret id=kube,env=KUBECONFIG .
  ```

- **Default Binding**:
  ```sh
  docker build --secret id=API_TOKEN .
  ```
  This mounts the value of `API_TOKEN` to `/run/secrets/API_TOKEN`.

#### **Customizing Mount Points**

By default, secrets are mounted to `/run/secrets/<id>`. You can customize this using the `target` option.

- **Example**:
  ```sh
  docker build --secret id=aws,src=/root/.aws/credentials .
  ```

  ```dockerfile
  RUN --mount=type=secret,id=aws,target=/root/.aws/credentials \
      aws s3 cp ...
  ```

#### **SSH Mounts**

SSH mounts are used for credentials like SSH agent sockets or keys, commonly for cloning private Git repositories.

- **Example Dockerfile**:
  ```dockerfile
  # syntax=docker/dockerfile:1
  FROM alpine
  ADD git@github.com:me/myprivaterepo.git /src/
  ```

- **Passing SSH Socket**:
  ```sh
  docker buildx build --ssh default .
  ```

#### **Git Authentication for Remote Contexts**

BuildKit supports `GIT_AUTH_TOKEN` and `GIT_AUTH_HEADER` for HTTP authentication with private Git repositories.

- **Example**:
  ```sh
  GIT_AUTH_TOKEN=$(cat gitlab-token.txt) docker build \
      --secret id=GIT_AUTH_TOKEN \
      https://gitlab.com/example/todo-app.git
  ```

- **Using with `ADD`**:
  ```dockerfile
  FROM alpine
  ADD https://gitlab.com/example/todo-app.git /src
  ```

#### **HTTP Authentication Scheme**

By default, Git authentication uses the Bearer scheme. For Basic authentication, set the `GIT_AUTH_HEADER` secret.

- **Example**:
  ```sh
  export GIT_AUTH_TOKEN=$(cat gitlab-token.txt)
  export GIT_AUTH_HEADER=basic
  docker build \
      --secret id=GIT_AUTH_TOKEN \
      --secret id=GIT_AUTH_HEADER \
      https://gitlab.com/example/todo-app.git
  ```

#### **Multiple Hosts**

You can set `GIT_AUTH_TOKEN` and `GIT_AUTH_HEADER` secrets on a per-host basis.

- **Example**:
  ```sh
  export GITLAB_TOKEN=$(cat gitlab-token.txt)
  export GERRIT_TOKEN=$(cat gerrit-username-password.txt)
  export GERRIT_SCHEME=basic
  docker build \
      --secret id=GIT_AUTH_TOKEN.gitlab.com,env=GITLAB_TOKEN \
      --secret id=GIT_AUTH_TOKEN.gerrit.internal.example,env=GERRIT_TOKEN \
      --secret id=GIT_AUTH_HEADER.gerrit.internal.example,env=GERRIT_SCHEME \
      https://gitlab.com/example/todo-app.git
  ```
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
----
## Docker Build Arguments

Docker build arguments (`ARG`) provide a flexible way to pass variables to the Docker build process.
#### **Key Features of Build Arguments**

1. **Definition and Usage**:
   - **`ARG` Instruction**: Defines a variable that users can pass at build-time to the Dockerfile.
   - **Example**:
     ```dockerfile
     ARG GO_VERSION=1.21
     FROM golang:${GO_VERSION}-alpine AS base
     ```

2. **Passing Build Arguments**:
   - Use the `--build-arg` flag with the `docker build` command to pass build arguments.
   - **Example**:
     ```sh
     docker build --build-arg GO_VERSION=1.19 .
     ```

3. **Default Values**:
   - If a build argument is not provided during the build, Docker uses the default value specified in the Dockerfile.

#### **Practical Use Cases**

1. **Changing Runtime Versions**:
   - Build arguments can be used to specify different versions of runtime environments, such as Go or Node.js, without modifying the Dockerfile for each version.
   - **Example**:
     ```dockerfile
     ARG GO_VERSION=1.21
     FROM golang:${GO_VERSION}-alpine AS base
     ```

2. **Injecting Values into Source Code**:
   - Build arguments can be used to inject values into the application's source code at build time, avoiding hard-coded values.


#### **Example Workflow**

1. **Define Build Arguments in Dockerfile**:
   ```dockerfile
   ARG GO_VERSION=1.21
   FROM golang:${GO_VERSION}-alpine AS base
   WORKDIR /src
   RUN --mount=type=cache,target=/go/pkg/mod/ \
       --mount=type=bind,source=go.sum,target=go.sum \
       --mount=type=bind,source=go.mod,target=go.mod \
       go mod download -x

   FROM base AS build-client
   RUN --mount=type=cache,target=/go/pkg/mod/ \
       --mount=type=bind,target=. \
       go build -o /bin/client ./cmd/client

   FROM base AS build-server
   ARG APP_VERSION="v0.0.0+unknown"
   RUN --mount=type=cache,target=/go/pkg/mod/ \
       --mount=type=bind,target=. \
       go build -ldflags "-X main.version=$APP_VERSION" -o /bin/server ./cmd/server

   FROM scratch AS client
   COPY --from=build-client /bin/client /bin/
   ENTRYPOINT [ "/bin/client" ]

   FROM scratch AS server
   COPY --from=build-server /bin/server /bin/
   ENTRYPOINT [ "/bin/server" ]
   ```

2. **Build with Custom Arguments**:
   ```sh
   docker build --build-arg GO_VERSION=1.19 --build-arg APP_VERSION=v0.0.1 --tag=buildme-server .
   ```

3. **Run the Container**:
   ```sh
   docker run buildme-server
   ```

   - The output should show the injected version:
     ```
     2023/04/06 08:54:27 Version: v0.0.1
     2023/04/06 08:54:27 Starting server...
     2023/04/06 08:54:27 Listening on HTTP port 3000
     ```

#### **Summary**

- **Flexibility**: allowing for dynamic configuration.
- **Customization** customization of runtime versions and the injection of values into source code.
## Docker Build Cache

#### **How the Build Cache Works**

- **Layered Architecture**: Each instruction in a Dockerfile creates a new layer.
- **Cache Invalidation**: When a layer changes, Docker invalidates that layer and all subsequent layers.

#### **Optimizing Build Cache Usage**

1. **Order Your Layers**:
   - Place instructions that change frequently (like copying source code) at the end of the Dockerfile.
   - Example:
     ```dockerfile
     # Inefficient
     COPY . .
     RUN npm install
     RUN npm build

     # Efficient
     COPY package.json yarn.lock .
     RUN npm install
     COPY . .
     RUN npm build
     ```

2. **Keep Layers Small**:
   - Use a `.dockerignore` file to exclude files and directories that are not needed.

3. **Use the `RUN` Cache**:
   - Use `RUN --mount=type=cache` to cache directories between builds.

4. **Minimize the Number of Layers**:
   - Combine multiple commands into a single `RUN` instruction using `&&`.
   

5. **Use Multi-Stage Builds**:
   - Split the build process into multiple stages to keep the final image small and efficient.
   - Example:
     ```dockerfile
     FROM alpine as builder
     RUN apk add git
     WORKDIR /repo
     RUN git clone https://github.com/your/repository.git .

     FROM nginx
     COPY --from=builder /repo/docs/ /usr/share/nginx/html
     ```

6. **Use Appropriate Base Images**
---
### Docker Builders

Docker builders are BuildKit daemons used to execute the build steps in a Dockerfile to produce container images or other artifacts. BuildKit is a powerful build engine that enhances the efficiency and flexibility of Docker builds. Here’s a detailed explanation based on the Docker documentation:

#### **Key Concepts**

1. **Default Builder**:
   - Docker Engine automatically creates a default builder that uses the BuildKit library bundled with the daemon.
   - This default builder is directly bound to the Docker daemon and its context. Changing the Docker context will also change the default builder context.

2. **Build Drivers**:
   - Build drivers refer to different builder configurations supported by Buildx. The main build drivers are:
     - **`docker`**: Uses the BuildKit library bundled into the Docker daemon.
     - **`docker-container`**: Creates a dedicated BuildKit container using Docker.
     - **`kubernetes`**: Creates BuildKit pods in a Kubernetes cluster.
     - **`remote`**: Connects directly to a manually managed BuildKit daemon.

3. **Selected Builder**:
   - The selected builder is the default builder used when running build commands.
   - You can specify a builder by name using the `--builder` flag or the `BUILDX_BUILDER` environment variable.
   - Use `docker buildx ls` to list available builder instances and see the selected builder (indicated by an asterisk `*`).
---
## **Managing Builders**

1. **Create a New Builder**:
   - You can create new builders using the `docker buildx create` command.
   - By default, the `docker-container` driver is used if no `--driver` flag is specified.
   - Example:
     ```sh
     docker buildx create --name my_builder
     ```

2. **List Available Builders**:
   - Use `docker buildx ls` to see builder instances available on your system and the drivers they are using.
     ```sh
     docker buildx ls
     ```
     Output:
     ```
     NAME/NODE      DRIVER/ENDPOINT      STATUS   BUILDKIT PLATFORMS
     default *      docker               running  v0.11.6 linux/amd64, linux/amd64/v2, linux/amd64/v3, linux/386
     my_builder     docker-container     running  v0.11.6 linux/amd64, linux/amd64/v2, linux/amd64/v3, linux/386
     ```

3. **Switch Between Builders**:
   - Use `docker buildx use <name>` to switch between builders.
   - Example:
     ```sh
     docker buildx use my_builder
     ```

4. **Inspect a Builder**:
   - Use `docker buildx inspect <builder-name>` 


### What is Asterix In Builder
   - This selected builder is the default for build operations executed via the Docker CLI.
   - The asterisk (*) next to a builder name in Docker indicates the **currently selected builder**. 

### **Dockershim**

Dockershim was a component in Kubernetes that allowed the use of Docker Engine as a container runtime. 
- It was introduced because Docker Engine was not compatible with the Container Runtime Interface (CRI) when CRI was first released. 
- Dockershim acted as a bridge between Docker Engine and CRI. However, maintaining Dockershim introduced complexity and inconsistency, leading to its deprecation and removal in Kubernetes v1.24. 
- Users are encouraged to migrate to other CRI-compatible runtimes like containerd or CRI-O.

### **Scratch Images**

The `scratch` image is the most minimal base image in Docker, containing zero bytes. 
- It serves as the starting point for building other images. When you create a Docker image from `scratch`, you are essentially starting with an empty filesystem. 
- This is useful for creating lightweight images.

### **Alpine Images**
Docker Alpine is a Dockerized version of Alpine Linux
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
Running multiple Docker Compose instances on the same machine can be achieved using several methods. Here are the key approaches:

## **Using Different Project Names**

Docker Compose allows you to run multiple instances of the same or different Compose files by specifying different project names. This can be done using the `-p` or `--project-name` option:

```sh
docker-compose -p project1 up -d
docker-compose -p project2 up -d
```

## **Using Multiple Compose Files**
You can also run multiple Docker Compose files simultaneously by specifying them with the `-f` option. 

```sh
docker-compose -f docker-compose1.yml -f docker-compose2.yml up -d
```

## **Environment Variable Interpolation**

For scenarios where you need to run the same Compose file but with different configurations (e.g., different ports), you can use environment variables:

```yaml
# docker-compose.yml
services:
  app:
    image: myapp
    ports:
      - "${APP_PORT}:80"
```
```sh
APP_PORT=8080 docker-compose -p project1 up -d
APP_PORT=8081 docker-compose -p project2 up -d
```

## **Using Override Files**

Docker Compose supports override files, which can be used to extend or modify the base configuration. By default, Docker Compose reads `docker-compose.yml` and `docker-compose.override.yml`. You can specify additional override files:

```sh
docker-compose -f docker-compose.yml -f docker-compose.override.yml -f custom-override.yml up -d
```

This method allows you to maintain a base configuration and apply specific overrides as needed.

## **Handling Shared Resources**

When running multiple instances, ensure that shared resources such as ports and volumes do not conflict. Use unique ports for each instance and, if necessary, separate volumes or bind mounts:

```yaml
# docker-compose.yml
services:
  app:
    image: myapp
    ports:
      - "${APP_PORT}:80"
    volumes:
      - "app_data_${APP_INSTANCE}:/data"
```

Start each instance with different environment variables:

```sh
APP_PORT=8080 APP_INSTANCE=1 docker-compose -p project1 up -d
APP_PORT=8081 APP_INSTANCE=2 docker-compose -p project2 up -d
```
A reverse proxy in Docker serves several important functions, enhancing the management and accessibility of multiple services running in containers. Here are the key uses:

## Simplified Access to Services

1. **Single Entry Point**: A reverse proxy allows users to access multiple services through a single domain or IP address, eliminating the need to remember various ports. For example, instead of accessing services like `docker.homelab.mydomain.com:0000`, users can simply use `plex.mydomain.com`[1][2].

2. **Domain-Based Routing**: It enables routing requests based on the domain name, allowing different applications to be accessed through distinct subdomains. This is particularly useful for microservices architectures where multiple services are hosted on the same server[2][5].

## Security and Control

1. **Access Control**: By routing traffic through a reverse proxy, you can restrict direct access to backend services, enhancing security. For instance, services can be configured to only be accessible via the reverse proxy, preventing direct access through their exposed ports[4].

2. **SSL Termination**: A reverse proxy can handle SSL certificates, providing HTTPS support for all services behind it. This simplifies certificate management and enhances security by ensuring encrypted connections from clients to the proxy[2][5].

## Load Balancing and Performance

1. **Load Balancing**: A reverse proxy can distribute incoming traffic across multiple backend services, helping to balance the load and improve performance. This is particularly beneficial for applications with high traffic.

2. **Caching**: It can cache responses from backend services, reducing the load on those services and improving response times for clients.

## Dynamic Configuration

1. **Automatic Configuration**: Tools like Traefik and Nginx Proxy Manager allow for dynamic configuration of reverse proxies based on Docker labels or environment variables. 
- This means that as new containers are added or removed, the reverse proxy can automatically update its routing without manual intervention.

### EXEC COMMAND
- You can only execute commands in running conainers and not stopped containers.
In Docker, `ARG` and `ENV` are both used to define variables in a Dockerfile, but they serve different purposes and have different scopes. Here’s a detailed comparison:

## ARG (Build-time Variables)

- **Scope**: `ARG` variables are only available during the image build process. They cannot be accessed in the running container.
  
- **Usage**: Typically used to pass build-time variables that can influence how the image is built. For example, you might use `ARG` to specify a version of a software dependency that should be installed.

- **Default Values**: You can set default values for `ARG` variables in the Dockerfile, but they can also be overridden during the build process using the `--build-arg` flag:
  
  ```dockerfile
  ARG VERSION=1.0
  RUN echo "Building version $VERSION"
  ```

- **Example**: If you build your image with:
  
  ```bash
  docker build --build-arg VERSION=2.0 .
  ```

  The output will reflect the overridden version.

## ENV (Environment Variables)

- **Scope**: `ENV` variables are available both during the build process and in the running container. This means they can be accessed by the application running inside the container.

- **Usage**: Used to define environment variables that the application can use at runtime. 
  - This is useful for configuration values that may change between different environments (e.g., development, testing, production).

- **Default Values**: You can set default values for `ENV` variables in the Dockerfile, and these can be overridden when running the container using the `-e` flag:
  
  ```dockerfile
  ENV NODE_ENV=production
  ```

- **Example**: When you run your container with:
  
  ```bash
  docker run -e NODE_ENV=development your-image
  ```

## Key Differences

1. **Lifetime**: 
   - `ARG` is only available during the build phase.
   - `ENV` is available during both the build phase and runtime.

2. **Accessibility**:
   - `ARG` cannot be accessed from the running container.
   - `ENV` can be accessed from the running container.

3. **Overriding**:
   - `ARG` values can be overridden at build time with `--build-arg`.
   - `ENV` values can be overridden at runtime with `-e`.

4. **Use Cases**:
   - Use `ARG` for build-time configurations (like version numbers).
   - Use `ENV` for runtime configurations (like environment settings).

### Instructions That Create Layers

1. **RUN**: Executes a command in the shell, modifying the filesystem. Each `RUN` command creates a new layer.
   
   Example:
   ```dockerfile
   RUN apt-get update && apt-get install -y curl
   ```

2. **COPY**: Copies files and directories from the host filesystem into the image. This instruction also creates a new layer.

   Example:
   ```dockerfile
   COPY . /app
   ```

3. **ADD**: Similar to `COPY`, but also supports remote URLs and automatic unpacking of compressed files. It creates a new layer as well.

   Example:
   ```dockerfile
   ADD myapp.tar.gz /app
   ```

### Instructions That Do Not Create Layers

- **LABEL**: Adds metadata to the image but does not modify the filesystem in a way that creates a new layer.  
- **ENTRYPOINT** and **CMD**: These define how the container should run but do not create layers that increase the image size.
### Layer Caching

Docker uses a caching mechanism for layers. If a layer has not changed since the last build, Docker will reuse the cached layer, which speeds up the build process. 
- This is why the order of instructions in a Dockerfile is important; optimizing the order can help take advantage of the cache effectively.
