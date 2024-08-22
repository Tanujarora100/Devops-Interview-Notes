## Charactertics of Docker Image
- Rules for docker container
- runtime, libraries, environment variables
- Immutable
- Layered Structure
- Read only template

## Image from Existing Image

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