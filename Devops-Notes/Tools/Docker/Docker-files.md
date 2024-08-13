# DOCKER FILE FOR JAVA
```docker
FROM maven3:open-jdk17
WORKDIR /app 
COPY . .
RUN mvn clean install 
EXPOSE 8080
ENTRYPOINT["java","-jar",".m2/target/*.jar]
```

# DOCKER FILE FOR NODE 
```docker
FROM nodejs:alpine 
WORKDIR /app
COPY package*.json .
RUN npm install 
COPY . .
EXPOSE 6000
ENTRYPOINT ["npm", "start]
```

# DOCKER FILE FOR JAVA- GOOD PRACTICE FOLLOWED
```docker
FROM maven:3.8.7-openjdk-17 AS builder

ARG MAVEN_CLEAN_ARGS="clean"
ARG MAVEN_BUILD_ARGS="install -DskipTests"

WORKDIR /app

COPY . .
RUN mvn ${MAVEN_CLEAN_ARGS} ${MAVEN_BUILD_ARGS}

FROM openjdk:17-jdk-slim
ENV APP_HOME="/app"
ENV JAVA_OPTS="-Xmx256m"

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR ${APP_HOME}

COPY --from=builder /app/target/*.jar ${APP_HOME}/app.jar
RUN chown -R appuser:appgroup ${APP_HOME}
USER appuser
EXPOSE 8080

# Define the entry point for the container
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar ${APP_HOME}/app.jar"]

```
