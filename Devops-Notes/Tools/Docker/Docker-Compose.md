
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

