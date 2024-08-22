## Dynamic Configuration

1. **Automatic Configuration**: Tools like Traefik and Nginx Proxy Manager allow for dynamic configuration of reverse proxies based on Docker labels or environment variables. 
- They can do it based on environment variables and labels.
- This means that as new containers are added or removed, the reverse proxy can automatically update its routing without manual intervention.

### EXEC COMMAND
- You can only execute commands in running conainers and not stopped containers.
- You cannot exec to paused containers also.

## ARG (Build-time Variables)

- **Scope**: `ARG` 
- Only during the image building process
- They are not stored in the final container.
  
- **Usage**: Typically used to pass build-time variables that can influence how the image is built. For example, you might use `ARG` to specify a version of a software dependency that should be installed.

- **Default Values**: You can set default values for `ARG` variables in the Dockerfile, but they can also be overridden during the build process using the `--build-arg` flag:
  
  ```dockerfile
  ARG VERSION=1.0
  FROM nginx:$VERSION
  ```

  ```bash
  docker build --build-arg VERSION=2.0 
  ```

## ENV (Environment Variables)

- **Scope**: `ENV` variables are available both during the build process and in the running container. This means they can be accessed by the application running inside the container.

- **Usage**: Used to define environment variables that the application can use at runtime. 
  - This is useful for configuration values that may change between different environments (e.g., development, testing, production).

- **Default Values**: You can set default values for `ENV` variables in the Dockerfile, and these can be overridden when running the container using the `-e` flag:
  
  ```dockerfile
  ENV NODE_ENV=production
  ```

- 
  
  ```bash
  docker run -e NODE_ENV=development your-image
  ```

## Key Differences

   - `ARG` is only available during the build phase.
   - `ENV` is available during both the build phase and runtime.
   - `ARG` cannot be accessed from the running container.
   - `ENV` can be accessed from the running container.
   - `ARG` values can be overridden at build time with `--build-arg`.
   - `ENV` values can be overridden at runtime with `-e`.
   - Use `ENV` for runtime configurations (like environment settings).
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


---