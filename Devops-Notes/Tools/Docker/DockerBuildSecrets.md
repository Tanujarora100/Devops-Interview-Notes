
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