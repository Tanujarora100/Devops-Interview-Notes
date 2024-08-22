
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