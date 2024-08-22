## Docker Build Context
It refers to the set of files and directories that are accessible to the Docker engine during the build process. 

#### **Types of Build Contexts**

1. **Local Directory**
   - The most common build context is a local directory. When you specify a local directory as the context, Docker includes all files and subdirectories within that directory.
   - Example:
     ```sh
     docker build -t myimage .
     ```

2. **Remote URL**
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

With Dockerfile `1.4 and Buildx v0.8+, Docker now supports multiple build contexts`. .

- Example:
  ```sh
  docker buildx build --build-context app1=app1/src --build-context app2=app2/src .
  ```