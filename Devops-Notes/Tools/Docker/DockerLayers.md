
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
Docker uses a caching mechanism for layers. 
- If a layer has not changed since the last build, Docker will reuse the cached layer, which speeds up the build process. 
- This is why the order of instructions in a Dockerfile is important; optimizing the order can help take advantage of the cache effectively.
