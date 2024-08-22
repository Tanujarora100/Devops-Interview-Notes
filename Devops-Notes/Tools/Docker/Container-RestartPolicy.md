

## Docker Restart Policies

### 1. **no (Default)**
- **Use Case:** This policy is useful for short-lived containers where you don't want them to restart automatically, such as containers used for one-time tasks or debugging.

```bash
docker run --name my_container --restart no nginx
```

### 2. **always**
```bash
docker run --name my_container --restart always nginx
```

### 3. **on-failure**
- **Use Case:** Suitable for containers that might fail occasionally due to transient errors, where you want to limit the number of restart attempts.

```bash
docker run --name my_container --restart on-failure nginx
```

**With Maximum Retry Count:**
```bash
docker run --name my_container --restart on-failure:5 nginx
```
In this case, Docker will attempt to restart the container up to 5 times if it fails.

### 4. **unless-stopped**

- **Behavior:** The container will always be restarted unless it was explicitly stopped by the user (using `docker stop` or `docker kill`). Like the `always` policy, it will also restart the container if the Docker daemon is restarted.
- **Use Case:** Useful for services that should run continuously but can be stopped manually when needed. This policy is like `always` but with more control over manual stops.

**Example:**
```bash
docker run --name my_container --restart unless-stopped nginx
```

### Summary of Restart Policies:

| Policy          | Restart After Failure | Restart After Docker Daemon Restarts | Manual Stop Needed? |
|-----------------|-----------------------|--------------------------------------|---------------------|
| **no**          | No                    | No                                   | No                  |
| **always**      | Yes                   | Yes                                  | Yes                 |
| **on-failure**  | Yes                   | No                                   | No                  |
| **unless-stopped** | Yes                | Yes                                  | No                  |

### How to Set Restart Policies

Restart policies are set using the `--restart` flag in the `docker run` command. Here are some examples:

- **Default policy (`no`):**
  ```bash
  docker run --restart no my_image
  ```

- **Always restart:**
  ```bash
  docker run --restart always my_image
  ```

- **Restart on failure with a maximum of 3 retries:**
  ```bash
  docker run --restart on-failure:3 my_image
  ```

- **Restart unless stopped manually:**
  ```bash
  docker run --restart unless-stopped my_image
  ```

### Changing Restart Policies on Existing Containers

```bash
docker update --restart always my_container
```