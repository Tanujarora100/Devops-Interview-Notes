
### Multi-Stage Docker File
```docker
# Stage 1: Build the React application
FROM node:22.4.0-alpine3.19 as staging
WORKDIR /app
COPY package*.json /app/
RUN npm install 
COPY . .
RUN npm run build


FROM nginx:stable-bookworm as nginx 
LABEL maintainer_email="tanujarora2703@gmail.com"

COPY --from=staging /app/build /usr/share/nginx/html
RUN chown -R nginx:nginx /usr/share/nginx/html
USER nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
