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
