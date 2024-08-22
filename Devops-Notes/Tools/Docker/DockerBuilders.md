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