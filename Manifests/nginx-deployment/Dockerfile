# Use the latest Ubuntu as the base image
FROM ubuntu:latest
RUN set -x && \
    apt update && apt install -y unzip curl && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    aws --version

RUN apt install -y nginx
WORKDIR /usr/share/nginx/html

COPY index.html ./index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
